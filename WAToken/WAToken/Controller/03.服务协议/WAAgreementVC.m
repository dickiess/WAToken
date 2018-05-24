//
//  WAAgreementVC.m
//  WAToken
//
//  Created by dizhihao on 2018/5/23.
//  Copyright © 2018 dizhihao. All rights reserved.
//

#import "WAAgreementVC.h"

#import "WAServer.h"

@interface WAAgreementVC ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *readBtn;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WAAgreementVC

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
    
    NSLog(@"=== WAAgreementVC ===");
}

- (void)initUI {
    // read button
    if ([WA_API isAgreementRead]) {
        _readBtn.hidden = YES;
    } else {
        _readBtn.hidden = NO;
    }
    
    // web view
    NSString *path = [[NSBundle mainBundle] pathForResource:@"protocol_cn" ofType:@"html"];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
}

/*****************************************************************************************************/

#pragma mark - delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // Disable user selection
    NSString *jsString1 = @"document.documentElement.style.webkitUserSelect='none';";
    [webView stringByEvaluatingJavaScriptFromString:jsString1];
    
    // Disable callout
    NSString *jsString2 = @"document.documentElement.style.webkitTouchCallout='none';";
    [webView stringByEvaluatingJavaScriptFromString:jsString2];
}

/*****************************************************************************************************/

#pragma mark - button action

// 点击返回
- (IBAction)tapBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

// 点击同意
- (IBAction)tapForAgree:(UIButton *)sender {
    WA_API.isAgreementRead = YES;
    [self.navigationController popViewControllerAnimated:NO];
}

/*****************************************************************************************************/

#pragma mark - status bar style

// 状态栏白字
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
