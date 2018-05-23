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

/****************************************************************************************/

@implementation WAServer

+ (WAServer *)sharedInstance {
    if (_instance == nil) {
        _instance = [[WAServer alloc] init];
    }
    
    return _instance;
}

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

/****************************************************************************************/

// 拨打电话
- (void)telephoneCall:(NSString *)callNumber {
    NSString *call = [NSString stringWithFormat:@"tel:%@", callNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:call]];
}


/****************************************************************************************/

- (void)loginWithName:(NSString *)name pass:(NSString *)pass callback:(Callback)cb {
    NSMutableDictionary *rlt = [NSMutableDictionary dictionary];
    if ([name isEqualToString:@"rzsoft"] &&
        [pass isEqualToString:@"123456"]) {
        [rlt setObject:[NSNumber numberWithBool:YES] forKey:@"result"];
    }
    else {
        [rlt setObject:[NSNumber numberWithBool:NO] forKey:@"result"];
        [rlt setObject:@"用户名或登陆密码不正确" forKey:@"message"];
    }
    cb(rlt);
}


@end