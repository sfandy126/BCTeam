//
//  BCEnvironmentConfigController.m
//  BcExamApp
//
//  Created by beichen on 2021/12/13.
//  Copyright © 2021 apple. All rights reserved.
//

#import "BCEnvironmentConfigController.h"
#import "BCEnvironmentConfig.h"

///row type
typedef NS_ENUM(NSInteger,BCEnvType) {
    BCEnvType_testBaseURL,//api 测试环境
    BCEnvType_releaseBaseURL,//api 正式环境
    
    BCEnvType_pushDev,//推送开发环境
    BCEnvType_pushProduct,//推送发布环境
};

///section type
typedef NS_ENUM(NSInteger,BCEnvSectionType) {
    BCEnvSectionType_apiBaseURL,
    BCEnvSectionType_Push,//推送
};

@interface BCEnvItem : NSObject
@property (nonatomic,copy) NSString *title;
@property (nonatomic,assign) BCEnvType type;
@end
@implementation BCEnvItem
+ (id)modelWithDict:(NSDictionary *)dic{
    if ([NSDictionary isNotEmpty:dic]) {
        BCEnvItem *item = [BCEnvItem new];
        item.title = [dic valueForKey:@"title"];
        item.type = [[dic valueForKey:@"type"] integerValue];
        return item;
    }
    return nil;
}
@end

@interface BCEnvSectionModel : NSObject
@property (nonatomic,copy) NSString *title;
@property (nonatomic,assign) BCEnvSectionType sectionType;
@property (nonatomic,copy) NSArray *list;
@end
@implementation BCEnvSectionModel
+ (id)modelWithDict:(NSDictionary *)dic{
    if ([NSDictionary isNotEmpty:dic]) {
        BCEnvSectionModel *item = [BCEnvSectionModel new];
        item.title = [dic valueForKey:@"title"];
        item.sectionType = [[dic valueForKey:@"sectionType"] integerValue];
        NSArray *arr = [dic valueForKey:@"list"];
        NSMutableArray *temp = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            BCEnvItem *rowItem = [BCEnvItem modelWithDict:dic];
            if (rowItem) {
                [temp addObject:rowItem];
            }
        }
        item.list = [temp copy];
        return item;
    }
    return nil;
}
@end

@interface BCEnvCell : UITableViewCell
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIView *sepLine;
@property (nonatomic,strong) UILabel *selectLab;
@end

@implementation BCEnvCell

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = BCFont(15);
        _titleLabel.textColor = BCHexColor(@"#1A1A1A");
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _titleLabel;
}

- (UIView *)sepLine{
    if (!_sepLine) {
        _sepLine = [UIView new];
        _sepLine.backgroundColor = BCHexColor(@"#F6F6F6");
    }
    return _sepLine;
}
- (UILabel *)selectLab{
    if (!_selectLab) {
        _selectLab = [UILabel new];
        _selectLab.font = BCFont(15);
        _selectLab.text = @"✅";
        _selectLab.textColor = UIColor.redColor;
        _selectLab.hidden = YES;
    }
    return _selectLab;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.sepLine];
        [self.contentView addSubview:self.selectLab];

        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.height.mas_equalTo(self.titleLabel.font.pointSize);
            make.right.mas_equalTo(self.selectLab.mas_left).offset(-10);
            make.top.mas_equalTo(15);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-15);
        }];
        [self.sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel.mas_left);
            make.height.mas_equalTo(1);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
        }];
        [self.selectLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
    }
    return self;
}
@end

@interface BCEnvHeadView : UIView
@property (nonatomic,strong) UILabel *titleLabel;
@end

@implementation BCEnvHeadView

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = BCBoldFont(13);
        _titleLabel.textColor = BCHexColor(@"#1A1A1A");
    }
    return _titleLabel;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.height.mas_equalTo(self.titleLabel.font.pointSize);
            make.right.mas_equalTo(self.mas_right).offset(-15);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
    }
    return self;
}

@end

@interface BCEnvironmentConfigController ()
@property (nonatomic,strong) BCTableView *tableView;
@property (nonatomic,copy) NSArray *datalists;
@end

@implementation BCEnvironmentConfigController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"环境配置（修改后请重启app!）";
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    @weakify(self);
    self.tableView.sectionsBlock = ^NSInteger{
        @strongify(self);
        return self.datalists.count;
    };
    self.tableView.headBlock = ^UIView *(NSInteger section) {
        @strongify(self);
        BCEnvSectionModel *model = [self.datalists safeObjectAtIndex:section];
        BCEnvHeadView *view = [BCEnvHeadView new];
        view.frame = CGRectMake(0, 0, self.view.width, 30);
        view.titleLabel.text = model.title;
        return view;
    };
    self.tableView.headHeightBlock = ^CGFloat(NSInteger section) {
        return 40;
    };
    
    self.tableView.rowsBlock = ^NSInteger(NSInteger section) {
        @strongify(self);
        BCEnvSectionModel *model = [self.datalists safeObjectAtIndex:section];
        return model.list.count;
    };
    self.tableView.cellForRowBlock = ^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
        @strongify(self);
        BCEnvCell *cell = [tableView dequeueReusableCellWithIdentifier:BCIdentify([BCEnvCell class]) forIndexPath:indexPath];
        BCEnvSectionModel *model = [self.datalists safeObjectAtIndex:indexPath.section];
        BCEnvItem *item = [model.list safeObjectAtIndex:indexPath.row];
        cell.selectLab.hidden = YES;
        cell.titleLabel.text = item.title;

        if (model.sectionType == BCEnvSectionType_apiBaseURL) {
            NSString *baseUrl = [BCEnvironmentConfig getBaseUrl:(item.type == BCEnvType_testBaseURL?YES:NO)];
            cell.titleLabel.text = [NSString stringWithFormat:@"%@(%@)",item.title,baseUrl];
            if ([[BCEnvironmentConfig baseURLString] isEqualToString:baseUrl]) {
                cell.selectLab.hidden = NO;
            }
        }
        if (model.sectionType == BCEnvSectionType_Push) {
            BOOL isProduction = [[NSUserDefaults standardUserDefaults] boolForKey:BCEnvironmentConfigPushKey];
            if ((item.type == BCEnvType_pushProduct) == isProduction) {
                cell.selectLab.hidden = NO;
            }
        }
    
        return cell;
    };
    self.tableView.selectedRowBlock = ^(NSIndexPath *indexPath) {
        @strongify(self);
        BCEnvSectionModel *model = [self.datalists safeObjectAtIndex:indexPath.section];
        BCEnvItem *item = [model.list safeObjectAtIndex:indexPath.row];
        if (model.sectionType == BCEnvSectionType_apiBaseURL) {
            BOOL isTest = NO;
            if (item.type == BCEnvType_testBaseURL) {
                isTest = YES;
            }
            [[NSUserDefaults standardUserDefaults] setValue:[BCEnvironmentConfig getBaseUrl:isTest] forKey:BCEnvironmentConfigApiKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [MBProgressHUD showMessage:@"环境配置修改成功,请重启app!"];
        }
        if (model.sectionType == BCEnvSectionType_Push) {
            BOOL isProduction = NO;
            if (item.type == BCEnvType_pushProduct) {
                isProduction = YES;
            }
            [[NSUserDefaults standardUserDefaults] setBool:isProduction forKey:BCEnvironmentConfigPushKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        [self.tableView reloadData];
    };
    
}

- (BCTableView *)tableView{
    if (!_tableView) {
        _tableView = [[BCTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain rowsCellClass:@[[BCEnvCell class]]];
    }
    return _tableView;
}

- (NSArray *)datalists{
    if (!_datalists) {
        NSArray *arr = @[@{@"title":@"配置Api BaseURL",@"sectionType":@(BCEnvSectionType_apiBaseURL),@"list":@[@{@"title":@"测试环境",@"type":@(BCEnvType_testBaseURL)},
                                                                                                              @{@"title":@"正式环境",@"type":@(BCEnvType_releaseBaseURL)}]},
                         @{@"title":@"配置极光推送、数据埋点",@"sectionType":@(BCEnvSectionType_Push),@"list":@[@{@"title":@"开发环境",@"type":@(BCEnvType_pushDev)},
                                                                                                    @{@"title":@"发布环境",@"type":@(BCEnvType_pushProduct)}],}
        ];
        NSMutableArray *temp = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            BCEnvSectionModel *item = [BCEnvSectionModel modelWithDict:dic];
            if (item) {
                [temp addObject:item];
            }
        }
        _datalists = [temp copy];
    }
    return _datalists;
}

@end
