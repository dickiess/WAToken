//
//  RichNavigationController.m
//  WAToken
//
//  Created by dizhihao on 2018/5/24.
//  Copyright © 2018 dizhihao. All rights reserved.
//

#import "RichNavigationController.h"

@interface RichNavigationController ()

@end

@implementation RichNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.topViewController preferredStatusBarStyle];
}



@end
