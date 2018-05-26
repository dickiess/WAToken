//
//  DzhProcessHUD.m
//  yunchaomi
//
//  Created by dizhihao on 14/12/5.
//  Copyright (c) 2014年 狄志豪. All rights reserved.
//

#import "DzhProcessHUD.h"

@interface WaitingHUD()

@property (atomic, strong) UIWindow                 *window;
@property (atomic, strong) UIToolbar                *hud;
@property (atomic, strong) UIActivityIndicatorView  *spinner;
@property (atomic, strong) UILabel                  *label;

@end

#define HUD_TEXT_COLOR      [UIColor whiteColor]
#define HUD_TEXT_FONT       [UIFont boldSystemFontOfSize:15]

@implementation WaitingHUD

// 唯一对象
+ (WaitingHUD *)shared {
    // 1.singleton
    static dispatch_once_t once = 0;
    static WaitingHUD *waitingHUD = nil;
    
    // 2.create view
    dispatch_once(&once, ^{     // 线程安全
        waitingHUD = [[WaitingHUD alloc] init];
    });
    
    return waitingHUD;
}

// （类方法）显示
+ (void)show:(NSString *)text {
    [[self shared] hudMake:text spin:YES autoHide:NO];
}

// （类方法）消失
+ (void)dismiss {
    [[self shared] hudHide];
}

// 初始化
- (id)init {
    // 1.init with frame (full screen)
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // 2.window init
    id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate respondsToSelector:@selector(window)])
        _window = [delegate performSelector:@selector(window)];
    else
        _window = [[UIApplication sharedApplication] keyWindow];
    
    // 3.items init
    _hud = nil;
    _spinner = nil;
    _label = nil;
    
    // 4.alpha
    self.alpha = 0;
    
    return self;
}

// HUD开始
- (void)hudMake:(NSString *)text spin:(BOOL)spin autoHide:(BOOL)hide {
    // 1.hud create
    [self hudCreate];

    // 2.label
    _label.text = text;
    _label.textColor = [UIColor whiteColor];
    _label.hidden = (text == nil) ? YES : NO;

    // 3.spinner
    _spinner.color = [UIColor whiteColor];
    if (spin) {
        [_spinner startAnimating];
    } else {
        [_spinner stopAnimating];
    }
    
    // 4.hud
    [self hudOrient];
    [self hudSize];
    [self hudShow];

    // 5.hide
    if (hide)   // display hud until time's up, hud will hide
        [NSThread detachNewThreadSelector:@selector(timedHide)
                                 toTarget:self
                               withObject:nil];
}

// HUD创建
- (void)hudCreate {
    // 1.hud
    if (_hud == nil) {
        // 1.1 hud create
        _hud = [[UIToolbar alloc] initWithFrame:CGRectZero];
        _hud.barStyle = UIBarStyleBlackOpaque;
        _hud.translucent = YES;
        _hud.layer.cornerRadius = 10;
        _hud.layer.masksToBounds = YES;
        
        // 1.2 notification for device rotation
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(rotate:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
    }
    if (_hud.superview == nil) [_window addSubview:_hud];

    // 2.spinner
    if (_spinner == nil) {
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _spinner.color = [UIColor clearColor];
        _spinner.hidesWhenStopped = YES;
    }
    if (_spinner.superview == nil) [_hud addSubview:_spinner];

    // 3.label
    if (_label == nil)
    {
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        _label.font = HUD_TEXT_FONT;
        _label.textColor = HUD_TEXT_COLOR;
        _label.backgroundColor = [UIColor clearColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _label.numberOfLines = 0;
    }
    if (_label.superview == nil) [_hud addSubview:_label];
}

// HUD移除
- (void)hudDestroy {
    // 1.notification
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil];
    // 2.items
    [_label removeFromSuperview];	_label = nil;
    [_spinner removeFromSuperview];	_spinner = nil;
    [_hud removeFromSuperview];		_hud = nil;
}

// 旋转方向
- (CGFloat)rotate:(NSNotification *)notification {
    return [self hudOrient];
}

// 屏幕旋转适配,旋转方向
- (CGFloat)hudOrient {
    
    CGFloat rotate = 0.0f;
    UIInterfaceOrientation orient = [[UIApplication sharedApplication] statusBarOrientation];
    if (orient == UIInterfaceOrientationPortrait)			rotate = 0.0;
    if (orient == UIInterfaceOrientationPortraitUpsideDown)	rotate = M_PI;
    if (orient == UIInterfaceOrientationLandscapeLeft)		rotate = - M_PI_2;
    if (orient == UIInterfaceOrientationLandscapeRight)		rotate = + M_PI_2;
    _hud.transform = CGAffineTransformMakeRotation(rotate);
    return orient;
}

// 显示尺寸
- (CGRect)hudSize {
    CGRect labelRect = CGRectZero;
    CGFloat hudWidth = 100, hudHeight = 100;

    if (_label.text != nil) {
        // 1.label
        NSDictionary *attributes = @{NSFontAttributeName:_label.font};
        NSInteger options = (NSStringDrawingUsesFontLeading |
                             NSStringDrawingTruncatesLastVisibleLine |
                             NSStringDrawingUsesLineFragmentOrigin);
        labelRect = [_label.text boundingRectWithSize:CGSizeMake(200, 300)  // text bounds(width & height)
                                              options:options
                                           attributes:attributes
                                              context:nil];
        labelRect.origin.x = 12;
        labelRect.origin.y = 66;
        
        // 2.hud
        hudWidth = labelRect.size.width + 24;
        hudHeight = labelRect.size.height + 80;
        if (hudWidth < 100) {
            hudWidth = 100;
            labelRect.origin.x = 0;
            labelRect.size.width = 100;
        }
    }

    // 3.hud frame
    CGSize screen = [UIScreen mainScreen].bounds.size;
    _hud.center = CGPointMake(screen.width/2, screen.height/2);
    _hud.bounds = CGRectMake(0, 0, hudWidth, hudHeight);

    // 4.spinner point
    _spinner.center = CGPointMake(hudWidth/2, (_label.text == nil) ? hudHeight/2 : 36);
    
    // 5.label frame
    _label.frame = labelRect;
    
    return _hud.frame;
}

// 显示（动画）
- (void)hudShow {
    if (self.alpha == 0) {
        self.alpha = 1;
        
        _hud.alpha = 0;
        _hud.transform = CGAffineTransformScale(_hud.transform, 1.4, 1.4);  // scale 1.4 times
        
        NSUInteger options = (UIViewAnimationOptionAllowUserInteraction |
                              UIViewAnimationCurveEaseOut);
        
        [UIView animateWithDuration:0.15 delay:0 options:options animations:^{
            self.hud.transform = CGAffineTransformScale(self->_hud.transform, 1/1.4, 1/1.4);  // scale 1/1.4 times
            self.hud.alpha = 1;
        } completion:^(BOOL finished){}];
    }
}

// 隐藏（动画）
- (void)hudHide {
    if (self.alpha == 1) {
        NSUInteger options = (UIViewAnimationOptionAllowUserInteraction |
                              UIViewAnimationCurveEaseIn);
        
        [UIView animateWithDuration:0.15 delay:0 options:options animations:^{
            self->_hud.transform = CGAffineTransformScale(self->_hud.transform, 1/1.4, 1/1.4);  // scale 1/1.4 times
            self->_hud.alpha = 0;
        } completion:^(BOOL finished) {
             [self hudDestroy];
             self.alpha = 0;
         }];
    }
}

// 自动隐藏
- (void)timedHide {
    @autoreleasepool {
        double length = _label.text.length;
        NSTimeInterval sleep = length * 0.04 + 0.5;
        [NSThread sleepForTimeInterval:sleep];
        [self hudHide];
    }
}

@end
