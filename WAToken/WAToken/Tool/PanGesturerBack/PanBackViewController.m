//
//  PanBackViewController.m
//  KingOfUnrar
//
//  Created by dizhihao on 2017/4/21.
//  Copyright © 2017年 dizhihao. All rights reserved.
//

#import "PanBackViewController.h"

@interface PanBackViewController ()

@end

@implementation PanBackViewController

- (id)init {
    self = [super init];
    if (self) {
        self.enablePanGesture = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
