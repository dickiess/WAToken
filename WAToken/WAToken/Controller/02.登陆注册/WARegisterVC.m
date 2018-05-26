//
//  WARegisterVC.m
//  watoken
//
//  Created by dizhihao on 2018/5/22.
//  Copyright © 2018 dizhihao. All rights reserved.
//

#import "WARegisterVC.h"
#import "WAAgreementVC.h"

#import "WAServer.h"

@interface WARegisterVC ()

@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UITextField *textField2;
@property (weak, nonatomic) IBOutlet UITextField *textField3;
@property (weak, nonatomic) IBOutlet UITextField *textField4;
@property (weak, nonatomic) IBOutlet UITextField *textField5;

@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end

@implementation WARegisterVC

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
    
    [self updateCheckBox];
    
    NSLog(@"=== WARegisterVC ===");
}

- (void)initUI {
    // textfield
    
    // isAgreementRead
    WA_API.isAgreementRead = NO;
    
    // submit button
    _submitBtn.layer.cornerRadius = 5.0f;
    _submitBtn.layer.masksToBounds = YES;
}

// 更新勾选框视图
- (void)updateCheckBox {
    if (WA_API.isAgreementRead) {
        _submitBtn.enabled = YES;
        [_checkBtn setImage:[UIImage imageNamed:@"btn_hook_on"] forState:UIControlStateNormal];
        _submitBtn.backgroundColor = HexRGB(THEME_BLUE);
    } else {
        _submitBtn.enabled = NO;
        [_checkBtn setImage:[UIImage imageNamed:@"btn_hook_off"] forState:UIControlStateNormal];
        _submitBtn.backgroundColor = HexRGB(THEME_GRAY);
    }
}


/*****************************************************************************************************/

#pragma mark - delegate

// 键盘返回按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSInteger tag = textField.tag;
    [self keyboardDismiss];
    
    if (tag == 11) {
        [_textField2 becomeFirstResponder];
    }
    else if (tag == 12) {
        [_textField3 becomeFirstResponder];
    }
    else if (tag == 13) {
        [_textField4 becomeFirstResponder];
    }
    else if (tag == 14) {
        [_textField5 becomeFirstResponder];
    }
    
    return YES;
}

/*****************************************************************************************************/

#pragma mark - button action

// 返回
- (IBAction)tapBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// 点击屏幕
- (IBAction)tapInScreen:(UITapGestureRecognizer *)sender {
    [self keyboardDismiss];
}

// 键盘回退
- (void)keyboardDismiss {
    [_textField1 resignFirstResponder];
    [_textField2 resignFirstResponder];
    [_textField3 resignFirstResponder];
    [_textField4 resignFirstResponder];
    [_textField5 resignFirstResponder];
}

// 前往平台服务协议
- (IBAction)gotoAgreementVC:(UIButton *)sender {
    WAAgreementVC *agreementVC = [[WAAgreementVC alloc] init];
    [self.navigationController pushViewController:agreementVC animated:NO];
}

// 点击勾选框
- (IBAction)tapInCheckBox:(UIButton *)sender {
    WA_API.isAgreementRead = !WA_API.isAgreementRead;
    [self updateCheckBox];
}

    // 输入控制
- (BOOL)textFieldCheck {
    if (_textField1.text.length < 2 || _textField1.text.length > 8) {
        [self warningMessage:@"请输入真实姓名"];
        return NO;
    }
    
    if ([Utilities isValidateMobileNumber:_textField2.text]) {
        [self warningMessage:@"请输入正确的手机号码"];
        return NO;
    }
    
    if ((_textField3.text.length == 6) == NO) {
        [self warningMessage:@"请输入正确的邀请码"];
        return NO;
    }
    
    if ((_textField4.text.length == 6) == NO) {
        [self warningMessage:@"请输入正确的登陆密码"];
        return NO;
    }
    
    if ([_textField4.text isEqualToString:_textField5.text] == NO) {
        [self warningMessage:@"确认密码不一致"];
        return NO;
    }
    
    return YES;
}

// 注册
- (IBAction)submit:(UIButton *)sender {
    // 输入控制
    if ([self textFieldCheck] == NO) {
        return;
    }
    
    // 注册
    __weak WARegisterVC *wSelf = self;
    [WA_API registerWithName:_textField1.text
                      mobile:_textField2.text
                  invitation:_textField3.text
                        pass:_textField4.text callback:^(id obj) {
                            NSDictionary *info = (NSDictionary *)obj;
                            if ([info[@"result"] boolValue]) {
                                [self.navigationController popToRootViewControllerAnimated:YES];
                            } else {
                                [wSelf warningMessage:info[@"message"]];
                            }
                        }];
    
    
    
    
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

// 测试注册
- (void)testRegister {
    NSLog(@"用户名: %@, 手机号码: %@, 邀请码: %@, 登陆密码: %@, 确认密码: %@",
          _textField1.text,
          _textField2.text,
          _textField3.text,
          _textField4.text,
          _textField5.text);
}

/*****************************************************************************************************/

#pragma mark - status bar style

// 状态栏黑字
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

@end
