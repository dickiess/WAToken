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
#import "WATokenApi.h"

#import "NSDate+TimeInterval.h"
#import "NSObject+PerformBlockAfterDelay.h"
#import "NSString+Trimming.h"
#import "UIColor+Art.h"
#import "UIImage+Extension.h"

#import "RichNavigationController.h"

#import "DzhProcessHUD.h"

#import "RichUser.h"

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

#pragma mark - 系统管理

@interface WAServer : NSObject

@property (nonatomic, strong) RichUser *user;

// 单例
+ (WAServer *)sharedInstance;

// 系统警告
- (void)systemWarnning:(NSString *)msg;

// App信息打印
- (void)appInfo;

// 是否首次使用
- (BOOL)firstLauch;

// 是否已经阅读同意
- (BOOL)isAgreementRead;

// 阅读同意修改
- (BOOL)changeAgreement;

// 保存密钥
- (void)savePrivateKey:(NSString *)pKey;

// 获取密钥
- (NSString *)getPrivateKey;

// 删除密钥
- (void)removePrivateKey;

// 拨打电话
- (void)telephoneCall:(NSString *)callNumber;

/****************************************************************************************/

#pragma mark - 接口管理

// 登陆
- (void)loginWithName:(NSString *)name
                 pass:(NSString *)pass
             callback:(Callback)cb;

// 注册
- (void)registerWithName:(NSString *)name
                  mobile:(NSString *)mobile
              invitation:(NSString *)invitation
                    pass:(NSString *)pass
                callback:(Callback)cb;



@end
