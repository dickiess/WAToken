//
//  WAOpeningVC.m
//  watoken
//
//  Created by dizhihao on 2018/4/20.
//  Copyright © 2018 dizhihao. All rights reserved.
//

#import "WAOpeningVC.h"
#import "WALoginVC.h"
#import "WATabBarController.h"

#import "WAServer.h"

#import "RichKeyChain.h"

@interface WAOpeningVC ()

@property (nonatomic, assign) BOOL reload;
@property (nonatomic, assign) NSInteger countdownNumber;
@property (nonatomic, strong) NSTimer *timer;
@property (weak, nonatomic)   IBOutlet UILabel *countdownLabel;

@end

@implementation WAOpeningVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initState];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    NSLog(@"=== WAOpeningVC ===");
    
    // 如果没有登陆用户，前往登陆页面
    NSString *pUser = [RichKeyChain keyChainReadKey:WATOKEN_USER];
    NSString *pKey  = [WA_API getPrivateKey];
//    NSLog(@"=== user: %@, key: %@", pUser, pKey);
    if (pUser == nil || pKey == nil) {
        _reload = YES;
        _countdownLabel.hidden = YES;
        [NSObject performAfterDelay:0.5f withBlock:^{
            [self gotoLoginVC];
        }];
    }
    else {
        // 用户登陆或注册成功，直接进入主页面
        if (_reload) {
            [self gotoMainVC];
        }
        // 用户重新访问，计数后进入主页
        else {
            WA_API.user = [RichUser userWithUserID:pUser];
            _countdownLabel.hidden = NO;
            _timer = [Utilities timerRepeatSeconds:1.0f target:self selector:@selector(countDown:)];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self removeTimer];
}

- (void)initState {
    _countdownNumber = 3;
    _reload = NO;
}

// 计数
- (void)countDown:(NSTimer *)timer {
    if (_countdownNumber > 1) {
        _countdownNumber --;
        int c = (int)_countdownNumber;
        NSLog(@"跳转还剩%d秒", c);
        _countdownLabel.text = [NSString stringWithFormat:@"%ds", c];
    }
    else {
        [self removeTimer];
        [self gotoMainVC];
    }
}

- (void)removeTimer {
    [_timer invalidate];
    _timer = nil;
}

// 前往登陆
- (void)gotoLoginVC {
    WALoginVC *loginVC = [[WALoginVC alloc] init];
    [self.navigationController pushViewController:loginVC animated:NO];
}

// 前往主页面
- (void)gotoMainVC {
    WATabBarController *tab = [[WATabBarController alloc] init];
    [self.navigationController pushViewController:tab animated:NO];
}

// 点击主图
- (IBAction)tapInImageView:(UITapGestureRecognizer *)sender {
    //[self gotoLoginVC];
}

/*****************************************************************************************************/

#pragma mark - status bar style

// 状态栏白字
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
