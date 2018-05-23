//
//  WAOpeningVC.m
//  watoken
//
//  Created by dizhihao on 2018/4/20.
//  Copyright © 2018 dizhihao. All rights reserved.
//

#import "WAOpeningVC.h"
#import "WALoginVC.h"

#import "WAServer.h"

@interface WAOpeningVC ()

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
    if ([WA_API firstLauch]) {
        _countdownLabel.hidden = YES;
    } else {
        _countdownLabel.hidden = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self removeTimer];
}

- (void)initState {
    _countdownNumber = 3;
    _timer = [Utilities timerRepeatSeconds:1.0f target:self selector:@selector(countDown:)];
}

// 计数
- (void)countDown:(NSTimer *)timer {
    if (_countdownNumber > 0) {
        _countdownNumber --;
        int c = (int)_countdownNumber;
        NSLog(@"跳转还剩%d秒", c);
        _countdownLabel.text = [NSString stringWithFormat:@"跳转还剩%d秒", c];
    }
    else {
        [self removeTimer];
        [self gotoLoginVC];
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

// 点击主图
- (IBAction)tapInImageView:(UITapGestureRecognizer *)sender {
    [self gotoLoginVC];
}

@end
