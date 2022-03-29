//
//  BCWebScriptMessageProtocol.m
//  BcExamApp
//
//  Created by beichen on 2021/10/26.
//  Copyright © 2021 apple. All rights reserved.
//

#import "BCWebScriptMessageProtocol.h"

///js调原生
///js调起开通vip支付
static NSString *BCOpenVipPayMethod = @"openVipPayMethod";
///js调起下载文档
static NSString *BCStartDownPdfDocment = @"startDownPdfDocmentMethod";

@interface BCWebScriptMessageProtocol ()<WKScriptMessageHandler>
@property (nonatomic,strong) WKUserContentController *userContent;
@end

@implementation BCWebScriptMessageProtocol

- (instancetype)initWithUserContent:(WKUserContentController *)userContent
{
    self = [super init];
    if (self) {
        self.userContent = userContent;
    }
    return self;
}

- (void)addScriptMessageHandlers{
    if (!self.userContent) {
        return;
    }
    /*
     js调用原生
     window.webkit.messageHandlers.对象名.postMessage(参数)
     */
    [self.userContent addScriptMessageHandler:self name:BCOpenVipPayMethod];
    [self.userContent addScriptMessageHandler:self name:BCStartDownPdfDocment];
}

- (void)removeAllScriptMessageHandlers{
    [self.userContent removeScriptMessageHandlerForName:BCOpenVipPayMethod];
    [self.userContent removeScriptMessageHandlerForName:BCStartDownPdfDocment];
}

#pragma mark - - WKScriptMessageHandler js调oc

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    if ([message.name isEqualToString:BCOpenVipPayMethod]) {
        //调起vip支付
        
    }
}

@end
