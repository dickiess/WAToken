//
//  DzhProcessHUD.h
//  yunchaomi
//
//  Created by dizhihao on 14/12/5.
//  Copyright (c) 2014年 狄志豪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaitingHUD : UIView

// 唯一对象
+ (WaitingHUD *)shared;

// 显示
+ (void)show:(NSString *)text;

// 消失
+ (void)dismiss;

@end
