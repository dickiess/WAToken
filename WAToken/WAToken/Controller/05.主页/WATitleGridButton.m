//
//  WATitleGridButton.m
//  WAToken
//
//  Created by dizhihao on 2018/6/1.
//  Copyright © 2018 dizhihao. All rights reserved.
//

#import "WATitleGridButton.h"

#import "MyDevice.h"

#define frameWidth   ([[UIScreen mainScreen] bounds].size.width/3)
// 框架尺寸参考宽度屏幕3分之一
#define frameHeight     (frameWidth)                 // 框架尺寸参考高度与宽度一致
#define mainTitleWidth  (frameWidth*125/125)         // 主题文字尺寸参考宽度125
#define mainTitleHeight (frameHeight*35/125)         // 主题文字尺寸参考高度35
#define mainTitle_x     (frameWidth * 0/125)         // 主题文字X位置参考位置居中
#define mainTitle_y     (frameHeight*28/125)         // 主题文字Y位置参考位置28
#define subTitleWidth   (frameWidth*125/125)         // 辅助文字尺寸参考宽度125
#define subTitleHeight  (frameHeight*28/125)         // 辅助文字尺寸参考高度28
#define subTitle_x      (frameWidth * 0/125)         // 辅助文字X位置参考位置0
#define subTitle_y      (frameHeight*80/125)         // 辅助文字Y位置参考位置80


@implementation WATitleGridButton

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, frameWidth, frameHeight)];
    if (self) {
        // main title label
        CGRect mainTitleRect = CGRectMake(mainTitle_x, mainTitle_y, mainTitleWidth, mainTitleHeight);
        _titleLabel = [[UILabel alloc] initWithFrame:mainTitleRect];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:(DEVICE_IPAD ? 24.0f : 18.0f)];
        _titleLabel.textColor = [UIColor blackColor];
        [self addSubview:_titleLabel];
        
        // subtitle label
        CGRect subTitleRect = CGRectMake(subTitle_x, subTitle_y, subTitleWidth, subTitleHeight);
        _subtitleLabel = [[UILabel alloc] initWithFrame:subTitleRect];
        _subtitleLabel.textAlignment = NSTextAlignmentCenter;
        _subtitleLabel.font = [UIFont systemFontOfSize:(DEVICE_IPAD ? 18.0f : 14.0f)];
        _subtitleLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:_subtitleLabel];
        
        // button
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(0, 0, frameWidth, frameHeight);
        [self addSubview:_button];
        
        // view
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 0.5f;
    }
    return self;
}

+ (WATitleGridButton *)buttonInitWithPoint:(CGPoint)pt
                                     title:(NSString *)title
                                  subtitle:(NSString *)subtitle
                                     index:(NSInteger)idx {
    WATitleGridButton *wButton = [[WATitleGridButton alloc] init];
    CGRect frame = wButton.frame;
    frame.origin = CGPointMake(pt.x, pt.y);
    wButton.frame = frame;
    wButton.titleLabel.text = title;
    wButton.subtitleLabel.text = subtitle;
    wButton.button.tag = idx;
    
    return wButton;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
