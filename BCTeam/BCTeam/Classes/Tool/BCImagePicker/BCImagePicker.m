//
//  BCImagePicker.m
//  BcExamApp
//
//  Created by beichen on 2022/2/23.
//  Copyright © 2022 apple. All rights reserved.
//

#import "BCImagePicker.h"
#import "TZImagePickerController.h"

@interface BCImagePicker ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation BCImagePicker

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.maxCount = 1;
    }
    return self;
}

- (void)showAlter{
    UIAlertController *alter= [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    @weakify(self);
    UIAlertAction *alter1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self tryOpenCamera];
    }];
    [alter addAction:alter1];
    UIAlertAction *alter2 = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        TZImagePickerController *vc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:nil];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        vc.allowPickingVideo = NO;
        vc.allowPickingOriginalPhoto = YES;
        vc.maxImagesCount = self.maxCount;
        @weakify(self);
        [vc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            @strongify(self);
            if (self.pickerPhotoFinishedBlock) {
                self.pickerPhotoFinishedBlock(photos, assets, isSelectOriginalPhoto);
            }
        }];
        [[BCTool getCurrentVC] presentViewController:vc animated:YES completion:nil];
    }];
    UIAlertAction *alter3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alter addAction:alter2];
    [alter addAction:alter3];
    [alter1 setValue:BCHexColor(@"#1A1A1A") forKey:@"_titleTextColor"];
    [alter2 setValue:BCHexColor(@"#1A1A1A") forKey:@"_titleTextColor"];
    [alter3 setValue:BCHexColor(@"#1A1A1A") forKey:@"_titleTextColor"];
    [[BCTool getCurrentVC] presentViewController:alter animated:YES completion:nil];
}


- (void)tryOpenCamera{
    // 设备不可用  直接返回
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        return;
    }
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)) {
        
        NSDictionary *infoDict = [TZCommonTools tz_getInfoDictionary];
        // 无权限 做一个友好的提示
        NSString *appName = [infoDict valueForKey:@"CFBundleDisplayName"];
        if (!appName) appName = [infoDict valueForKey:@"CFBundleName"];
        if (!appName) appName = [infoDict valueForKey:@"CFBundleExecutable"];

        NSString *title = [NSBundle tz_localizedStringForKey:@"Can not use camera"];
        NSString *message = [NSString stringWithFormat:[NSBundle tz_localizedStringForKey:@"Please allow %@ to access your camera in \"Settings -> Privacy -> Camera\""],appName];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAct = [UIAlertAction actionWithTitle:[NSBundle tz_localizedStringForKey:@"Cancel"] style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAct];
        UIAlertAction *settingAct = [UIAlertAction actionWithTitle:[NSBundle tz_localizedStringForKey:@"Setting"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        }];
        [alertController addAction:settingAct];
        [[BCTool getCurrentVC] presentViewController:alertController animated:YES completion:nil];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self openCamera];
                });
            }
        }];
    } else {
        [self openCamera];
    }
}

- (void)openCamera{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        return;
    };
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imgPicker.delegate = self;
    imgPicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [[BCTool getCurrentVC] presentViewController:imgPicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    // 获取用户选择的图片
    if (self.cameraFinishedBlock) {
        self.cameraFinishedBlock(info);
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
