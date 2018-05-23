//
//  WAAgreementVC.m
//  WAToken
//
//  Created by dizhihao on 2018/5/23.
//  Copyright © 2018 dizhihao. All rights reserved.
//

#import "WAAgreementVC.h"

@interface WAAgreementVC ()

@end

@implementation WAAgreementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*****************************************************************************************************/

#pragma mark - button action

- (IBAction)tapBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

/*****************************************************************************************************/

// 状态栏文字变白
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
