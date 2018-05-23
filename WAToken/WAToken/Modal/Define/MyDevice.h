//
//  MyDevice.h
//  DSEM
//
//  Created by dizhihao on 16/2/23.
//  Copyright © 2016年 dizhihao. All rights reserved.
//

#import <Foundation/Foundation.h>

// 系统版本
#define IOS_VERSION     [[UIDevice currentDevice] systemVersion]
#define IOS6_OR_LATER	([IOS_VERSION compare:@"6.0"] != NSOrderedAscending)
//#define IOS7_OR_LATER	([IOS_VERSION compare:@"7.0"] != NSOrderedAscending)
#define IOS8_OR_LATER	([IOS_VERSION compare:@"8.0"] != NSOrderedAscending)
#define IOS9_OR_LATER	([IOS_VERSION compare:@"9.0"] != NSOrderedAscending)
#define IOS10_OR_LATER	([IOS_VERSION compare:@"10.0"] != NSOrderedAscending)
#define IOS11_OR_LATER    ([IOS_VERSION compare:@"11.0"] != NSOrderedAscending)

// 判断更正
#define IOS7_OR_LATER	([IOS_VERSION floatValue] >= 7.0f)

/********************************************************************************************************/

// 设备类型
#define DEVICE_IPHONE       \
([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)

#define DEVICE_IPHONE4_4S   \
(FULL_SCREEN.width == 320.0f && FULL_SCREEN.height == 480.0f) || (FULL_SCREEN.width == 480.0f && FULL_SCREEN.height == 320.0f)

#define DEVICE_IPHONE5_5S   \
(FULL_SCREEN.width == 320.0f && FULL_SCREEN.height == 568.0f) || (FULL_SCREEN.width == 568.0f && FULL_SCREEN.height == 320.0f)

#define DEVICE_IPHONE6_6S   \
(FULL_SCREEN.width == 375.0f && FULL_SCREEN.height == 667.0f) || (FULL_SCREEN.width == 667.0f && FULL_SCREEN.height == 375.0f)

#define DEVICE_IPHONE6P_6PS \
(FULL_SCREEN.width == 414.0f && FULL_SCREEN.height == 736.0f) || (FULL_SCREEN.width == 736.0f && FULL_SCREEN.height == 414.0f)

#define DEVICE_IPHONE_X \
(FULL_SCREEN.width == 375.0f && FULL_SCREEN.height == 812.0f) || (FULL_SCREEN.width == 812.0f && FULL_SCREEN.height == 375.0f)

#define DEVICE_IPAD         \
([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)

// UI 比例
#define UI_SCALE (DEVICE_IPHONE6P_6PS ? 1.3f : (DEVICE_IPHONE6_6S ? 1.2f : 1.0f))


/********************************************************************************************************/

// 手机别名
#define PHONE_NAME          [[UIDevice currentDevice] name]

// 设备名称
#define DEVICE_NAME         [[UIDevice currentDevice] systemName]

// 手机型号
#define PHONE_MODEL         [[UIDevice currentDevice] model]

// 地方型号(国际化区域名称)
#define LOCAL_PHONE_MODEL   [[UIDevice currentDevice] localizedModel]


/********************************************************************************************************/

@interface MyDevice : NSObject

// 设备名称
+ (NSString *)getCurrentDeviceModel;

// Get IP Address
+ (NSString *)deviceIPAdress;

// Get Mac Address
+ (NSString *)deviceMacAdress;

@end
