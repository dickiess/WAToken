//
//  RichAlertView.m
//  RichAlertViewModel
//
//  Created by dizhihao on 15/11/23.
//  Copyright © 2015年 dizhihao. All rights reserved.
//

#import "RichAlertView.h"

@interface RichAlertView()

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIView   *frontView;
@property (nonatomic, strong) UIView   *backView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGR;

@end

/************************************************************************************************************************/

#define MAX_SCALE    (1.2f)
#define BACK_SCALE   (0.9f)
#define MIN_SCALE    (0.1f)

#define ALPHA_10     (1.0f)
#define ALPHA_05     (0.5f)
#define ALPHA_00     (0.0f)

#define ANIMATION_OP (1) // UIViewAnimationOptionLayoutSubviews

static RichAlertView *_instance = nil;

/************************************************************************************************************************/

@implementation RichAlertView

+ (instancetype)animationAlertShareInstance {
    if (!_instance) { _instance = [[RichAlertView alloc] init]; }
    return _instance;
}

/************************************************************************************************************************/

// 传入view实现frontview动画弹出
- (void)animationAlertWithView:(UIView *)view {
    
    if (view.hidden == YES) { view.hidden = NO; }
    
    _window = [UIApplication sharedApplication].windows[0];
    
    _frontView = view;
    _frontView.alpha = ALPHA_00;
    _frontView.transform = CGAffineTransformScale(CGAffineTransformIdentity, MIN_SCALE, MIN_SCALE);
    
    _backView = [[UIView alloc] initWithFrame:self.window.bounds];
    _backView.alpha  = ALPHA_05;
    _backView.backgroundColor = [UIColor blackColor];
    
    _tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBack)];
    _tapGR.numberOfTouchesRequired = 1;
    _tapGR.numberOfTapsRequired = 1;
    
    [_backView addGestureRecognizer:_tapGR];
    [_window addSubview:_backView];
    
    view.center = _window.center;
    [_window addSubview:view];
    
    [self animationShowStepOne];
}

- (void)animationShowStepOne {
    [UIView animateWithDuration:0.3f delay:0 options:ANIMATION_OP animations:^{
        self->_frontView.alpha = ALPHA_10;
        self->_frontView.transform = CGAffineTransformScale(CGAffineTransformIdentity, MAX_SCALE, MAX_SCALE);
    } completion:^(BOOL finished) {
        [self animationShowStepTwo];
    }];
}

- (void)animationShowStepTwo {
    [UIView animateWithDuration:0.2f delay:0 options:ANIMATION_OP animations:^{
        self->_frontView.transform = CGAffineTransformScale(CGAffineTransformIdentity, BACK_SCALE, BACK_SCALE);
    } completion:^(BOOL finished) {
        [self animationShowStepThree];
    }];
}

- (void)animationShowStepThree {
    [UIView animateWithDuration:0.2f delay:0 options:ANIMATION_OP animations:^{
        self->_frontView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) { }];
}

/************************************************************************************************************************/

// 返回
- (void)tapBack {
    [self animationHiddeWithView:_frontView];
}

/************************************************************************************************************************/

// 传入view 实现view的动画隐藏
- (void)animationHiddeWithView:(UIView *)view {
    _frontView = view;
    [UIView animateWithDuration:0.2f delay:0 options:ANIMATION_OP animations:^{
        self->_frontView.transform = CGAffineTransformScale(CGAffineTransformIdentity, MAX_SCALE, MAX_SCALE);
    } completion:^(BOOL finished) {
        [self animationHiddeStepTwo];
    }];
}

- (void)animationHiddeStepTwo{
    [UIView animateWithDuration:0.4f delay:0 options:ANIMATION_OP animations:^{
        self->_frontView.alpha = ALPHA_00;
        self->_frontView.transform = CGAffineTransformScale(CGAffineTransformIdentity, MIN_SCALE, MIN_SCALE);
    } completion:^(BOOL finished) {
        if (self->_backView) {
            [self->_backView removeFromSuperview];
            self->_backView = nil;
        }
        [self->_frontView removeFromSuperview];
    }];
}

@end
