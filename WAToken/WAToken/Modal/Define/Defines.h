//
//  Defines.h
//  watoken
//
//  Created by dizhihao on 2018/4/20.
//  Copyright © 2018 dizhihao. All rights reserved.
//


#ifndef DEFINE_H
#define DEFINE_H

// App参数
#define APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

#define MY_ICON     @"def_icon"      // 默认头像

/********************************************************************************************************/

// 系统版本
#define IOS_VERSION     [[UIDevice currentDevice] systemVersion]
#define IOS6_OR_LATER    ([IOS_VERSION compare:@"6.0"] != NSOrderedAscending)
//#define IOS7_OR_LATER    ([IOS_VERSION compare:@"7.0"] != NSOrderedAscending)
#define IOS8_OR_LATER    ([IOS_VERSION compare:@"8.0"] != NSOrderedAscending)
#define IOS9_OR_LATER    ([IOS_VERSION compare:@"9.0"] != NSOrderedAscending)
#define IOS10_OR_LATER    ([IOS_VERSION compare:@"10.0"] != NSOrderedAscending)
#define IOS11_OR_LATER    ([IOS_VERSION compare:@"11.0"] != NSOrderedAscending)

// 判断更正
#define IOS7_OR_LATER    ([IOS_VERSION floatValue] >= 7.0f)

/********************************************************************************************************/

// 屏幕尺寸
#define FULL_FRAME                  [[UIScreen mainScreen] bounds]
#define FULL_SCREEN                 FULL_FRAME.size
#define SCREEN_HALF_WIDTH           (FULL_SCREEN.width/2)
#define SCREEN_HALF_HEIGHT          (FULL_SCREEN.height/2)
#define FRAME(x, y, width, height)  CGRectMake((x),(y),(width),(height))

#define NAVIGATION_HEIGHT           (66.0f)
#define TAB_BAR_HEIGHT              (50.0f)

/********************************************************************************************************/

// 系统尺寸
#define STATUS_BAR_HEIGHT  (IOS7_OR_LATER ? 20.0f : 40.0f)
#define NAVI_BAR_HEIGHT    (60.0f)
#define TAB_BAR_HEIGHT     (50.0f)
#define LR_GAP             (10.0f)

/********************************************************************************************************/

// 文字尺寸
#define FONT_15    [UIFont systemFontOfSize:(15.0f)]
#define FONT_14    [UIFont systemFontOfSize:(14.0f)]
#define FONT_13    [UIFont systemFontOfSize:(13.0f)]
#define FONT_12    [UIFont systemFontOfSize:(12.0f)]
#define FONT_10    [UIFont systemFontOfSize:(10.0f)]
#define FONT_8     [UIFont systemFontOfSize:(8.0f)]
#define FONT(size) [UIFont systemFontOfSize:(size)]

/********************************************************************************************************/

// 消息广播
#define StartLocation           @"LocationStart"
#define StopLocation            @"LocationStop"
#define UpdateThumbImage        @"UpdateThumbImage"
#define NewMessageRecieved      @"NewMessageRecieved"

// 系统消息
#define NOTI_LANGUAGE_CHANGE    @"LanguageChanged"      // 语言切换
#define NOTI_REFRESH_LOCAL      @"RefreshLocalFiles"    // 刷新文件页面

/********************************************************************************************************/

#endif






