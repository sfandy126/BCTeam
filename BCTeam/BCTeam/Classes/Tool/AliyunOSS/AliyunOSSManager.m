//
//  AliyunOSSManager.m
//  VIA
//
//  Created by cy on 2017/2/7.
//  Copyright © 2017年 via. All rights reserved.
//

#import "AliyunOSSManager.h"
#import <AliyunOSSiOS/AliyunOSSiOS.h>

@interface TLCompressTempData : NSObject

@property (nonatomic,strong)NSData *imgData;
@property (nonatomic,assign)NSInteger index;
-(instancetype)initWithData:(NSData*)data index:(NSInteger)index;

@end

@implementation TLCompressTempData

-(instancetype)initWithData:(NSData *)data index:(NSInteger)index
{
    self = [super init];
    if(self){
        self.imgData = data;
        self.index = index;
    }
    return self;
}

@end

@interface UploadResultModel : NSObject
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) NSInteger index;
@end

@implementation UploadResultModel
@end

////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////



@interface AliyunOSSManager ()
@property (nonatomic,strong)OSSClient * client;

@end
// http://viaupload.oss-cn-shenzhen.aliyuncs.com/year/mouth/day/filename


@implementation AliyunOSSManager {
    NSString * callbackAddress;
    NSMutableDictionary * uploadStatusRecorder;
    NSString * currentUploadRecordKey;
    OSSPutObjectRequest * putRequest;
    OSSGetObjectRequest * getRequest;
    OSSResumableUploadRequest * resumableRequest;//断点上传
    BOOL isCancelled;
    BOOL isResumeUpload;
}


+ (instancetype)sharedInstance {
    static AliyunOSSManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [AliyunOSSManager new];
    });
    return instance;
}

/**
 *    @brief    设置server callback地址
 *
 *     address
 */
- (void)setCallbackAddress:(NSString *)address {
    callbackAddress = address;
}

#pragma mark - 从服务器获取阿里云的token信息那些
-(void)refreshOssInfoWithSuccess:(void(^)(BOOL isSuccess,AliyunOSSModel *ossModel))blockResult {
    [BCNetwork POSTRequstWithParams:@{} cmd:@"oss_info.html" successBlock:^(NSDictionary *dict) {
        AliyunOSSModel *ossModel = [AliyunOSSModel mj_objectWithKeyValues:dict[@"data"][@"info"]];
        if(blockResult){
            blockResult(true,ossModel);
        }
    } failedBlock:^(NSString *msg) {
        if(blockResult){
            blockResult(false,nil);
        }
    } loginOutBlock:^{
        if(blockResult){
            blockResult(false,nil);
        }
    }];
}
#pragma mark - 初始化阿里云
- (void)initOSSClient {
    [self initOssclientWithBlock:nil];
}
- (void)initOssclientWithBlock:(void(^)(BOOL respost))resultBlock {
    [self refreshOssInfoWithSuccess:^(BOOL isSuccess, AliyunOSSModel *ossModel) {
        if(isSuccess){
            id<OSSCredentialProvider> credential =  [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken * _Nullable{
                return [self getFederationToken];
            }];
            //self.ossModel = ossModel;
            [AliyunOSSManager sharedInstance].ossModel = ossModel;
            OSSClientConfiguration * conf = [OSSClientConfiguration new];
            conf.maxRetryCount = 1; // 网络请求遇到异常失败后的重试次数
            conf.timeoutIntervalForRequest = 30; // 网络请求的超时时间
            conf.timeoutIntervalForResource = 3600; // 24 * 60 * 60; // 允许资源传输的最长时间
            self.client = [[OSSClient alloc] initWithEndpoint:ossModel.Endpoint credentialProvider:credential clientConfiguration:conf];
            if(self.client){
                if(resultBlock){
                    resultBlock(true);
                }
            }else{
                if(resultBlock){
                    resultBlock(false);
                }
            }
        }
    }];
}

#pragma mark - token 失效的时候更新token的函数
- (OSSFederationToken*)getFederationToken {
    OSSTaskCompletionSource * tcs = [OSSTaskCompletionSource taskCompletionSource];
    
    [self refreshOssInfoWithSuccess:^(BOOL isSuccess, AliyunOSSModel *ossModel) {
        if(isSuccess){
            self.ossModel = ossModel;
            [tcs setResult:ossModel];
        }else{
            NSError *error = [[NSError alloc]initWithDomain:@"获取token出错" code:0 userInfo:@{@"reason":@"服务器出错"}];
            [tcs setError:error];
        }
    }];
    [tcs.task waitUntilFinished];
    if (tcs.task.error) {
        BCLog(@"get token error: %@", tcs.task.error);
        return nil;
    } else {
        OSSFederationToken * token = [OSSFederationToken new];
        token.tAccessKey = self.ossModel.AccessKeyId;
        token.tSecretKey = self.ossModel.AccessKeySecret;
        token.tToken = self.ossModel.SecurityToken;
        token.expirationTimeInGMTFormat = self.ossModel.Expiration;
        BCLog(@"get token: %@", token);
        return token;
    }
    return nil;
}


/**
 *    @brief    上传图片
 *
 *    @param     objectKey     objectKey
 *    @param     filePath     路径
 */
- (void)asyncPutImage:(NSString *)objectKey
        localFilePath:(NSString *)filePath resultBlock:(ossResult)block {
    
    if(!self.client){
        BCLog(@"阿里云未服务未初始化");
        [self initOssclientWithBlock:^(BOOL respost) {
            if(respost){
                [self asyncPutImage:objectKey localFilePath:filePath resultBlock:block];
            }else{
                if(block){
                    block(NO);
                }
            }
        }];
        return;
    }
    
    if (objectKey == nil || [objectKey length] == 0) {
        if(block){
            block(NO);
        }
        return;
    }
    
    putRequest = [OSSPutObjectRequest new];
    putRequest.bucketName = self.ossModel.BucketName;
    putRequest.objectKey = objectKey;
    putRequest.uploadingFileURL = [NSURL fileURLWithPath:filePath];
    putRequest.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        BCLog(@"当前上传段长度：%lld,已经上传长度 %lld, 需上传总长度%lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    if (callbackAddress != nil) {
        putRequest.callbackParam = @{
                                     @"callbackUrl": callbackAddress,
                                     // callbackBody可自定义传入的信息
                                     @"callbackBody": @"filename=${object}"
                                     };
    }
    OSSTask * task = [self.client putObject:putRequest];
    [task continueWithBlock:^id(OSSTask *task) {
        OSSPutObjectResult * result = task.result;
        // 查看server callback是否成功
        if (!task.error) {
            BCLog(@"Put image success!");
            BCLog(@"server callback : %@", result.serverReturnJsonString);
            dispatch_async(dispatch_get_main_queue(), ^{
                if(block){
                    block(YES);
                }
            });
        } else {
            BCLog(@"Put image failed, %@", task.error);
            if (task.error.code == OSSClientErrorCodeTaskCancelled) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(block){
                        block(NO);
                    }
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(block){
                        block(NO);
                    }
                });
            }
        }
        self->putRequest = nil;
        return nil;
    }];
}

/// 上传图片
/// @param data 图片的数据流
/// @param upResult 回调
-(void)asyncPutImagedata:(NSData *)data resultBlock:(UPResult)upResult{
    UIImage *image = [UIImage imageWithData:data];
    AliyunOSSModel *model = [AliyunOSSManager sharedInstance].ossModel;
    NSString *randomStr = [NSString stringWithFormat:@"%ld%ld%ld%ld",(NSInteger)arc4random()%7777,(long)[NSDate date].timeIntervalSince1970,(long)image.size.width,(long)image.size.height];
    NSString * fileName = [NSString stringWithFormat:@"%@/%@.png",[self getTimeWithFormat:@"yyyy-MM-dd"],randomStr];
    NSString *fileUrl = [NSString stringWithFormat:@"https://%@.%@/%@",model.BucketName,model.Endpoint,fileName];
    //BCLog(@"fileUrl:%@",fileUrl);
    [self asyncPutImage:fileName data:data resultBlock:^(BOOL isSuccess) {
        if (isSuccess) {
            upResult(fileUrl);
        }else{
            upResult(nil);
        }
    }];
}

/// 上传视频（mp4格式）
/// @param filePath 视频路径
/// @param upResult 回调
-(void)asyncPutVedioPath:(NSString *)filePath resultBlock:(UPResult)upResult{
    AliyunOSSModel *model = [AliyunOSSManager sharedInstance].ossModel;
    NSString * fileName = [NSString stringWithFormat:@"%@/IOS%ld%ld.mp4",[self getTimeWithFormat:@"yyyy/MM/dd"],(NSInteger)arc4random()%7777,(NSInteger)[NSDate date].timeIntervalSince1970];
    NSString *fileUrl = [NSString stringWithFormat:@"https://%@.%@/%@",model.BucketName,model.Endpoint,fileName];
    BCLog(@"fileUrl:%@",fileUrl);
    NSData *mediaData = [NSData dataWithContentsOfURL:[NSURL URLWithString:filePath]];
    [self asyncPutImage:fileName data:mediaData resultBlock:^(BOOL isSuccess) {
        if (isSuccess) {
            upResult(fileUrl);
        }else{
            upResult(nil);
        }
    }];
}

/// 上传其它类型的文件
/// @param suffix 后缀名称
/// @param data 文件的数据流对象
/// @param upResult 回调
- (void)asyncPutFileWithSuffix:(NSString *)suffix fileData:(NSData *)data resultBlock:(UPResult)upResult{
    AliyunOSSModel *model = [AliyunOSSManager sharedInstance].ossModel;
    NSString *randomStr = [NSString stringWithFormat:@"%ld%ld%ld%ld",(NSInteger)arc4random()%7777,(long)[NSDate date].timeIntervalSince1970,(NSInteger)arc4random()%10000,(NSInteger)arc4random()%100000];
    NSString * fileName = [NSString stringWithFormat:@"%@/%@.%@",[self getTimeWithFormat:@"yyyy-MM-dd"],randomStr,suffix];
    NSString *fileUrl = [NSString stringWithFormat:@"https://%@.%@/%@",model.BucketName,model.Endpoint,fileName];
    [self asyncPutImage:fileName data:data resultBlock:^(BOOL isSuccess) {
        if (isSuccess) {
            upResult(fileUrl);
        }else{
            upResult(nil);
        }
    }];
}

#pragma mark - 上传图片
- (void)asyncPutImage:(NSString *)objectKey data:(NSData*)data resultBlock:(ossResult)block {
    if(!self.client){
        BCLog(@"阿里云未服务未初始化");
        [self initOssclientWithBlock:^(BOOL respost) {
            if(respost){
                [self asyncPutImage:objectKey data:data resultBlock:block];
            }else{
                if(block){
                    block(NO);
                }
            }
        }];
        return;
    }
    if (objectKey == nil || [objectKey length] == 0) {
        if(block){
            block(NO);
        }
        return;
    }
    putRequest = [OSSPutObjectRequest new];
    putRequest.bucketName = self.ossModel.BucketName;
    putRequest.objectKey = objectKey;
    putRequest.uploadingData = data;
    putRequest.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        BCLog(@"当前上传段长度：%lld,已经上传长度 %lld, 需上传总长度%lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    if (callbackAddress != nil) {
        putRequest.callbackParam = @{
                                     @"callbackUrl": callbackAddress,
                                     // callbackBody可自定义传入的信息
                                     @"callbackBody": @"filename=${object}"
                                     };
    }
    OSSTask * task = [self.client putObject:putRequest];
    [task continueWithBlock:^id(OSSTask *task) {
        OSSPutObjectResult * result = task.result;
        // 查看server callback是否成功
        if (!task.error) {
            BCLog(@"Put image success!");
            BCLog(@"server callback : %@", result.serverReturnJsonString);
            dispatch_async(dispatch_get_main_queue(), ^{
                if(block){
                    block(YES);
                }
            });
        } else {
            BCLog(@"Put image failed, %@", task.error);
            if (task.error.code == OSSClientErrorCodeTaskCancelled) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(block){
                        block(NO);
                    }
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(block){
                        block(NO);
                    }
                });
            }
        }
        self->putRequest = nil;
        return nil;
    }];
    
}



/**
 *    @brief    下载图片
 *
 *         objectKey
 */
- (void)asyncGetImage:(NSString *)objectKey {
    
    if(!self.client){
        BCLog(@"阿里云未服务未初始化");
        [self initOssclientWithBlock:^(BOOL respost) {
            if(respost){
                [self asyncGetImage:objectKey];
            }
        }];
        return;
    }
    
    
    if (objectKey == nil || [objectKey length] == 0) {
        return;
    }
    getRequest = [OSSGetObjectRequest new];
    getRequest.bucketName = self.ossModel.BucketName;
    getRequest.objectKey = objectKey;
    OSSTask * task = [self.client getObject:getRequest];
    [task continueWithBlock:^id(OSSTask *task) {
        //OSSGetObjectResult * result = task.result;
        if (!task.error) {
            BCLog(@"Get image success!");
            dispatch_async(dispatch_get_main_queue(), ^{
            });
        } else {
            BCLog(@"Get image failed, %@", task.error);
            if (task.error.code == OSSClientErrorCodeTaskCancelled) {
                dispatch_async(dispatch_get_main_queue(), ^{
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                });
            }
        }
        self->getRequest = nil;
        return nil;
    }];
}

- (void)doResumableUpload {
    
    if(!self.client){
        BCLog(@"阿里云未服务未初始化");
        [self initOssclientWithBlock:^(BOOL respost) {
            if(respost){
                [self doResumableUpload];
            }
        }];
        return;
    }

    
    resumableRequest.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        BCLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    OSSTask * resumeTask = [self.client resumableUpload:resumableRequest];
    [resumeTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            BCLog(@"Resumable put success!");
            // 清空该项纪录
            [self->uploadStatusRecorder removeObjectForKey:self->currentUploadRecordKey];
            if (self->isResumeUpload) {
                self->currentUploadRecordKey = @"";
                self->isResumeUpload = NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                });
            }
            
        } else {
            BCLog(@"Resumable put failed, %@", task.error);
            // 无法继续上传错误，删除该项记录，重新获取uploadId上传
            if ([task.error.domain isEqualToString:OSSClientErrorDomain] && task.error.code == OSSClientErrorCodeCannotResumeUpload) {
                [self->uploadStatusRecorder removeObjectForKey:self->currentUploadRecordKey];
            } else if ([[NSString stringWithFormat:@"%@", task.error] containsString:@"cancel"]) {
                BCLog(@"Resumable put cancel!");
                // 用户主动取消上传任务
                if (self->isCancelled) {
                    OSSAbortMultipartUploadRequest * abortRequest = [OSSAbortMultipartUploadRequest new];
                    abortRequest.bucketName = self->resumableRequest.bucketName;
                    abortRequest.objectKey = self->resumableRequest.objectKey;
                    abortRequest.uploadId = self->resumableRequest.uploadId;
                    OSSTask * task = [self.client abortMultipartUpload:abortRequest];
                    [task continueWithBlock:^id(OSSTask *task) {
                        if (!task.error) {
                            NSLog(@"断点上传删除服务端uploadId");
                        }
                        return nil;
                    }];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self->isCancelled = NO;
                        [self->uploadStatusRecorder removeObjectForKey:self->currentUploadRecordKey];
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                    });
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                });
            }
        }
        return nil;
    }];
}

/**
 *    @brief    断点上传，可暂停，然后恢复上传任务继续
 *          调用OSSResumableUpload，根据计算md5(fileMd5 + bucketName + objectKey + partSize),作为上传纪录key
 *    @param     objectKey     设置上传文件的objectKey
 *    @param     filePath     文件路径
 *    @param     size        分片大小
 */
- (void)resumableUpload:(NSString *)objectKey
          localFilePath:(NSString *)filePath
               partSize:(int)size {
    
    if(!self.client){
        BCLog(@"阿里云未服务未初始化");
        [self initOssclientWithBlock:^(BOOL respost) {
            if(respost){
                [self resumableUpload:objectKey localFilePath:filePath partSize:size];
            }
        }];
        return;
    }
    
    resumableRequest = [OSSResumableUploadRequest new];
    
    NSString * fileMd5 = [OSSUtil fileMD5String:filePath];
    
    // 从文件内容MD5、上传的目标地址、分片大小获取一个唯一标识
    NSString * recordIdentifier = [OSSUtil dataMD5String:
                                   [[NSString stringWithFormat:@"%@%@%@%d", fileMd5, self.ossModel.BucketName, objectKey, size] dataUsingEncoding:NSUTF8StringEncoding]];
    BCLog(@"upload record identifier: %@", recordIdentifier);
    currentUploadRecordKey = recordIdentifier;
    
    resumableRequest = [OSSResumableUploadRequest new];
    resumableRequest.bucketName = self.ossModel.BucketName;
    resumableRequest.objectKey = objectKey;
    resumableRequest.uploadingFileURL = [NSURL fileURLWithPath:filePath];
    resumableRequest.partSize = size;
    
    __block NSString * uploadId = [uploadStatusRecorder objectForKey:currentUploadRecordKey];
    if (uploadId == nil) {
        // get uploadId
        OSSInitMultipartUploadRequest * init = [OSSInitMultipartUploadRequest new];
        init.bucketName = self.ossModel.BucketName;
        init.objectKey = objectKey;
        OSSTask * task = [self.client multipartUploadInit:init];
        [task continueWithBlock:^id(OSSTask *task) {
            if (!task.error) {
                OSSInitMultipartUploadResult * result = task.result;
                self->resumableRequest.uploadId = result.uploadId;
                [self->uploadStatusRecorder setObject:result.uploadId forKey:self->currentUploadRecordKey];
                [self doResumableUpload];
            } else {
                NSLog(@"Get uploadId failed, %@", task.error);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
            }
            return nil;
        }];
    } else {
        isResumeUpload = YES;
        resumableRequest.uploadId = uploadId;
        [self doResumableUpload];
    }
}


/**
 *    @brief    断点续传暂停
 */
- (void)resumableUploadPause {
    if (!resumableRequest.isCancelled) {
        isCancelled = NO;
        [resumableRequest cancel];
    }
}

/**
 *    @brief    普通上传/下载取消
 */
- (void)normalRequestCancel {
    if (putRequest) {
        [putRequest cancel];
    }
    if (getRequest) {
        [getRequest cancel];
    }
}

/**
 *    @brief    断点上传任务取消
 */
- (void)ResumableUploadCancel {
    if (!resumableRequest.isCancelled) {
        isCancelled = YES;
        [resumableRequest cancel];
    }
}


- (void)asyncUpLoadImages:(NSArray*)images resultBlock:(TLUploadImgsResult)result{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSMutableArray *resultImgUrlArray = [NSMutableArray arrayWithCapacity:images.count];
    @weakify(self);
    [self compressImageActionWithImages:images resultBlock:^(NSMutableArray *resultDatas) {
        @strongify(self);
        if(resultDatas == nil || resultDatas.count == 0){
            if(result){
                result(@[]);
            }
            [MBProgressHUD showMessage:@"图片处理失败"];
            return ;
        }
        ///不能采用异步并行上传方式，这里采用了同步队列方式
        for (int i = 0; i<resultDatas.count; i++) {
            UploadResultModel *resultModel = [[UploadResultModel alloc]init];
            resultModel.index = i;
            TLCompressTempData *tempDataInfo = [resultDatas safeObjectAtIndex:i];
            dispatch_group_enter(group);
            dispatch_sync(queue, ^{
                @strongify(self);
                [self asyncPutImagedata:tempDataInfo.imgData resultBlock:^(NSString *urlStr) {
                    if(urlStr != nil){
                        resultModel.url = urlStr;
                        [resultImgUrlArray addObject:resultModel];
                    }
                    dispatch_group_leave(group);
                }];
            });
        }
        
        dispatch_group_notify(group, queue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if(result){
                    if (resultImgUrlArray.count > 1) {//超过1个就要进行重新排序
                        [resultImgUrlArray sortUsingComparator:^NSComparisonResult(UploadResultModel* obj1, UploadResultModel* obj2) {
                            return obj1.index > obj2.index;
                        }];
                    }
                    result([resultImgUrlArray valueForKey:@"url"]);
                }
            });
        });
    }];
}



/**
 图片的压缩要保证压缩完之后顺序不变
 */
- (void)compressImageActionWithImages:(NSArray*)images resultBlock:(void (^)(NSMutableArray*resultDatas))result;
{
    NSMutableArray *compressImageArray = [NSMutableArray arrayWithCapacity:images.count];
    __block BOOL isOk = YES;
    for (int i = 0; i<images.count; i++) {
        UIImage *loadImage = images[i];//
        NSInteger index = i;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           NSData *resultData = [self compressQualityWithMaxLength:1024*1024*0.5 image:loadImage];
            if(resultData == nil){
                isOk = NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                    //[hud hideAnimated:NO];
                    if(result){
                        result(nil);
                    }
                });
                return ;
            }
            TLCompressTempData *tempData = [[TLCompressTempData alloc]initWithData:resultData index:index];
            [compressImageArray addObject:tempData];
            if(compressImageArray.count == images.count){
                ///进行排序操作
                [compressImageArray sortUsingComparator:^NSComparisonResult(TLCompressTempData* obj1, TLCompressTempData* obj2) {
                    return obj1.index > obj2.index;
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(result){
                        result(compressImageArray);
                    }
                });
            }
        });
        if(isOk == NO){
            break;
        }
    }
}

- (void)compressImagesWithImages:(NSArray*)images resultBlock:(void (^)(NSMutableArray<NSData*>*datas))result;
{
    NSMutableArray *compressImageArray = [NSMutableArray arrayWithCapacity:images.count];
    __block BOOL isOk = YES;
    for (int i = 0; i<images.count; i++) {
        UIImage *loadImage = images[i];//
        NSInteger index = i;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           NSData *resultData = [self compressQualityWithMaxLength:1024*1024*0.5 image:loadImage];
            if(resultData == nil){
                isOk = NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(result){
                        result(nil);
                    }
                });
                return ;
            }
            TLCompressTempData *tempData = [[TLCompressTempData alloc]initWithData:resultData index:index];
            [compressImageArray addObject:tempData];
            if(compressImageArray.count == images.count){
                ///进行排序操作
                [compressImageArray sortUsingComparator:^NSComparisonResult(TLCompressTempData* obj1, TLCompressTempData* obj2) {
                    return obj1.index > obj2.index;
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSMutableArray *resultDatas = [NSMutableArray arrayWithCapacity:compressImageArray.count];
                    for (TLCompressTempData*temp in compressImageArray) {
                        [resultDatas addObject:temp.imgData];
                    }
                    if(result){
                        result(resultDatas);
                    }
                });
            }
        });
        if(isOk == NO){
            break;
        }
    }
}

- (NSString *)getTimeWithFormat:(NSString *)format
{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:currentDate];
}

- (NSData *)compressQualityWithMaxLength:(NSInteger)maxLength image:(UIImage *)image
{
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    //NSLog(@"Before compressing quality, image size = %ld KB",data.length/1024);
    if (data.length < maxLength) return data;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        //NSLog(@"Compression = %.1f", compression);
        //NSLog(@"In compressing quality loop, image size = %ld KB", data.length / 1024);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    //NSLog(@"After compressing quality, image size = %ld KB", data.length / 1024);
    if (data.length < maxLength) return data;
    UIImage *resultImage = [UIImage imageWithData:data];
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        //NSLog(@"Ratio = %.1f", ratio);
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
        //NSLog(@"In compressing size loop, image size = %ld KB", data.length / 1024);
    }
    //NSLog(@"After compressing size loop, image size = %ld KB", data.length / 1024);
    return data;
}

@end
