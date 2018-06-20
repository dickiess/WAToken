//
//  RadiusProgress.h
//  KingOfUnrar
//
//  Created by dizhihao on 2017/8/10.
//  Copyright © 2017年 dizhihao. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface RadiusProgress : UIView

@property (nonatomic, assign) CGFloat number;   // 数值
@property (nonatomic, assign) CGFloat radius;   // 半径
@property (nonatomic, strong) UILabel *percentLabel;


// 初始化
+ (RadiusProgress *)radiusProgressWithFrame:(CGRect)frame;

// 设定值
- (void)radiusProgressSetValue:(CGFloat)value;

// 颜色设定
- (void)setThemeColor:(UIColor *)color;

@end
