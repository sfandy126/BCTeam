//
//  BCImagePicker.h
//  BcExamApp
//
//  Created by beichen on 2022/2/23.
//  Copyright © 2022 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImage+Ex.h"

/**
    相册选择器，注意对象必须持有
 */
@interface BCImagePicker : NSObject

//selectedAssets 不支持，因为涉及到拍照，无法跟从相册中同步

/**
 当前剩余可选的图片个数
 */
@property (nonatomic,assign) NSInteger maxCount;
/**
 *选择照片完成的回调
 *
 */
@property (nonatomic,copy) void (^pickerPhotoFinishedBlock)(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto);

@property (nonatomic,copy) void (^cameraFinishedBlock)(NSDictionary<NSString *,id> *info);

- (void)showAlter;

@end

