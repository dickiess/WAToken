//
//  AppDelegate.h
//  WAToken
//
//  Created by dizhihao on 2018/5/23.
//  Copyright © 2018 dizhihao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ScreenShotBackConfig.h"

#if kUseScreenShotGesture
#import "ScreenShotView.h"
#endif

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (copy,   nonatomic) void (^backgroundURLSessionCompletionHandler)(void);

#if kUseScreenShotGesture
@property (nonatomic, strong) ScreenShotView *screenshotView;
#endif

+ (AppDelegate *)shareAppDelegate;

@end
