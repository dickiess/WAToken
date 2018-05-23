//
//  UIColor+Art.m
//  TMusic
//
//  Created by Alex Zhao on 13-8-9.
//  Copyright (c) 2013年 Tarena. All rights reserved.
//

#import "UIColor+Art.h"

@implementation UIColor (Art)

+ (UIColor *)colorWith256Red:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:red / 255.0
                           green:green / 255.0
                            blue:blue / 255.0
                           alpha:alpha];
}

+ (UIColor *)colorWithHex:(long)hex {
    return [UIColor colorWithHex:hex andAlpha:1.0];
}

+ (UIColor *)colorWithHex:(long)hex andAlpha:(float)alpha {
    float red   = ((float)((hex & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hex & 0xFF00) >> 8))/255.0;
    float blue  = ((float)((hex & 0xFF)))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

// Color 转 Hex
+ (long)hexWithColor:(UIColor *)color {
    
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    NSUInteger R = (NSUInteger)(components[0] * 255.0f);
    NSUInteger G = (NSUInteger)(components[1] * 255.0f);
    NSUInteger B = (NSUInteger)(components[2] * 255.0f);
    
    NSString *sHex = [[self hexByRed:R green:G blue:B] substringFromIndex:2];
    unsigned long lHex = strtoul([sHex UTF8String], 0, 16);
    
    return (long)lHex;
}

// RGB 转 Hex
+ (NSString *)hexByRed:(NSUInteger)r green:(NSUInteger)g blue:(NSUInteger)b {
    
    NSString *str_r = [self sixteenSystemByNumber:r];
    NSString *str_g = [self sixteenSystemByNumber:g];
    NSString *str_b = [self sixteenSystemByNumber:b];
    
    return [NSString stringWithFormat:@"0x%@%@%@", str_r, str_g, str_b];
}

// 255以内 10进制 转 16进制
+ (NSString *)sixteenSystemByNumber:(NSUInteger)num {
    
    NSUInteger num10 = num / 16 % 16;
    NSUInteger num1  = num % 16;
    
    NSString *str10 = [self sixteenSystemSingleToChar:num10];
    NSString *str1  = [self sixteenSystemSingleToChar:num1];
    
    return [NSString stringWithFormat:@"%@%@", str10, str1];
}

// 个位数 10进制 转 16进制
+ (NSString *)sixteenSystemSingleToChar:(NSUInteger)num {
    
    NSUInteger n = num % 16;
    NSString *str;
    
    switch (n) {
        case 10:
            str = @"A";
            break;
        case 11:
            str = @"B";
            break;
        case 12:
            str = @"C";
            break;
        case 13:
            str = @"D";
            break;
        case 14:
            str = @"E";
            break;
        case 15:
            str = @"F";
            break;
        default:
            str = [NSString stringWithFormat:@"%d", (int)n];
            break;
    }
    
    return str;
}

@end
