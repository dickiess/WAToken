//
//  WAServer.h
//  watoken
//
//  Created by dizhihao on 2018/5/17.
//  Copyright © 2018 dizhihao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "Defines.h"
#import "Interfaces.h"
#import "MyDevice.h"
#import "Utilities.h"

#import "WAAppInfo.h"

#import "NSDate+TimeInterval.h"
#import "NSObject+PerformBlockAfterDelay.h"
#import "NSString+Trimming.h"
#import "UIColor+Art.h"
#import "UIImage+Extension.h"



/****************************************************************************************/

#pragma mark - 单例

#define WA_API  [WAServer sharedInstance]

typedef void (^Callback)(id obj);

/****************************************************************************************/

#pragma mark - 协议

@class WAServer;
@protocol WAServerDelegate <NSObject>

@end

/****************************************************************************************/

#pragma mark - 接口

@interface WAServer : NSObject

// 单例
+ (WAServer *)sharedInstance;

// App信息打印
- (void)appInfo;

// 是否首次使用
- (BOOL)firstLauch;

// 拨打电话
- (void)telephoneCall:(NSString *)callNumber;

/****************************************************************************************/

- (void)loginWithName:(NSString *)name pass:(NSString *)pass callback:(Callback)cb;

@end
