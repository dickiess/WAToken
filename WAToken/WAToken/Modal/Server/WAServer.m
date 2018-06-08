//
//  WAServer.m
//  watoken
//
//  Created by dizhihao on 2018/5/17.
//  Copyright © 2018 dizhihao. All rights reserved.
//

#import "WAServer.h"


@interface WAServer()

@end

/****************************************************************************************/

static WAServer *_instance = nil;
static UIAlertView *_warnningMsg = nil;

/****************************************************************************************/

@implementation WAServer


#pragma mark - 系统管理

// 单例
+ (WAServer *)sharedInstance {
    if (_instance == nil) {
        _instance = [[WAServer alloc] init];
    }
    
    return _instance;
}

// 系统警告
- (void)systemWarnning:(NSString *)msg {
    _warnningMsg = [[UIAlertView alloc] initWithTitle:@"提示:"
                                              message:msg
                                             delegate:nil
                                    cancelButtonTitle:@"确认"
                                    otherButtonTitles:nil, nil];
    
    [_warnningMsg show];
}

// App信息打印
- (void)appInfo {
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:IOS_VERSION forKey:@"iOS_version"];
    [info setObject:APP_VERSION forKey:@"App_version"];
    NSString *width = [NSString stringWithFormat:@"%d", (int)FULL_SCREEN.width];
    NSString *height = [NSString stringWithFormat:@"%d", (int)FULL_SCREEN.height];
    [info setObject:[NSString stringWithFormat:@"%@ x %@", width, height] forKey:@"Screen_Width_Height"];
    [info setObject:[MyDevice deviceIPAdress] forKey:@"Device_IP_Address"];
    [info setObject:[MyDevice deviceMacAdress] forKey:@"Device_MAC_Address"];
    [info setObject:[MyDevice getCurrentDeviceModel] forKey:@"Device_Model"];
    NSLog(@"\n%@", info);
}

// 是否首次使用
- (BOOL)firstLauch {
    NSUserDefaults *udf = [NSUserDefaults standardUserDefaults];
    // 判断是不是第一次启动应用
    if (! [udf boolForKey:@"Launched"]) {
        [udf setBool:YES forKey:@"Launched"];
        [udf synchronize];
        return YES;
    }
        
    return NO;
}

// 是否已经阅读同意
- (BOOL)isAgreementRead {
    NSUserDefaults *udf = [NSUserDefaults standardUserDefaults];
    if (! [udf boolForKey:@"Agreed"]) {
        [udf setBool:NO forKey:@"Agreed"];
        [udf synchronize];
    }
    return [udf boolForKey:@"Agreed"];
}

// 阅读同意修改
- (BOOL)changeAgreement {
    NSUserDefaults *udf = [NSUserDefaults standardUserDefaults];
    BOOL isAgreement = ! [udf boolForKey:@"Agreed"];
    [udf setBool:isAgreement forKey:@"Agreed"];
    [udf synchronize];
    return isAgreement;
}

// 保存密钥
- (void)savePrivateKey:(NSString *)pKey {
    NSUserDefaults *udf = [NSUserDefaults standardUserDefaults];
    [udf setObject:pKey forKey:WATOKEN_PRI_KEY];
    [udf synchronize];
}

// 获取密钥
- (NSString *)getPrivateKey {
    return [[NSUserDefaults standardUserDefaults] objectForKey:WATOKEN_PRI_KEY];
}

// 删除密钥
- (void)removePrivateKey {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:WATOKEN_PRI_KEY];
}

// 拨打电话
- (void)telephoneCall:(NSString *)callNumber {
    NSString *call = [NSString stringWithFormat:@"tel:%@", callNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:call]];
}

/****************************************************************************************/

#pragma mark - 接口管理

// 登陆
- (void)loginWithName:(NSString *)name pass:(NSString *)pass callback:(Callback)cb {
    NSMutableDictionary *rlt = [NSMutableDictionary dictionary];
    if ([name isEqualToString:@"rzsoft"] &&
        [pass isEqualToString:@"123456"]) {
        [rlt setObject:[NSNumber numberWithBool:YES] forKey:@"result"];
        [rlt setObject:@"QWERTYUIOP^LKJHGFDSA_ZXCVBNM" forKey:@"pkey"];
    }
    else {
        [rlt setObject:[NSNumber numberWithBool:NO] forKey:@"result"];
        [rlt setObject:@"用户名或登陆密码不正确" forKey:@"message"];
    }
    cb(rlt);
}

// 注册
- (void)registerWithName:(NSString *)name
                  mobile:(NSString *)mobile
              invitation:(NSString *)invitation
                    pass:(NSString *)pass
                callback:(Callback)cb {
    NSMutableDictionary *rlt = [NSMutableDictionary dictionary];
    if ([invitation isEqualToString:@"rzsoft"]) {
        [rlt setObject:[NSNumber numberWithBool:YES] forKey:@"result"];
    }
    else {
        [rlt setObject:[NSNumber numberWithBool:NO] forKey:@"result"];
        [rlt setObject:@"邀请码不正确" forKey:@"message"];
    }
    cb(rlt);
}

@end
