//
//  CALayer + PulldownAnimation.h
//  WAToken
//
//  Created by dizhihao on 2018/6/7.
//  Copyright © 2018 dizhihao. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

#define frameWidth ([[UIScreen mainScreen] bounds].size.width)

@interface CALayer (PulldownAnimation)

+ (CATextLayer *)createTextWithString:(NSString *)string
                                color:(UIColor *)color
                             fontsize:(CGFloat)fSize
                             position:(CGPoint)pt;
+ (CAShapeLayer *)createIndicatorWithColor:(UIColor *)color position:(CGPoint)pt;
+ (CAShapeLayer *)createSeparatorLineWithColor:(UIColor *)color position:(CGPoint)pt;
+ (CGSize)boundsBySize:(CGSize)aSize text:(NSString *)text fontSize:(CGFloat)fSize;

- (void)animation:(CAAnimation *)animation value:(NSValue *)value forKeyPath:(NSString *)keyPath;

@end
