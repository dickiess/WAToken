//
//  NSString+Trimming.m
//  KingOfUnrar
//
//  Created by dizhihao on 15/10/19.
//  Copyright © 2015年 dizhihao. All rights reserved.
//

#import "NSString+Trimming.h"


@implementation NSString (Trimming)

// 字符修剪：空格 + 换行
+ (NSString *)trimmingByContent:(NSString *)content {
    
    // 1.Scanner
    NSScanner *scanner = [[NSScanner alloc] initWithString:content];
    [scanner setCharactersToBeSkipped:nil];
    
    // 2.Character Set
    NSMutableString *result = [[NSMutableString alloc] init];
    NSString *temp;
    NSCharacterSet *newLineAndWhitespaceCharacters = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    // 3.Scan
    while (![scanner isAtEnd]) {
        
        // Get non new line or whitespace characters
        temp = nil;
        [scanner scanUpToCharactersFromSet:newLineAndWhitespaceCharacters intoString:&temp];
        if (temp) {
            [result appendString:temp];
        }
        
        // Replace with a space
        if ([scanner scanCharactersFromSet:newLineAndWhitespaceCharacters intoString:nil]) {
            if (result.length > 0 && ![scanner isAtEnd]) {
                // Dont append space to beginning or end of result
                [result appendString:@" "];
            }
        }
    }
    
    // 4.Return
    return [NSString stringWithString:result];
}


// 字符匹配
+ (BOOL)equalString:(NSString *)string amongStrings:(NSArray *)array {
    
    if (![array[0] isKindOfClass:[NSString class]]) { return NO; }
    
    int flag = 0;
    for (NSString *subString in array) {
        if ([subString isEqualToString:string]) {
            flag ++;
        }
    }
    return (flag > 0) ? YES : NO;
}


/**
 *  整数转字符
 *
 *  @param  int    整数
 *
 *  @return 结果
 */
+ (NSString *)stringWithInt:(int)number {
    return [NSString stringWithFormat:@"%d", number];
}

+ (NSString *)stringWithInteger:(NSInteger)number {
    return [NSString stringWithFormat:@"%d", (int)number];
}


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
                               highlightTextRange:(NSRange)hRange {
    /*
     NSFontAttributeName                 字体
     NSParagraphStyleAttributeName       段落格式
     NSForegroundColorAttributeName      字体颜色
     NSBackgroundColorAttributeName      背景颜色
     NSStrikethroughStyleAttributeName   删除线格式
     NSUnderlineStyleAttributeName       下划线格式
     NSStrokeColorAttributeName          删除线颜色
     NSStrokeWidthAttributeName          删除线宽度
     NSShadowAttributeName               阴影
     */
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableDictionary *attribute = [NSMutableDictionary dictionary];
    [attribute setObject:hFont forKey:NSFontAttributeName];
    [attribute setObject:hColor forKey:NSForegroundColorAttributeName];
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    [ps setAlignment:NSTextAlignmentCenter];
    [attribute setObject:ps forKey:NSParagraphStyleAttributeName];
    [string addAttributes:attribute range:hRange];
    
    return string;
}


/**
 *  unicode 转换 UTF-8
 *
 *  @param utf8_str  utf-8文本
 *  @param unic_str  unicode文本
 *
 *  @return
 */

+ (NSString *)utf8StringByUnicodeString:(NSString *)unic_str {
    
    NSString *tempStr1 = [unic_str stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = nil;
    NSString *str = [NSPropertyListSerialization propertyListWithData:tempData
                                                              options:NSPropertyListImmutable
                                                               format:nil error:&err];
    return str;
}

+ (NSString *)unicodeStringByUtf8String:(NSString *)utf8_str {
    NSUInteger length = [utf8_str length];
    
    NSMutableString *s = [NSMutableString stringWithCapacity:0];
    
    for (int i = 0;i < length; i++) {
        unichar _char = [utf8_str characterAtIndex:i];
        
        // 判断是否为英文和数字
        if (_char <= '9' && _char >= '0') {
            [s appendFormat:@"%@",[utf8_str substringWithRange:NSMakeRange(i, 1)]];
        } else if(_char >= 'a' && _char <= 'z') {
            [s appendFormat:@"%@",[utf8_str substringWithRange:NSMakeRange(i, 1)]];
        } else if(_char >= 'A' && _char <= 'Z') {
            [s appendFormat:@"%@",[utf8_str substringWithRange:NSMakeRange(i, 1)]];
        } else {
            [s appendFormat:@"\\u%x",[utf8_str characterAtIndex:i]];
        }
    }
    
    return s;
}



@end
