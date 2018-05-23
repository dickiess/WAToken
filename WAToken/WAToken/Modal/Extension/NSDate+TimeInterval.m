
/*
 NSDate+TimeInterval.m
 
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

#import "NSDate+TimeInterval.h"

@implementation NSDate (TimeInterval)

+ (NSDateComponents *)componetsWithTimeInterval:(NSTimeInterval)timeInterval {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:timeInterval sinceDate:date1];
    
    unsigned int unitFlags = (NSCalendarUnitSecond | NSCalendarUnitMinute |
                              NSCalendarUnitHour   | NSCalendarUnitDay    |
                              NSCalendarUnitMonth  | NSCalendarUnitYear);
    
    return [calendar components:unitFlags fromDate:date1 toDate:date2 options:0];
}

+ (NSString *)timeDescriptionOfTimeInterval:(NSTimeInterval)timeInterval {
    
    NSDateComponents *components = [self.class componetsWithTimeInterval:timeInterval];
    long h = (long)components.hour;
    long m = (long)components.minute;
    long s = (long)components.second;
    if (h > 0) {
        return [NSString stringWithFormat:@"%ld:%02ld:%02ld", h, m, s];
    } else {
        return [NSString stringWithFormat:@"%ld:%02ld", m, s];
    }
}

// 解析数据时间
+ (NSString *)timeDescriptionByDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // HH是24进制，hh是12进制
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 返回的格林治时间 @"2010-09-09 13:14:56"
    return [formatter stringFromDate:date];
}

// 解析数据时间
+ (NSString *)timeDescriptionByTimeInterval:(NSTimeInterval)timeInterval {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [self timeDescriptionByDate:date];
}

// 生成指定时间 @"2010-09-09 13:14:56"
+ (NSDate *)dateWithTimeString:(NSString *)timeString {
    // 2013-04-07 11:14:45
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // HH是24进制，hh是12进制
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // formatter.locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease];
    
    // 返回的格林治时间 @"2010-09-09 13:14:56"
    return [formatter dateFromString:timeString];
}

// 精确度日期
- (NSString *)dateToString:(DATE_ACCURATE)type {
    NSString *timeStr = nil;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    switch (type) {
        case ACCURATE_TO_MIN: {
            [df setDateFormat:@"yyyy-MM-dd HH:mm"];
            timeStr = [df stringFromDate:self];
        } break;
        
        case ACCURATE_TO_DAY: {
            [df setDateFormat:@"yyyy-MM-dd"];
            timeStr = [df stringFromDate:self];
        } break;
            
        case ACCURATE_TO_MONTH: {
            [df setDateFormat:@"yyyy-MM"];
            timeStr = [df stringFromDate:self];
        } break;
        
        default: {
            [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            timeStr = [df stringFromDate:self];
        } break;
    }
    
    return timeStr;
}

// 今天是否运行过
+ (BOOL)haveRunningToday {
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDate = [df stringFromDate:nowDate];
    
    // 如果从未运行,则存入日期
    NSUserDefaults *udf = [NSUserDefaults standardUserDefaults];
    if ([udf objectForKey:@"LastUsageDate"] == nil) {
        [udf setObject:currentDate forKey:@"LastUsageDate"];
        [udf synchronize];
        return NO;
    }
    
    // 如果日期不符,则存入日期
    NSString *lastUsageDate = [udf objectForKey:@"LastUsageDate"];
    if (![lastUsageDate isEqualToString:currentDate]) {
        [udf setObject:currentDate forKey:@"LastUsageDate"];
        [udf synchronize];
        return NO;
    }

    // 日期相同
    return YES;
}


@end
