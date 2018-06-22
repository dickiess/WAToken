//
//  WARegInfoVC.m
//  WAToken
//
//  Created by dizhihao on 2018/6/20.
//  Copyright © 2018 dizhihao. All rights reserved.
//

#import "WARegInfoVC.h"

#import "SelwynFormSectionItem.h"
#import "SelwynFormItem.h"
#import "SelwynFormHandle.h"

#import "WAServer.h"

/*****************************************************************************************************/

typedef void(^EditAction)(void);
typedef void(^FinishAction)(void);

/*****************************************************************************************************/

@interface WARegInfoVC ()


@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property (nonatomic, assign) BOOL editMode;
@property (nonatomic, strong) EditAction editAction;
@property (nonatomic, strong) FinishAction finishAction;

@end

@implementation WARegInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"=== WARegInfoVC ===");
}

- (void)initUI {
    
    // navigation bar
    
    // title
    self.title = @"个人信息";
    
    // data source
    [self dataSource];
    
    // user info
    NSLog(@"\nuser info %@", _userInfo);
    
    // 进入编辑模式
    [self edit];
}

- (void)dataSource {
    // base info
    SelwynFormSectionItem *baseSection = [[SelwynFormSectionItem alloc] init];
    baseSection.cellItems = [self baseInfo];
    baseSection.headerHeight = 36.0f;
    baseSection.headerColor = HexRGB(0xF0F0F0);
    baseSection.headerTitle = @"基本信息";
    baseSection.headerTitleColor = [UIColor darkGrayColor];
    [self.mutableArray addObject:baseSection];
    
    // detail info
    SelwynFormSectionItem *detailSection = [[SelwynFormSectionItem alloc] init];
    detailSection.cellItems = [self detailInfo];
    detailSection.headerTitle = @"详细信息";
    detailSection.headerTitleColor = [UIColor darkGrayColor];
    detailSection.headerHeight = 36.0f;
    detailSection.headerColor = HexRGB(0xF0F0F0);
    detailSection.footerTitle = @"";
    detailSection.footerTitleColor = [UIColor clearColor];
    detailSection.footerHeight = 30.0f;
    detailSection.footerColor = HexRGB(0xF0F0F0);
    [self.mutableArray addObject:detailSection];
    
    // 编辑按钮点击事件
    __weak typeof(self) weakSelf = self;
    self.editAction = ^() {
        // base info
        NSArray *baseItems = baseSection.cellItems;
        
        SelwynFormItem *name = (SelwynFormItem *)baseItems[0];
        name.editable = YES;    // 重置可编辑属性
        name.required = YES;    // 重置可选必选
        
        SelwynFormItem *gender = (SelwynFormItem *)baseItems[1];
        gender.editable = YES;
        gender.required = YES;
        gender.formCellType = SelwynFormCellTypeSelect;
        
        SelwynFormItem *mobile = (SelwynFormItem *)baseItems[2];
        mobile.editable = YES;
        mobile.maxInputLength = 11;
        mobile.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        mobile.required = YES;
        
        SelwynFormItem *email = (SelwynFormItem *)baseItems[3];
        email.editable = YES;
        email.keyboardType = UIKeyboardTypeEmailAddress;
        email.required = NO;
        
        SelwynFormItem *region = (SelwynFormItem *)baseItems[4];
        region.editable = YES;
        region.required = NO;
        region.formCellType = SelwynFormCellTypeSelect;
        
        SelwynFormItem *city = (SelwynFormItem *)baseItems[5];
        city.editable = YES;
        city.required = NO;
        city.formCellType = SelwynFormCellTypeSelect;
        
        SelwynFormItem *address = (SelwynFormItem *)baseItems[6];
        address.editable = YES;
        address.required = NO;
        
        // detail info
        NSArray *detailItems = detailSection.cellItems;
        
        SelwynFormItem *realname = (SelwynFormItem *)detailItems[0];
        realname.editable = YES;
        realname.required = YES;
        
        SelwynFormItem *identifier = (SelwynFormItem *)detailItems[1];
        identifier.editable = YES;
        identifier.required = YES;
        
        SelwynFormItem *attachment = (SelwynFormItem *)detailItems[2];
        attachment.editable = YES;
        attachment.required = YES;
        
//        NSLog(@"%@",name.formDetail);
//        NSLog(@"%@",attachment.images);
        
        [weakSelf.formTableView reloadData];
    };
    
    self.finishAction = ^() {
        // base info
        NSArray *baseItems = baseSection.cellItems;
        
        SelwynFormItem *name = (SelwynFormItem *)baseItems[0];
        name.editable = NO;    // 重置可编辑属性
        name.required = NO;    // 重置可选必选
        
        SelwynFormItem *gender = (SelwynFormItem *)baseItems[1];
        gender.editable = NO;
        gender.required = NO;
        
        SelwynFormItem *mobile = (SelwynFormItem *)baseItems[2];
        mobile.editable = NO;
        mobile.required = NO;
        
        SelwynFormItem *email = (SelwynFormItem *)baseItems[3];
        email.editable = NO;
        email.required = NO;
        
        SelwynFormItem *region = (SelwynFormItem *)baseItems[4];
        region.editable = NO;
        region.required = NO;
        
        SelwynFormItem *city = (SelwynFormItem *)baseItems[5];
        city.editable = NO;
        city.required = NO;
        
        SelwynFormItem *address = (SelwynFormItem *)baseItems[6];
        address.editable = NO;
        address.required = NO;
        
        // detail info
        NSArray *detailItems = detailSection.cellItems;

        SelwynFormItem *realname = (SelwynFormItem *)detailItems[0];
        realname.editable = NO;
        realname.required = NO;
        
        SelwynFormItem *identifier = (SelwynFormItem *)detailItems[1];
        identifier.editable = NO;
        identifier.required = NO;
        
        SelwynFormItem *attachment = (SelwynFormItem *)detailItems[2];
        attachment.editable = NO;
        attachment.required = NO;
        
        //        NSLog(@"%@",name.formDetail);
        //        NSLog(@"%@",attachment.images);
        
        [weakSelf.formTableView reloadData];
    };
}

// 基本信息
- (NSMutableArray *)baseInfo {
    // base info
    NSMutableArray *baseInfo = [NSMutableArray array];
    NSString *string = @"";
    
    // name
    string = _userInfo[@"name"];
    SelwynFormItem *name = SelwynDetailItemMake(@"用户名", string, @"(必填)", SelwynFormCellTypeInput);
    [baseInfo addObject:name];
    
    // gender
    string = [_userInfo[@"gender"] integerValue] == 1 ? @"男" : @"女";
    SelwynFormItem *gender = SelwynDetailItemMake(@"性别", string, @"(必填)", SelwynFormCellTypeInput);
    gender.selectHandle = ^(SelwynFormItem *item) {
        [self selectGenderWithItem:item];
    };
    [baseInfo addObject:gender];
    
    // mobile
    string = _userInfo[@"mobile"];
    SelwynFormItem *mobile = SelwynDetailItemMake(@"手机号码", string, @"(必填)", SelwynFormCellTypeInput);
    [baseInfo addObject:mobile];
    
    // email
    string = _userInfo[@"email"];
    SelwynFormItem *email = SelwynDetailItemMake(@"邮箱", string, @"(必填)", SelwynFormCellTypeInput);
    [baseInfo addObject:email];
    
    // region
    string = nil;
    SelwynFormItem *region = SelwynDetailItemMake(@"省份(地区)", string, @"(选填)", SelwynFormCellTypeInput);
    region.selectHandle = ^(SelwynFormItem *item) {
        NSLog(@"112233");
    };
    [baseInfo addObject:region];
    
    // city
    string = nil;
    SelwynFormItem *city = SelwynDetailItemMake(@"城市", string, @"(选填)", SelwynFormCellTypeInput);
    city.selectHandle = ^(SelwynFormItem *item) {
        NSLog(@"332211");
    };
    [baseInfo addObject:city];
    
    // address
    SelwynFormItem *address = SelwynDetailItemMake(@"住址", @"", @"(选填)", SelwynFormCellTypeInput);
    [baseInfo addObject:address];
    
    return baseInfo;
}

// 详细信息
- (NSMutableArray *)detailInfo {
    // detail info
    NSMutableArray *detailInfo = [NSMutableArray array];
    NSString *string = @"";
    
    // real name
    string = nil;
    SelwynFormItem *realname = SelwynDetailItemMake(@"真实姓名", string, @"(必填)", SelwynFormCellTypeInput);
    [detailInfo addObject:realname];
    
    // identifier
    string = _userInfo[@"ident"];
    SelwynFormItem *identifier = SelwynDetailItemMake(@"身份证号", string, @"(必填)", SelwynFormCellTypeInput);
    [detailInfo addObject:identifier];
    
    // attach
    SelwynFormItem *attachment = SelwynDetailItemMake(@"身份证照片", @"", @"(必填)", SelwynFormCellTypeAttachment);
    [detailInfo addObject:attachment];
    
    return detailInfo;
}

/*****************************************************************************************************/

#pragma mark - button action

// 返回
- (IBAction)tapBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// 完成
- (IBAction)tapRight:(UIButton *)sender {
    if (_editMode) {
        [self finish];
    } else {
        [self edit];
    }
}

// 编辑模式
- (void)edit {
    if (self.editAction) {
        [_rightBtn setTitle:@"保存" forState:UIControlStateNormal];
        self.editAction();
        _editMode = YES;
    }
}

// 完成模式
- (void)finish {
    if (self.finishAction) {
        [_rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
        self.finishAction();
        _editMode = NO;
    }
}

// 点击回退
- (void)tapInScreen:(UITapGestureRecognizer *)sender {

}


/*****************************************************************************************************/

#pragma mark - function

// 性别选择
- (void)selectGenderWithItem:(SelwynFormItem *)item {
    NSString *title = [NSString stringWithFormat:@"请选择%@", item.formTitle];
    
    UIAlertControllerStyle s = UIAlertControllerStyleActionSheet;
    UIAlertController *alertController
    = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:s];

    UIAlertActionStyle as  = UIAlertActionStyleDefault;
    UIAlertActionStyle uas = UIAlertActionStyleCancel;
    __weak WARegInfoVC *wSelf = self;
    
    // 1.男
    UIAlertAction *action0
    = [UIAlertAction actionWithTitle:@"男" style:as handler:^(UIAlertAction *action) {
        item.formDetail = @"男";
        [wSelf.formTableView reloadData];
    }];
    [alertController addAction:action0];
    
    // 2.女
    UIAlertAction *action1
    = [UIAlertAction actionWithTitle:@"女" style:as handler:^(UIAlertAction *action) {
        item.formDetail = @"女";
        [wSelf.formTableView reloadData];
    }];
    [alertController addAction:action1];
    
    // 3.取消
    UIAlertAction *action2
    = [UIAlertAction actionWithTitle:@"取消" style:uas handler:^(UIAlertAction *action) {
    }];
    [alertController addAction:action2];
    
    // 弹出
    if (DEVICE_IPAD) {
        UIPopoverPresentationController *popPresenter = [alertController popoverPresentationController];
        popPresenter.sourceView = wSelf.view;
        CGRect rect = self.view.bounds;
        rect.origin.x = rect.size.width / 2;
        rect.origin.y = rect.size.height / 2 - 20;
        popPresenter.sourceRect = rect; // 此处会用到弹窗位置，需要传入一个参数
        [wSelf presentViewController:alertController animated:YES completion:^{ }];
    } else {
        [wSelf presentViewController:alertController animated:YES completion:^{ }];
    }
}

@end
