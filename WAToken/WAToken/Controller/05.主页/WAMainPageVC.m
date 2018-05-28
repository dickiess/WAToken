//
//  WAMainPageVC.m
//  WAToken
//
//  Created by dizhihao on 2018/5/28.
//  Copyright © 2018 dizhihao. All rights reserved.
//

#import "WAMainPageVC.h"
#import "WAQRCodeScanVC.h"

@interface WAMainPageVC ()

@end

@implementation WAMainPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"=== WAMainPageVC ===");
}

/*****************************************************************************************************/

#pragma mark - button action

- (IBAction)scanAction:(UIButton *)sender {
    WAQRCodeScanVC *scanVC = [[WAQRCodeScanVC alloc] init];
    [self.navigationController pushViewController:scanVC animated:NO];
}

- (IBAction)setAction:(UIButton *)sender {
    
}

@end
