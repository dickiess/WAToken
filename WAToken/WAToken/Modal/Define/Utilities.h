//
//  Utilities.h
//  LawManager
//
//  Created by dizhihao on 15/8/19.
//  Copyright (c) 2015年 Dizhihao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    B_TOP = 1,      // 上下左右
    B_BOTTOM,
    B_LEFT,
    B_RIGHT,
    
    B_EAST = 11,    // 东南西北
    B_SOUTH,
    B_WEST,
    B_NORTH,
    
    B_FRONT = 21,   // 前后左右
    B_REAR,
    B_SIDE_LEFT,
    B_SIDE__RIGHT,
} BEARINGS;

@interface Utilities : NSObject

/******************************************************************************************
                                    Frame Rect
 *******************************************************************************************/

// 打印size
+ (void)printSize:(CGRect)frame;

// 打印frame
+ (void)printFrame:(CGRect)frame;

// 判断frame相同
+ (BOOL)isEqualFrameA:(CGRect)frameA frameB:(CGRect)frameB;

// 从相对坐标求绝对坐标
+ (CGRect)rectWithFatherFrame:(CGRect)fFrame andItemFrame:(CGRect)iFrame;

// 从绝对坐标求bounds
+ (CGRect)boundsFromFrame:(CGRect)fFrame;

// 字符数量获取frame（默认宽度）
+ (CGFloat)boundsHeightByDefaultWidth:(CGFloat)dWidth text:(NSString *)text fontsize:(CGFloat)fSize;

// 字符数量获取frame（默认高度）
+ (CGFloat)boundsWidthByDefaultHeight:(CGFloat)dHeight text:(NSString *)text fontsize:(CGFloat)fSize;

// 判断点是否在矩形中
+ (BOOL)point:(CGPoint)pt isInRect:(CGRect)rect;

// 判断矩形是否相交
+ (BOOL)rect:(CGRect)rect1 isContactRect:(CGRect)rect2;

// 中心位置不变,等比缩放
+ (CGRect)scaleRect:(CGRect)frame scale:(CGFloat)scale;

/******************************************************************************************
                                    GestureRecognizer
 *******************************************************************************************/

// 手势-点击
+ (UITapGestureRecognizer *)tapWithTarget:(id)target action:(SEL)action;


/******************************************************************************************
                                        Button
 *******************************************************************************************/

// 按钮文字带下划线
+ (void)setTextButton:(UIButton *)button withUnderLineText:(NSString *)text;

// 高亮按钮
+ (UIButton *)buttonWithFrame:(CGRect)frame
                        image:(UIImage *)image
                    highlight:(UIImage *)hImage
                          tag:(NSInteger)aTag;

/******************************************************************************************
                                        Line
 *******************************************************************************************/

// 分隔线
+ (UIView *)separationLineWithCellFrame:(CGRect)frame;

// 分隔线
+ (UIView *)separationLineWithFrame:(CGRect)frame           // 框架
                           bearings:(BEARINGS)bearings      // 方向
                             length:(CGFloat)length         // 线宽
                              color:(UIColor *)color;       // 颜色

/******************************************************************************************
                                        Timer
 *******************************************************************************************/

// 计时器简写工具
+ (NSTimer *)timerRepeatSeconds:(NSTimeInterval)aTI target:(id)aTG selector:(SEL)aSEL;


/******************************************************************************************
                                        Encryption
 *******************************************************************************************/

// SHA256加密
+ (NSString *)getSha256String:(NSString *)srcString;


/******************************************************************************************
                                        String
 *******************************************************************************************/

// 登录邮箱输入检测
+ (BOOL)isValidateEmail:(NSString *)email;

// 登录IP地址输入检测
+ (BOOL)isValidateIpAddress:(NSString *)address;

// 手机号码输入检测
+ (BOOL)isValidateMobileNumber:(NSString *)mobileNum;

// 数组中包含字符检测
+ (NSArray *)filteredArray:(NSArray *)array keyWords:(NSString *)kWords;

// 判断是否为整型
+ (BOOL)isPureInt:(NSString *)string;

// 判断是否为长整型
+ (BOOL)isPureInteger:(NSString *)string;

// 判断是否为浮点型
+ (BOOL)isPureFloat:(NSString *)string;

// 手机号码掩码
+ (NSString *)mobileNumberMask:(NSString *)mobileNum;

/******************************************************************************************
                                        Number
 *******************************************************************************************/

// 数字长度
+ (NSInteger)numberLength:(NSInteger)num;

/******************************************************************************************
                                        Text
 *******************************************************************************************/

// 文字属性: [[UITabBarItem appearance] setTitleTextAttributes:]
+ (NSDictionary *)textAttributesWithFontSize:(CGFloat)size bold:(BOOL)bold color:(long)color alpha:(CGFloat)alpha;

/******************************************************************************************
                                        Image
 *******************************************************************************************/

// 拉伸图片
+ (UIImage *)resizeImage:(UIImage *)image withEdgeInsets:(UIEdgeInsets)edgeInsets;


/******************************************************************************************
                                    ViewController
 *******************************************************************************************/

// 获取当前ViewController
+ (UIViewController *)getCurrentVC;

/******************************************************************************************
                                        Obj
 *******************************************************************************************/

// 属性搜集
+ (NSDictionary *)propsOfInstance:(id)obj Class:(Class)objClass;

// UTF-8字符显示
+ (NSString *)printDictionary:(NSDictionary *)dictionary;

@end
