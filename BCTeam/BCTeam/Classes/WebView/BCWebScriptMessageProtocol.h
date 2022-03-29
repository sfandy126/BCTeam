//
//  BCWebScriptMessageProtocol.h
//  BcExamApp
//
//  Created by beichen on 2021/10/26.
//  Copyright © 2021 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
/*
 js与原生交互协议
 */
@interface BCWebScriptMessageProtocol : NSObject
@property (nonatomic,weak) UIViewController *handler;

- (instancetype)initWithUserContent:(WKUserContentController *)userContent;

- (void)addScriptMessageHandlers;

- (void)removeAllScriptMessageHandlers;

@end

