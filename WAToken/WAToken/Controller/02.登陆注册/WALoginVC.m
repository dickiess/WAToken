//
//  WALoginVC.m
//  watoken
//
//  Created by dizhihao on 2018/5/8.
//  Copyright © 2018 dizhihao. All rights reserved.
//

#import "WALoginVC.h"

#import "WAServer.h"
#import "RichKeyChain.h"

#import "WARegisterVC.h"

@interface WALoginVC ()

@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UITextField *textField2;
@property (weak, nonatomic) IBOutlet UIButton    *submitBtn;

@end

@implementation WALoginVC

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
    
    NSLog(@"=== WALoginVC ===");
}

- (void)initUI {
    // textfield
    
    // submit button
    _submitBtn.layer.cornerRadius = 5.0f;
    _submitBtn.layer.masksToBounds = YES;
}

/*****************************************************************************************************/

#pragma mark - delegate

// 键盘返回按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSInteger tag = textField.tag;
    [self keyboardDismiss];
    
    if (tag == 11) {
        
    }
    else if (tag == 12) {
    }
    
    return YES;
}

/*****************************************************************************************************/

#pragma mark - button action

// 点击屏幕
- (IBAction)tapInScreen:(UITapGestureRecognizer *)sender {
    [self keyboardDismiss];
}

// 键盘回退
- (void)keyboardDismiss {
    [_textField1 resignFirstResponder];
    [_textField2 resignFirstResponder];
}

// 登陆
- (IBAction)submit:(UIButton *)sender {
    
    NSString *input1 = _textField1.text;
    NSString *input2 = _textField2.text;
    
    // 1.非空检测
    if (BLANK_STR(input1) || BLANK_STR(input2)) {
        [self warningMessage:@"请输入用户名和密码"];
        return;
    }
    
    // 插桩
    [self testLogin];
    
    // 登陆
    __weak WALoginVC *wSelf = self;
    [WA_API loginWithName:_textField1.text
                     pass:_textField2.text
                 callback:^(id obj) {
                     NSDictionary *info = (NSDictionary *)obj;
                     if ([info[@"result"] boolValue]) {
                         // 保存用户
                         [RichKeyChain keyChainSaveKey:WATOKEN_USER value:wSelf.textField1.text];
                         // 创建用户并保存密码
                         WA_API.user = [RichUser userWithUserID:wSelf.textField1.text];
                         [WA_API savePrivateKey:info[@"pkey"]];
                         [self.navigationController popViewControllerAnimated:NO];
                     } else {
                         [wSelf warningMessage:info[@"message"]];
                     }
                 }];
}

// 联系客服
- (IBAction)contactForHelp:(UIButton *)sender {
    [WA_API telephoneCall:HOT_LINE];
}

// 前往新用户注册
- (IBAction)gotoRegisterVC:(UIButton *)sender {
    WARegisterVC *registerVC = [[WARegisterVC alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

/*****************************************************************************************************/

#pragma mark - warning message

// 弹窗警告
- (void)warningMessage:(NSString *)message {
    UIAlertControllerStyle style = UIAlertControllerStyleAlert;
    UIAlertController *alert
    = [UIAlertController alertControllerWithTitle:@"提示:" message:message preferredStyle:style];
    UIAlertActionStyle actionStyle = UIAlertActionStyleDefault;
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"关闭" style:actionStyle handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:^{ }];
}

/*****************************************************************************************************/

#pragma mark - test issue

// 测试登陆
- (void)testLogin {
//    NSLog(@"用户: %@, 密码: %@", _textField1.text, _textField2.text);
}

/*****************************************************************************************************/

#pragma mark - status bar style

// 状态栏黑字
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

@end
