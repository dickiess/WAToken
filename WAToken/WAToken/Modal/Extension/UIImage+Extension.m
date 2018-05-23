//
//  UIImage+Extension.m
//  LawManagerLawyer
//
//  Created by dizhihao on 16/4/7.
//  Copyright © 2016年 Dizhihao. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGFloat imageW = size.width;
    CGFloat imageH = size.height;
    
    // 1.开启基于位图的图形上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageW, imageH), NO, 0.0);
    // 2.画一个color颜色的矩形框
    [color set];
    UIRectFill(CGRectMake(0, 0, imageW, imageH));
    
    // 3.拿到图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 4.关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}

@end
