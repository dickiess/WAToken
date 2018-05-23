//
//  Utilities.m
//  LawManager
//
//  Created by dizhihao on 15/8/19.
//  Copyright (c) 2015年 Dizhihao. All rights reserved.
//

#import "Utilities.h"
#import "Defines.h"
#import "UIColor+Art.h"
#import "NSString+Trimming.h"
#import <CommonCrypto/CommonDigest.h>
#import <objc/runtime.h>

@implementation Utilities

/***************************************************************************************************************/

#pragma mark - 坐标、矩形

// 打印size
+ (void)printSize:(CGRect)frame {
    
    int w, h;
    w = (int)frame.size.width;
    h = (int)frame.size.height;
    NSLog(@"size with width:%d height:%d", w, h);
}

// 打印frame
+ (void)printFrame:(CGRect)frame {
    
    int x, y, w, h;
    x = (int)frame.origin.x;
    y = (int)frame.origin.y;
    w = (int)frame.size.width;
    h = (int)frame.size.height;
    NSLog(@"x:%d y:%d w:%d h:%d", x, y, w, h);
}

// 判断frame相同
+ (BOOL)isEqualFrameA:(CGRect)frameA frameB:(CGRect)frameB {
    int flag = 0;
    flag += frameA.origin.x == frameB.origin.y ? 1 : 0;
    flag += frameA.origin.y == frameB.origin.y ? 1 : 0;
    flag += frameA.size.width == frameB.size.width ? 1 : 0;
    flag += frameA.size.height == frameB.size.height ? 1 : 0;
    return flag == 4 ? YES : NO;
}

// 从相对坐标求绝对坐标
+ (CGRect)rectWithFatherFrame:(CGRect)fFrame andItemFrame:(CGRect)iFrame {
    
    CGRect frame = iFrame;
    frame.origin.x = fFrame.origin.x + iFrame.origin.x;
    frame.origin.y = fFrame.origin.y + iFrame.origin.y;
    return frame;
}

// 从绝对坐标求bounds
+ (CGRect)boundsFromFrame:(CGRect)fFrame {
    CGRect bounds = fFrame;
    bounds.origin = CGPointZero;
    return bounds;
}

// 字符数量获取高度（默认宽度）
+ (CGFloat)boundsHeightByDefaultWidth:(CGFloat)dWidth text:(NSString *)text fontsize:(CGFloat)fSize {
    CGSize size = CGSizeMake(dWidth, 999.0f);
    NSStringDrawingOptions op = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fSize]};
    CGRect rect = [text boundingRectWithSize:size options:op attributes:attributes context:nil];
    
    return rect.size.height;
}

// 字符数量获取宽度（默认高度）
+ (CGFloat)boundsWidthByDefaultHeight:(CGFloat)dHeight text:(NSString *)text fontsize:(CGFloat)fSize {
    CGSize size = CGSizeMake(999.0f, dHeight);
    NSStringDrawingOptions op = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fSize]};
    CGRect rect = [text boundingRectWithSize:size options:op attributes:attributes context:nil];
    return rect.size.width;
}

// 判断点是否在矩形中
+ (BOOL)point:(CGPoint)pt isInRect:(CGRect)rect {
    return CGRectContainsPoint(rect, pt) ? YES : NO;
}

// 判断矩形是否相交
+ (BOOL)rect:(CGRect)rect1 isContactRect:(CGRect)rect2 {
    return CGRectContainsRect(rect1, rect2) ? YES : NO;
}

// 中心位置不变,等比缩放
+ (CGRect)scaleRect:(CGRect)frame scale:(CGFloat)scale {
    
    CGFloat s = scale > 10 ? 10 : scale;
    s = s < 0.01f ? 0.01 : s;
    
    CGFloat x = frame.origin.x;
    CGFloat y = frame.origin.y;
    CGFloat w = frame.size.width;
    CGFloat h = frame.size.height;
    CGPoint oCenter = CGPointMake(x + w / 2, y + h / 2);
    
    return CGRectMake((oCenter.x - w * s / 2), (oCenter.y - h * s / 2), w * s, h * s);
}

/***************************************************************************************************************/

#pragma mark - 手势

// 手势-点击
+ (UITapGestureRecognizer *)tapWithTarget:(id)target action:(SEL)action {
    return [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
}

/***************************************************************************************************************/

#pragma mark - 按钮控件

// 按钮文字带下划线
+ (void)setTextButton:(UIButton *)button withUnderLineText:(NSString *)text {
    
    // 1.normal
    NSMutableAttributedString *settingStr1 = [[NSMutableAttributedString alloc] initWithString:text];
    NSDictionary *settingAttr1 = @{ NSFontAttributeName : [UIFont systemFontOfSize:15],
                                    NSForegroundColorAttributeName : [UIColor whiteColor],
                                    NSUnderlineStyleAttributeName : [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSRange settingRange1 = {0, [settingStr1 length]};
    [settingStr1 addAttributes:settingAttr1 range:settingRange1];
    [button setAttributedTitle:settingStr1 forState:UIControlStateNormal];
    
    // 2.highlight
    NSMutableAttributedString *settingStr2 = [[NSMutableAttributedString alloc] initWithString:text];
    NSDictionary *settingAttr2 = @{ NSFontAttributeName : [UIFont systemFontOfSize:15],
                                    NSForegroundColorAttributeName : [UIColor lightGrayColor],
                                    NSUnderlineStyleAttributeName : [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSRange settingRange2 = {0, [settingStr2 length]};
    [settingStr2 addAttributes:settingAttr2 range:settingRange2];
    [button setAttributedTitle:settingStr2 forState:UIControlStateHighlighted];
}

// 高亮按钮
+ (UIButton *)buttonWithFrame:(CGRect)frame
                        image:(UIImage *)image
                    highlight:(UIImage *)hImage
                          tag:(NSInteger)aTag {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:frame];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:hImage forState:UIControlStateHighlighted];
    [btn setTag:aTag];
    return btn;
}

/***************************************************************************************************************/

#pragma mark - 线条

// 分隔线
+ (UIView *)separationLineWithCellFrame:(CGRect)frame {
    
    CGFloat y = [Utilities isEqualFrameA:frame frameB:CGRectZero] ? 0.6f : frame.size.height;
    CGRect lFrame = CGRectMake(0, y - 0.6f, MAX(FULL_SCREEN.width, FULL_SCREEN.height), 0.6f);
    UIView *line = [[UIView alloc] initWithFrame:lFrame];
    [line setBackgroundColor:[UIColor lightGrayColor]];
    return line;
}

// 分隔线(分割对象外布局)
+ (UIView *)separationLineWithFrame:(CGRect)frame           // 框架
                           bearings:(BEARINGS)bearings      // 方向
                             length:(CGFloat)length         // 线宽
                              color:(UIColor *)color {      // 颜色
    CGFloat len = length > 0.1f ? length : 0.1f;
    CGRect rect = frame;
    switch (bearings) {
        case B_TOP: {
            rect.size.height = len;
        } break;
            
        case B_BOTTOM: {
            rect.origin.y += rect.size.height;
            rect.origin.y -= len;
            rect.size.height = len;
        } break;
            
        case B_LEFT: {
            rect.size.width = len;
        } break;
            
        case B_RIGHT: {
            rect.origin.x += rect.size.width;
            rect.origin.x -= len;
            rect.size.width = len;
        } break;
            
        default: {      // 默认为底部
            rect.origin.y += rect.size.height;
            rect.origin.y -= len;
            rect.size.height = len;
        } break;
    }
    
    UIView *line = [[UIView alloc] initWithFrame:rect];
    [line setBackgroundColor:color];
    
    return line;
}

/***************************************************************************************************************/

#pragma mark - 计时器、延时

// 计时器简写工具
+ (NSTimer *)timerRepeatSeconds:(NSTimeInterval)aTI target:(id)aTG selector:(SEL)aSEL {
    return [NSTimer scheduledTimerWithTimeInterval:aTI target:aTG selector:aSEL userInfo:nil repeats:YES];
}


/***************************************************************************************************************/

#pragma mark - 加密

// SHA256加密
+ (NSString *)getSha256String:(NSString *)srcString {
    
    const char *cstr = [srcString UTF8String];
    NSData *data = [NSData dataWithBytes:cstr length:strlen(cstr)];
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(data.bytes, (int)data.length, digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i ++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;
}

/***************************************************************************************************************/

#pragma mark - 字符

// 登录邮箱输入检测
+ (BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

// 登录IP地址输入检测
+ (BOOL)isValidateIpAddress:(NSString *)address {
    NSString *addressRegex = @"((2[0-4][0-9]|25[0-5]|[01]?[0-9][0-9]?)\\.){3}(2[0-4][0-9]|25[0-5]|[01]?[0-9][0-9]?)";
    NSPredicate *addressTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", addressRegex];
    return [addressTest evaluateWithObject:address];
}

// 手机号码输入检测
+ (BOOL)isValidateMobileNumber:(NSString *)mobileNum {
    
    //    电信号段:133/153/180/181/189/177
    //    联通号段:130/131/132/155/156/185/186/145/176
    //    移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
    //    虚拟运营商:170
    //    补充:电信运营商:173、149
    //    补充:虚拟运营商:171
    
    NSString *MOBILE = @"^1(3[0-9]|4[579]|5[0-35-9]|8[0-9]|7[0136-8])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:mobileNum];
}

// 数组中包含字符检测
+ (NSArray *)filteredArray:(NSArray *)array keyWords:(NSString *)kWords {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", kWords];
    return [array filteredArrayUsingPredicate:pred];
}

// 判断是否为整型
+ (BOOL)isPureInt:(NSString *)string {
    NSScanner *scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

// 判断是否为长整型
+ (BOOL)isPureInteger:(NSString *)string {
    NSScanner *scan = [NSScanner scannerWithString:string];
    NSInteger val;
    return [scan scanInteger:&val] && [scan isAtEnd];
}

// 判断是否为浮点型
+ (BOOL)isPureFloat:(NSString *)string {
    NSScanner *scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

// 手机号码掩码
+ (NSString *)mobileNumberMask:(NSString *)mobileNum {
    if (mobileNum.length > 11 || mobileNum == 0) {
        return @"";
    }

    NSString *s1 = [mobileNum substringWithRange:NSMakeRange(0, 3)];
    NSString *s2 = @"****";
    NSString *s3 = [mobileNum substringWithRange:NSMakeRange(7, 4)];
    return [NSString stringWithFormat:@"%@%@%@", s1, s2, s3];
}

/***************************************************************************************************************/

// 数字长度
+ (NSInteger)numberLength:(NSInteger)num {
    NSString *s = [NSString stringWithFormat:@"%ld", (long)num];
    return (NSInteger)s.length;
}

/***************************************************************************************************************/

// 文字属性
+ (NSDictionary *)textAttributesWithFontSize:(CGFloat)size bold:(BOOL)bold color:(long)color alpha:(CGFloat)alpha {
    UIColor *cr = [UIColor colorWithHex:color andAlpha:alpha];
    if (bold) {
        return @{NSFontAttributeName:[UIFont boldSystemFontOfSize:size], NSForegroundColorAttributeName:cr};
    } else {
        return @{NSFontAttributeName:[UIFont systemFontOfSize:size], NSForegroundColorAttributeName:cr};
    }
}

/***************************************************************************************************************/

#pragma mark - 图片

// 拉伸图片
+ (UIImage *)resizeImage:(UIImage *)image withEdgeInsets:(UIEdgeInsets)edgeInsets {
    return [image resizableImageWithCapInsets:edgeInsets];
}

/***************************************************************************************************************/


// 获取当前ViewController
+ (UIViewController *)getCurrentVC {
    UIViewController *result = nil;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
    } else {
        result = window.rootViewController;
    }
    
    return result;
}

/***************************************************************************************************************/


// 属性搜集
+ (NSDictionary *)propsOfInstance:(id)obj Class:(Class)objClass {
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    if ((![obj isKindOfClass:objClass]) || (obj == nil)) {
        return [NSDictionary dictionaryWithDictionary:props];
    }
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(objClass, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char * char_f = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [obj valueForKey:(NSString *)propertyName];
        if (propertyValue) {
            [props setObject:propertyValue forKey:propertyName];
        }
    }
    free(properties);
    return [NSDictionary dictionaryWithDictionary:props];
}


// UTF-8字符显示
// log NSSet with UTF8, if not ,log will be \Uxxx
+ (NSString *)printDictionary:(NSDictionary *)dictionary {
    if (dictionary == nil) { return nil; }
    
    return [NSString utf8StringByUnicodeString:[dictionary description]];
}

@end
