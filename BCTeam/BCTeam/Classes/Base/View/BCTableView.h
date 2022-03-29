//
//  BCTableView.h
//  BcExamApp
//
//  Created by beichen on 2021/12/6.
//  Copyright © 2021 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCTableViewCell.h"

typedef NSInteger(^BCRowsBlock)(NSInteger section);
typedef UITableViewCell *(^BCCellForRowBlock)(UITableView *tableView, NSIndexPath *indexPath);

typedef NSString *(^EmptyTitleBlock)(void);
typedef UIImage *(^EmptyImageBlock)(void);
typedef void (^EmptyTapBlock)(void);


typedef NS_ENUM(NSInteger,BCListEmptyStyle) {
    ///默认不显示空样式
    BCListEmptyStyle_none,
    ///加载成功列表为空的样式
    BCListEmptyStyle_emptyData,
    ///加载失败，列表为空的样式
    BCListEmptyStyle_netFailed,
    ///加载失败，列表为空且可点击重新加载
    BCListEmptyStyle_againTry,
};

static NSString * const BCListEmptyTitle_noData = @"暂无数据";
static NSString * const BCListEmptyTitle_netFailed = @"网络异常，请重新加载!";

@interface BCTableView : UITableView

///必选，numberOfRowsInSection
@property (nonatomic,copy) BCRowsBlock rowsBlock;

///必选，return cell ;CellReuseIdentifier:BCIdentify(class),必须用指定方法初始化列表
@property (nonatomic,copy) BCCellForRowBlock cellForRowBlock;

///可选，默认为1,numberOfRowsInSection
@property (nonatomic,copy) NSInteger(^sectionsBlock)(void);

///可选，heightForRowAtIndexPath,不实现，则默认为自动布局
@property (nonatomic,copy) CGFloat(^rowHeightBlock)(NSIndexPath *indexPath);

///可选，didSelectRowAtIndexPath
@property (nonatomic,copy) void(^selectedRowBlock)(NSIndexPath *indexPath);

///可选，配置section
@property (nonatomic,copy) UIView * (^headBlock)(NSInteger section);
@property (nonatomic,copy) CGFloat (^headHeightBlock)(NSInteger section);

///可选，配置footer
@property (nonatomic,copy) UIView * (^footBlock)(NSInteger section);
@property (nonatomic,copy) CGFloat (^footHeightBlock)(NSInteger section);

///可选，配置willDisplayCell
@property (nonatomic,copy) void(^willDisplayCellBlock)(NSIndexPath *indexPath);

/***************************************************************Edit************************************************************************************************************/
///iOS11以下edit
//@property (nonatomic,copy) UITableViewCellEditingStyle (^editStyleBlock)(NSIndexPath *indexPath);
//@property (nonatomic,copy) NSString * (^editTitleBlock)(NSIndexPath *indexPath);
@property (nonatomic,copy) BOOL (^canEditBlock)(NSIndexPath *indexPath);
//@property (nonatomic,copy) void (^commitEditBlock)(UITableViewCellEditingStyle editingStyle,NSIndexPath *indexPath);
///iOS11以上edit
@property (nonatomic,copy) UISwipeActionsConfiguration * (^editSwipeBlock)(NSIndexPath *indexPath);

/***************************************************************EmptyData************************************************************************************************************/
///是否打开数据为空的样式，默认为开启
@property (nonatomic,assign) BOOL isOpenEmptyDataStyle;

///列表是否显示空样式,默认不显示
@property (nonatomic,assign) BCListEmptyStyle emptyStyle;

///必须在配置table之前配置才生效，默认为“暂无数据”
@property (nonatomic,copy) EmptyTitleBlock emptyTitleBlock;

///必须在配置table之前配置才生效，默认 “list_empty_data”
@property (nonatomic,copy) EmptyImageBlock emptyImageBlock;

///点击重试
@property (nonatomic,copy) EmptyTapBlock emptyTapBlock;

/******************************************************************************UIScrollViewDelegate**********************************************************************************/

@property (nonatomic,copy) void(^scrollViewDidScrollBlock)(UIScrollView *scrollView);

/****************************************************************************** init **********************************************************************************/

///使用block回调，初始化必须使用该方法
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style rowsCellClass:(NSArray<Class> *)cellClasss;

@end

