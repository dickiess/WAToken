//
//  ScreenShotView.h
//  ScreenShotBack
//
//  Created by dizhihao on 17/4/21.
//  Copyright © 2016年 dizhihao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScreenShotView : UIView

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) NSMutableArray *arrayImage;

- (void)showEffectChange:(CGPoint)pt;
- (void)restore;
- (void)screenShot;

@end
