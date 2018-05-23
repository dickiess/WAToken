//
//  NSString+Trimming.h
//  KingOfUnrar
//
//  Created by dizhihao on 15/10/19.
//  Copyright © 2015年 dizhihao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdocumentation"

#define BLANK_STR(str)                  ([str isEqualToString:@""] || str == nil)
#define DIFF_STR(str1, str2)            (![str1 isEqualToString:str2])
#define EQUAL_STR(str1, str2)           ([str1 isEqualToString:str2])
#define SAFE_STR(str)                   (str == [NSNull null] ? @"" : (BLANK_STR(str) ? @"" : str))
#define SAFE_STR_REPLACE(str, replace)  (str == [NSNull null] ? replace : (BLANK_STR(str) ? replace : str))

@interface NSString (Trimming)


/**
 *  字符修剪：空格 + 换行
 *
 *  @param content 源文字内容
 *
 *  @return 无空格及换行文字
 */
+ (NSString *)trimmingByContent:(NSString *)content;



/**
 *  字符匹配
 *
 *  @param string 参与匹配的字符串
 *  @param array  需要匹配的字符列表
 *
 *  @return 结果
 */
+ (BOOL)equalString:(NSString *)string amongStrings:(NSArray *)array;



/**
 *  整数转字符
 *
 *  @param  int 整数
 *
 *  @return 结果
 */
+ (NSString *)stringWithInt:(int)number;

+ (NSString *)stringWithInteger:(NSInteger)number;


/**
 *  富文本
 *
 *  @param text      基本文本
 *  @param hFont     高亮字体
 *  @param hColor    高亮颜色
 *  @param alignment 高亮文字对齐
 *  @param hRange    高亮范围
 *
 *  @return 富文本
 */
+ (NSMutableAttributedString *)setupAttributeText:(NSString *)text
                                highlightTextFont:(UIFont *)hFont
                               highlightTextColor:(UIColor *)hColor
                           highlightTextAlignment:(NSTextAlignment)alignment
                               highlightTextRange:(NSRange)hRange;

/**
 *  unicode 转换 UTF-8
 *
 *  @param utf8_str  utf-8文本
 *  @param unic_str  unicode文本
 *
 *  @return
 */

+ (NSString *)utf8StringByUnicodeString:(NSString *)unic_str;

+ (NSString *)unicodeStringByUtf8String:(NSString *)utf8_str;

@end
