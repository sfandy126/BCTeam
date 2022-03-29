//
//  AliyunOSSManager.h
//  VIA
//
//  Created by cy on 2017/2/7.
//  Copyright © 2017年 via. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AliyunOSSModel.h"


typedef void (^ossResult)(BOOL isSuccess);
typedef void (^UPResult)(NSString *urlStr);
typedef void (^TLUploadImgsResult)(NSArray*urlList);
/**
 专门管理 oss 服务的管理者 工具类
 
 */

@interface AliyunOSSManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic,strong)AliyunOSSModel *ossModel;

/**
 采用的是 oss 提供的自动管理token 初始化方法
 */
- (void)initOSSClient;


/**设置回调 oss提供的一个回调*/
- (void)setCallbackAddress:(NSString *)address;
/**
 objectKey:文件名
 filePath :本地图片路径
 */
- (void)asyncPutImage:(NSString *)objectKey localFilePath:(NSString *)filePath resultBlock:(ossResult)block;

/**
 objectKey:文件名
 data     :图片数据流
 */
- (void)asyncPutImage:(NSString *)objectKey data:(NSData*)data resultBlock:(ossResult)block;

//上传图片
-(void)asyncPutImagedata:(NSData *)data resultBlock:(UPResult)upResult;


//上传视频
-(void)asyncPutVedioPath:(NSString *)filePath resultBlock:(UPResult)upResult;

/**上传其它类型的文件*/
- (void)asyncPutFileWithSuffix:(NSString *)suffix fileData:(NSData *)data resultBlock:(UPResult)upResult;

/// 上传多张图片 采用多线程方式， 并且顺序不会乱
/// @param images 需要上传的图片
/// @param result 回调结果
- (void)asyncUpLoadImages:(NSArray*)images resultBlock:(TLUploadImgsResult)result;

- (void)compressImagesWithImages:(NSArray*)images resultBlock:(void (^)(NSMutableArray<NSData*>*datas))result;

@end
