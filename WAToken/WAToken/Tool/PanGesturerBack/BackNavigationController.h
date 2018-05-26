//
//  BackNavigationController.h
//  PanBack
//
//  Created by dizhihao on 17/4/21.
//  Copyright © 2017年 dizhihao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BackNavigationController : UINavigationController

@property (strong ,nonatomic) NSMutableArray *arrayScreenshot;

#if kUseScreenShotGesture
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
#endif

@end
