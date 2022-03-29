//
//  BCTableView.m
//  BcExamApp
//
//  Created by beichen on 2021/12/6.
//  Copyright © 2021 apple. All rights reserved.
//

#import "BCTableView.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface BCTableView ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,UIGestureRecognizerDelegate>

@end

@implementation BCTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style rowsCellClass:(NSArray<Class> *)cellClasss
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        for (Class class in cellClasss) {
            [self registerClass:class forCellReuseIdentifier:BCIdentify(class)];
        }
        [self config];
    }
    return self;
}

- (void)config{
    self.backgroundColor = UIColor.clearColor;
    self.delegate = self;
    self.dataSource = self;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.estimatedRowHeight = 40.f;
    self.rowHeight = UITableViewAutomaticDimension;
    self.estimatedSectionHeaderHeight = 0.0;
    self.estimatedSectionFooterHeight = 0.0;
    self.isOpenEmptyDataStyle = YES;
}

- (void)setIsOpenEmptyDataStyle:(BOOL)isOpenEmptyDataStyle{
    _isOpenEmptyDataStyle = isOpenEmptyDataStyle;
    if (isOpenEmptyDataStyle) {
        self.emptyDataSetSource = self;
        self.emptyDataSetDelegate = self;
    }else{
        self.emptyDataSetSource = nil;
        self.emptyDataSetDelegate = nil;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.sectionsBlock) {
        return self.sectionsBlock();
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.rowsBlock) {
        NSInteger rows = self.rowsBlock(section);
        return rows;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.rowHeightBlock) {
        CGFloat height = self.rowHeightBlock(indexPath);
        return height;
    }
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.headBlock) {
        return self.headBlock(section);
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.headHeightBlock) {
        CGFloat height = self.headHeightBlock(section);
        return height;
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.footBlock) {
        return self.footBlock(section);
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.footHeightBlock) {
        return self.footHeightBlock(section);
    }
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.willDisplayCellBlock) {
        self.willDisplayCellBlock(indexPath);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.cellForRowBlock) {
        UITableViewCell *cell = self.cellForRowBlock(tableView,indexPath);
        if (cell) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectedRowBlock) {
        self.selectedRowBlock(indexPath);
    }
}

#pragma mark - - edit ios 11以下

//-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCellEditingStyle style = UITableViewCellEditingStyleNone;
//    if (self.editStyleBlock) {
//        style = self.editStyleBlock(indexPath);
//    }
//    return style;
//}
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSString *title = @"";
//    if (self.editTitleBlock) {
//        title = self.editTitleBlock(indexPath);
//    }
//    return title;
//}

//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (self.commitEditBlock) {
//        self.commitEditBlock(editingStyle, indexPath);
//    }
//}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.canEditBlock) {
        return self.canEditBlock(indexPath);
    }
    return NO;
}

/////开始编辑侧滑
- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {

}
//结束左滑
- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(nullable NSIndexPath *)indexPath {

}

#pragma mark - - edit ios 11以上
- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.editSwipeBlock) {
        return self.editSwipeBlock(indexPath);
    }
    return nil;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.scrollViewDidScrollBlock) {
        self.scrollViewDidScrollBlock(scrollView);
    }
}

#pragma mark - - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    //@"UIGestureRecognizer (QMUI)", @"在手势进行过程中把手势禁用，可能让界面状态出现错乱！"
    //处理侧滑删除还未收起时，滑动列表，会导致页面错乱 ios13以下
//    [self setEditing:NO animated:NO];//此处代码会影响2个侧滑按钮，第一个无法点击
    return YES;
}

#pragma mark - DZNEmptyDataSetSource

///为空数据时，允许tableview滚动
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *title= BCListEmptyTitle_noData;
    if (self.emptyTitleBlock) {
        title = self.emptyTitleBlock();
    }
    return [[NSAttributedString alloc]initWithString:title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    UIImage *image = [UIImage imageNamed:@"list_empty_data"];
    if (self.emptyStyle == BCListEmptyStyle_netFailed || self.emptyStyle == BCListEmptyStyle_againTry) {
        //配置加载失败的图片
    }
    if (self.emptyImageBlock) {
        image = self.emptyImageBlock();
    }
    return image;
}

//- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
//    ///自定义view
//}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view{
    if (self.emptyTapBlock) {
        self.emptyTapBlock();
    }
}

//- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button{
//    
//}

//需要给出网络异常的样式,到时候再一起改
//- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
//    if (self.emptyStyle == BCListEmptyStyle_none) {
//        return NO;
//    }
//    return YES;
//}

@end
