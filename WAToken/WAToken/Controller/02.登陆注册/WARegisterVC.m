//
//  WARegisterVC.m
//  watoken
//
//  Created by dizhihao on 2018/5/22.
//  Copyright © 2018 dizhihao. All rights reserved.
//

#import "WARegisterVC.h"

@interface WARegisterVC ()
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *invitationcodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *logincodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmcodeTextField;

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

- (IBAction)tapBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
