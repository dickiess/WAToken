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

typedef void(^EditCompletion)(void);

/*****************************************************************************************************/

@interface WARegInfoVC () <UIActionSheetDelegate>

@property (nonatomic, strong) NSArray *genders;
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, copy)   EditCompletion editCompletion;

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
    // title
    self.title = @"个人信息";
    
    // gender
    self.genders = @[@"男", @"女"];
    
    // data source
    [self dataSource];
    
    // edit button
    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_editBtn setTitleColor:HexRGB(THEME_LIGHTBLUE) forState:UIControlStateNormal];
    _editBtn.titleLabel.font = Font(16);
    [_editBtn sizeToFit];
    [_editBtn addTarget:self action:@selector(edit) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc]initWithCustomView:_editBtn];
    self.navigationItem.rightBarButtonItem = editItem;
    
    // user info
    NSLog(@"user info%@", _userInfo);
}

- (void)dataSource {
    // base info
    NSMutableArray *baseInfo = [NSMutableArray array];
    
    SelwynFormItem *name = SelwynDetailItemMake(@"用户名", @"", @"(必填)", SelwynFormCellTypeInput);
    [baseInfo addObject:name];
    SelwynFormItem *gender = SelwynDetailItemMake(@"性别", @"男", @"(必填)", SelwynFormCellTypeSelect);
    [baseInfo addObject:gender];
    SelwynFormItem *mobile = SelwynDetailItemMake(@"手机号码", @"", @"(必填)", SelwynFormCellTypeInput);
    [baseInfo addObject:mobile];
    SelwynFormItem *invitecode = SelwynDetailItemMake(@"邀请码", @"", @"(选填)", SelwynFormCellTypeInput);
    [baseInfo addObject:invitecode];
    SelwynFormItem *passcode = SelwynDetailItemMake(@"登陆密码", @"", @"(必填)", SelwynFormCellTypeInput);
    [baseInfo addObject:passcode];
    SelwynFormItem *confirmcode = SelwynDetailItemMake(@"确认密码", @"", @"(必填)", SelwynFormCellTypeInput);
    [baseInfo addObject:confirmcode];
    
    SelwynFormSectionItem *sectionItem = [[SelwynFormSectionItem alloc] init];
    sectionItem.cellItems = baseInfo;
    sectionItem.headerHeight = 30.0f;
    sectionItem.headerColor = HexRGB(0xF0F0F0);
    sectionItem.headerTitle = @"基本信息";
    sectionItem.headerTitleColor = [UIColor lightGrayColor];
    [self.mutableArray addObject:sectionItem];
    
    NSMutableArray *datas1 = [NSMutableArray array];
    
    SelwynFormItem *address
    = SelwynDetailItemMake(@"住址",
                           @"拉斯维加斯拉斯维加斯拉斯维加斯拉斯维加斯拉斯维加斯拉斯维加斯拉斯维加斯拉斯维加斯",
                           @"",
                           SelwynFormCellTypeInput);
    
    [datas1 addObject:address];
    
    SelwynFormItem *attachment = SelwynDetailItemMake(@"附件", @"", @"", SelwynFormCellTypeAttachment);
    
    [datas1 addObject:attachment];
    
    SelwynFormSectionItem *sectionItem1 = [[SelwynFormSectionItem alloc] init];
    sectionItem1.cellItems = datas1;
    sectionItem1.headerHeight = 30;
    sectionItem1.headerColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    sectionItem1.footerHeight = 30;
    sectionItem1.footerColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    sectionItem1.footerTitle = @"section footer";
    sectionItem1.headerTitle = @"section header";
    sectionItem1.headerTitleColor = [UIColor orangeColor];
    sectionItem1.footerTitleColor = [UIColor greenColor];
    
    [self.mutableArray addObject:sectionItem1];
    
    // 编辑按钮点击事件
    __weak typeof(self) weakSelf = self;
    self.editCompletion = ^() {
        [weakSelf.editBtn setTitle:@"完成" forState:UIControlStateNormal];
        
        name.editable = YES;    // 重置可编辑属性
        name.required = YES;    // 重置可选必选
        
        gender.required = YES;
        gender.formCellType = SelwynFormCellTypeSelect;
        
        mobile.editable = YES;
        mobile.maxInputLength = 11;
        mobile.keyboardType = UIKeyboardTypeNumberPad;
        mobile.required = YES;
        
        invitecode.editable = YES;
        invitecode.required = YES;
        
        passcode.editable = YES;
        passcode.required = YES;
        
        confirmcode.editable = YES;
        confirmcode.required = YES;
        
        address.editable = YES;
        address.required = YES;
        
        attachment.editable = YES;
        
        NSLog(@"%@",name.formDetail);
        NSLog(@"%@",attachment.images);
        
        [weakSelf.formTableView reloadData];
    };
}

- (void)edit {
    if (self.editCompletion) {
        self.editCompletion();
    }
}


@end
