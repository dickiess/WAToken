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
    
    NSLog(@"=== WARegisterVC ===");
}

- (void)initUI {
    // textfield
    
    // submit button
    _submitBtn.layer.cornerRadius = 5.0f;
    _submitBtn.layer.masksToBounds = YES;
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

@end
