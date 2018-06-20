
/*
 NSDate+TimeInterval.h
 
 The MIT License (MIT)
 
 Copyright (c) 2013 Clement CN Tsang
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */


#import <Foundation/Foundation.h>

typedef enum {
    ACCURATE_TO_SEC,        // 精确到秒
    ACCURATE_TO_MIN,        // 精确到分钟
    ACCURATE_TO_DAY,        // 精确到每日
    ACCURATE_TO_MONTH,      // 精确到每月
} DATE_ACCURATE;

@interface NSDate (TimeInterval)

// 不知道干嘛用的
//+ (NSDateComponents *)componetsWithTimeInterval:(NSTimeInterval)timeInterval;

// 见 Tool/CTAssetsPicker/CTAssetsViewCell.m
+ (NSString *)timeDescriptionOfTimeInterval:(NSTimeInterval)timeInterval;

// 解析数据时间
+ (NSString *)timeDescriptionByDate:(NSDate *)date;

// 解析数据时间
+ (NSString *)timeDescriptionByTimeInterval:(NSTimeInterval)timeInterval;

// 生成指定时间 @"2010-09-09 13:14:56"
+ (NSDate *)dateWithTimeString:(NSString *)timeString;

// 精确度日期
- (NSString *)dateToString:(DATE_ACCURATE)type;

// 今天是否运行过
+ (BOOL)haveRunningToday;

@end
