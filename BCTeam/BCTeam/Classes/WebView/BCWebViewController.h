//
//  BCWebViewController.h
//  BcExamApp
//
//  Created by apple on 2019/12/3.
//  Copyright © 2019 apple. All rights reserved.
//

#import "BCBaseViewController.h"

/** url类型 */
typedef NS_ENUM(NSInteger,BCUrlType){
    BCUrlTypeHtml    = 0, // html
    BCUrlTypeWebUrl       // url
};

@interface BCWebViewController : BCBaseViewController

///请求链接
@property (nonatomic,copy) NSString *url;

///标题
@property (nonatomic,copy) NSString *titleStr;

///加载类型，默认为url,否则为html
@property (nonatomic,assign) BCUrlType urlType;

@end

