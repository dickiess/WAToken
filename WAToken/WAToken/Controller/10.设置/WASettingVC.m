//
//  WASettingVC.m
//  WAToken
//
//  Created by dizhihao on 2018/6/5.
//  Copyright © 2018 dizhihao. All rights reserved.
//

#import "WASettingVC.h"
#import "WAAgreementVC.h"

#import "WAServer.h"

#import "DSSettingDataSource.h"

@interface WASettingVC ()

@property (nonatomic, strong) DSSettingDataSource *dataSource;
@property (strong, nonatomic) NSMutableArray *list;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation WASettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initDataSource];
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"=== WASettingVC ===");
}

- (void)initUI {
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self.dataSource;
}

/*****************************************************************************************/

#pragma mark - data source

- (void)initDataSource {
    
    _list = [NSMutableArray array];

    // 组1
    DSSettingItems *items1 = [[DSSettingItems alloc] init];
    // 不设编号，便于移动
    {
        // 箭头型
        DSSettingItem *item
        = [DSSettingItem itemWithTitle:@"使用说明" icon:@"" type:DSSettingItemTypeArrow];
        item.didSelectBlock = ^{ };
        [items1.items addObject:item];
    }
    {
        // 箭头型
        DSSettingItem *item
        = [DSSettingItem itemWithTitle:@"服务协议" icon:@"" type:DSSettingItemTypeArrow];
        item.didSelectBlock = ^{
            WAAgreementVC *agreeVC = [[WAAgreementVC alloc] init];
            [self.navigationController pushViewController:agreeVC animated:NO];
        };
        [items1.items addObject:item];
    }
    {
        // 箭头型
        DSSettingItem *item
        = [DSSettingItem itemWithTitle:@"修改登录密码" icon:@"" type:DSSettingItemTypeArrow];
        item.didSelectBlock = ^{
            NSLog(@"修改密码");
        };
        [items1.items addObject:item];
    }
    {
        // 开关型
        DSSettingItem *item
        = [DSSettingItem itemWithTitle:@"自动上传数据" icon:@"" type:DSSettingItemTypeSwitch];
        item.isSwitchOn = YES;
        item.switchClick = ^(BOOL on) {
            NSLog(@"switch: %@", on ? @"on" : @"off");
        };
        [items1.items addObject:item];
    }
    {
        // 选项型
        DSSettingItem *item
        = [DSSettingItem itemWithTitle:@"语言设置" icon:@"" detial:@"简体中文" type:DSSettingItemTypeDetial];
        item.didSelectBlock = ^{
            NSLog(@"选择语言");
        };
        [items1.items addObject:item];
    }
    items1.headTitle = @"基本设置";
    items1.footTitle = @"";
    [_list addObject:items1];
    
    // 组2
    DSSettingItems *items2 = [[DSSettingItems alloc] init];
    {
        // 箭头型
        DSSettingItem *item
        = [DSSettingItem itemWithTitle:@"关于我们" icon:@"" type:DSSettingItemTypeArrow];
        item.didSelectBlock = ^{ };
        [items2.items addObject:item];
    }
    {
        // 选项型
        DSSettingItem *item
        = [DSSettingItem itemWithTitle:@"版本号" icon:@"" detial:@"1.0.1" type:DSSettingItemTypeDetial];
        item.didSelectBlock = ^{ };
        [items2.items addObject:item];
    }
    {
        // 箭头型
        DSSettingItem *item
        = [DSSettingItem itemWithTitle:@"反馈意见" icon:@"" type:DSSettingItemTypeArrow];
        item.didSelectBlock = ^{ };
        [items2.items addObject:item];
    }
    {
        // 箭头型
        DSSettingItem *item
        = [DSSettingItem itemWithTitle:@"评价我们" icon:@"" type:DSSettingItemTypeArrow];
        item.didSelectBlock = ^{ };
        [items2.items addObject:item];
    }
    {
        // 箭头型
        DSSettingItem *item
        = [DSSettingItem itemWithTitle:@"分享我们" icon:@"" type:DSSettingItemTypeArrow];
        item.didSelectBlock = ^{ };
        [items2.items addObject:item];
    }
    items2.headTitle = @"产品信息";
    items2.footTitle = @"";
    [_list addObject:items2];
    
    
    // 组3
    DSSettingItems *items3 = [[DSSettingItems alloc] init];
    {
        // 箭头型
        DSSettingItem *item
        = [DSSettingItem itemWithTitle:@"退出登录" icon:@"" type:DSSettingItemTypeArrow];
        item.titleColor = HexRGB(THEME_RED);
        item.didSelectBlock = ^{
            [WA_API removePrivateKey];
            [self.navigationController popToRootViewControllerAnimated:NO];
        };
        [items3.items addObject:item];
    }
    items3.headTitle = @"";
    items3.footTitle = @"";
    [_list addObject:items3];
    
    // 加入规则
    self.dataSource = [[DSSettingDataSource alloc] initWithItems:_list];
}

/*****************************************************************************************/

#pragma mark - delegate


/*****************************************************************************************/

#pragma mark - button action

- (IBAction)tapBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
