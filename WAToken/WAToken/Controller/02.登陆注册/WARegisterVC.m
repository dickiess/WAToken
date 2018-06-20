//
//  WARegisterVC.m
//  watoken
//
//  Created by dizhihao on 2018/5/22.
//  Copyright © 2018 dizhihao. All rights reserved.
//

#import "WARegisterVC.h"
#import "WAAgreementVC.h"
#import "WARegInfoVC.h"

#import "WAServer.h"
#import "RichKeyChain.h"

@interface WARegisterVC ()

@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UITextField *textField2;
@property (weak, nonatomic) IBOutlet UITextField *textField3;
@property (weak, nonatomic) IBOutlet UITextField *textField4;
@property (weak, nonatomic) IBOutlet UITextField *textField5;

@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (assign, nonatomic) BOOL isLoading;
@property (strong, nonatomic) NSMutableDictionary *userInfo; // 如果用户从下级页面返回，基础数据不会丢失

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
    // loading
    _isLoading = NO;
    
    // textfield
    
    // isAgreementRead
    
    // submit button
    _submitBtn.layer.cornerRadius = 5.0f;
    _submitBtn.layer.masksToBounds = YES;
}

// 更新勾选框视图
- (void)updateCheckBox {
    if ([WA_API isAgreementRead]) {
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

#pragma mark - request

// 开始
- (void)requestStartWithInterface:(NSString *)interface {
    if ([interface isEqualToString:WAT_USER_REG]) {
        [WaitingHUD show:@"Loading"];
    }
}

// 完成
- (void)requestFinishedWithCallBackInfo:(NSDictionary *)info interface:(NSString *)interface {
    _isLoading = NO;
    [WaitingHUD dismiss];
    
    // 1.feedback
    id fb = [self fbParserByInfo:info];
    if (fb == nil) {
        return;
    }
    
    // 注册
    if ([interface isEqualToString:WAT_USER_REG]) {
        _userInfo = (NSMutableDictionary *)fb[@"obj"];
        [self gotoUserInfo];
    }
}

// 内容解析
- (id)fbParserByInfo:(NSDictionary *)info {
    
    // 1.Message
    NSString *message = info[@"Message"];
    if ([message length] > 0) {
        [self warningMessage:message];
        return nil;
    }
    
    // 2.isValid
    NSInteger isValid = [info[@"isValid"] integerValue];
    if (isValid != 1) {
        return nil;
    }
    
    // 3.feedback
    return info[@"FeedBack"];
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
    [WA_API changeAgreement];
    [self updateCheckBox];
}

    // 输入控制
- (BOOL)textFieldCheck {
    if (_textField1.text.length < 2 || _textField1.text.length > 10) {
        [self warningMessage:@"请输入用户名（2-10个字符）"];
        return NO;
    }
    
    if ([Utilities isValidateMobileNumber:_textField2.text] == NO) {
        [self warningMessage:@"请输入正确的手机号码"];
        return NO;
    }
    
    if ((_textField3.text.length == 8) == NO) {
        [self warningMessage:@"请输入正确的邀请码"]; // 大写RZSOFT79
        return NO;
    }
    
    if ((_textField4.text.length == 6) == NO) {
        [self warningMessage:@"请输入6位登陆密码"];
        return NO;
    }
    
    if ([_textField4.text isEqualToString:_textField5.text] == NO) {
        [self warningMessage:@"确认登陆密码不一致"];
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
//    __weak WARegisterVC *wSelf = self;
//    [WA_API registerWithName:_textField1.text
//                      mobile:_textField2.text
//                  invitation:_textField3.text
//                        pass:_textField4.text callback:^(id obj) {
//                            NSDictionary *info = (NSDictionary *)obj;
//                            if ([info[@"result"] boolValue]) {
//                                // 保存用户
//                                [RichKeyChain keyChainSaveKey:WATOKEN_USER value:wSelf.textField2.text];
//                                // 创建用户并保存密码
//                                WA_API.user = [RichUser userWithUserID:wSelf.textField2.text];
//                                [WA_API savePrivateKey:info[@"pkey"]];
//                                [self.navigationController popToRootViewControllerAnimated:YES];
//                            } else {
//                                [wSelf warningMessage:info[@"message"]];
//                            }
//                        }];
    
    // 请求中
    if (_isLoading == YES) {
        return;
    }
    
    // 新请求
    _isLoading = YES;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:_textField1.text forKey:@"name"];
    [dict setObject:_textField2.text forKey:@"mobile"];
    [dict setObject:_textField3.text forKey:@"invitation"];
    [dict setObject:_textField4.text forKey:@"password"];
    NSLog(@"Request: %@ %@", WAT_USER_REG, dict);
    [self createPostRequest:WAT_USER_REG parameters:dict];
}

// 跳转
- (void)gotoUserInfo {
    if (_userInfo == nil) {
        return;
        
    }
    WARegInfoVC *infoVC = [[WARegInfoVC alloc] init];
    infoVC.userInfo = _userInfo;
    [self.navigationController pushViewController:infoVC animated:YES];
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
