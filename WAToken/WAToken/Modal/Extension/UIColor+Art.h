//
//  UIColor+Art.h
//  TMusic
//
//  Created by Alex Zhao on 13-8-9.
//  Copyright (c) 2013年 Tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef UIColor_H
#define UIColor_H

#define HexRGB(rgbValue)  ([UIColor colorWithHex:(rgbValue)])

#endif


@interface UIColor (Art)

+ (UIColor *)colorWith256Red:(NSUInteger)red
                       green:(NSUInteger)green
                        blue:(NSUInteger)blue
                       alpha:(CGFloat)alpha;

+ (UIColor *)colorWithHex:(long)hex;

+ (UIColor *)colorWithHex:(long)hex andAlpha:(float)alpha;

// Color 转 Hex
+ (long)hexWithColor:(UIColor *)color;

@end
