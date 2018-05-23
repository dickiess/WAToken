//
//  UIImage+Extension.h
//  LawManagerLawyer
//
//  Created by dizhihao on 16/4/7.
//  Copyright © 2016年 Dizhihao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

/**
 *  生成的图片的rect默认为100,100
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end
