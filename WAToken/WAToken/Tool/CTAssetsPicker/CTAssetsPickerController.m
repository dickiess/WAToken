
//
//  CTAssetsPickerController.m
//  KingOfUnzip
//
//  Created by dizhihao on 15/9/7.
//  Copyright (c) 2015年 dizhihao. All rights reserved.
//

#import "CTAssetsPickerController.h"

@implementation CTAssetsPickerController

@dynamic delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 导航栏设置
    UINavigationBar *navigationBar
    = [UINavigationBar appearanceWhenContainedIn:[CTAssetsPickerController class], nil];
    navigationBar.barTintColor = [UIColor blackColor];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeZero;
    NSDictionary *attributes
    = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSShadowAttributeName:shadow};
    [navigationBar setTitleTextAttributes:attributes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*************************************************************************************************************/

- (id)init {
    CTAssetsGroupViewController *groupViewController
    = [[CTAssetsGroupViewController alloc] init];
    if (self = [super initWithRootViewController:groupViewController]) {
        _maximumNumberOfSelection   = NSIntegerMax;
        _assetsFilter               = [ALAssetsFilter allAssets];
        _showsCancelButton          = YES;
        
//        if ([self respondsToSelector:@selector(setContentSizeForViewInPopover:)]) {
//            [self setContentSizeForViewInPopover:kPopoverContentSize];
//        }
        if ([self respondsToSelector:@selector(setPreferredContentSize:)]) {
            [self setPreferredContentSize:kPopoverContentSize];
        }
    }
    
    return self;
}

/*************************************************************************************************************/

// 状态栏文字变白
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
