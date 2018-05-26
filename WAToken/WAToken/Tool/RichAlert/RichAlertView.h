//
//  RichAlertView.h
//  RichAlertViewModel
//
//  Created by dizhihao on 15/11/23.
//  Copyright © 2015年 dizhihao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RichAlertView : NSObject

+ (instancetype)animationAlertShareInstance;

// 传入view 实现view的动画弹出
- (void)animationAlertWithView:(UIView *)view;

// 传入view 实现view的动画隐藏
- (void)animationHiddeWithView:(UIView *)view;

@end