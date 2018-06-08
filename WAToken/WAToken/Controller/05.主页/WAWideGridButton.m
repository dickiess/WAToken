//
//  WAWideGridButton.m
//  WAToken
//
//  Created by dizhihao on 2018/6/1.
//  Copyright © 2018 dizhihao. All rights reserved.
//

#import "WAWideGridButton.h"
#import "RichProgressButton.h"

#import "MyDevice.h"
#import "UIColor+Art.h"
#import "WAAppInfo.h"

#define frameWidth      ([[UIScreen mainScreen] bounds].size.width)
#define frameHeight     (frameWidth/3)
// 框架尺寸参考高度屏幕3分之一
#define mainTitleWidth  (frameWidth*(125-8*2)/125)   // 主题文字尺寸参考宽度109
#define mainTitleHeight (frameHeight*30/125)         // 主题文字尺寸参考高度30
#define mainTitle_x     (frameWidth * 8/125)         // 主题文字X位置参考位置8
#define mainTitle_y     (frameHeight*22/125)         // 主题文字Y位置参考位置22
#define subTitleWidth   (frameWidth*(125-8*2)/125)   // 辅助文字尺寸参考宽度109
#define subTitleHeight  (frameHeight*22/125)         // 辅助文字尺寸参考高度22
#define subTitle_x      (frameWidth * 8/125)         // 辅助文字X位置参考位置8
#define subTitle_y      (frameHeight*50/125)         // 辅助文字Y位置参考位置50
#define processWidth    (frameWidth*(125-8*2)/125)   // 辅助文字尺寸参考宽度109
#define processHeight   (frameHeight*28/125)         // 辅助文字尺寸参考高度28
#define process_x       (frameWidth * 8/125)         // 辅助文字X位置参考位置8
#define process_y       (frameHeight*80/125)         // 辅助文字Y位置参考位置80


@interface WAWideGridButton ()

@property (nonatomic, strong) RichProgressButton *progress;

@end

@implementation WAWideGridButton

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, frameWidth, frameHeight)];
    if (self) {
        // main title label
        CGRect mainTitleRect = CGRectMake(mainTitle_x, mainTitle_y, mainTitleWidth, mainTitleHeight);
        _titleLabel = [[UILabel alloc] initWithFrame:mainTitleRect];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont boldSystemFontOfSize:(DEVICE_IPAD ? 22.0f : 16.0f)];
        _titleLabel.textColor = [UIColor blackColor];
        [self addSubview:_titleLabel];
        
        // subtitle label
        CGRect subTitleRect = CGRectMake(subTitle_x, subTitle_y, subTitleWidth, subTitleHeight);
        _subtitleLabel = [[UILabel alloc] initWithFrame:subTitleRect];
        _subtitleLabel.textAlignment = NSTextAlignmentLeft;
        _subtitleLabel.font = [UIFont systemFontOfSize:(DEVICE_IPAD ? 16.0f : 12.0f)];
        _subtitleLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:_subtitleLabel];
        
        // process
        CGRect processRect = CGRectMake(process_x, process_y, processWidth, processHeight);
        _progress = [RichProgressButton btnWithFrame:processRect
                                               title:@""
                                     backgroundColor:HexRGB(THEME_LIGHTGRAY)
                                           fillColor:HexRGB(THEME_GREEN)
                                         borderWidth:0.5f
                                        cornerRadius:5.0f];
        [self addSubview:_progress];
        
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

+ (WAWideGridButton *)buttonInitWithPoint:(CGPoint)pt
                                    title:(NSString *)title
                                 subtitle:(NSString *)subtitle
                                  process:(CGFloat)process
                                    index:(NSInteger)idx {
    WAWideGridButton *wButton = [[WAWideGridButton alloc] init];
    CGRect frame = wButton.frame;
    frame.origin = CGPointMake(pt.x, pt.y);
    wButton.frame = frame;
    wButton.titleLabel.text = title;
    wButton.subtitleLabel.text = subtitle;
    wButton.process = process;
    wButton.button.tag = idx;
    
    return wButton;
}

- (void)updateProcess:(CGFloat)process {
    _process = process;
    
    [self layoutSubviews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _progress.progress = _process;
    
    _progress.textLabel.textColor = [UIColor whiteColor];
    if (self.process >= 0.95f) {
        _progress.backgroundColor = HexRGB(THEME_LIGHTGRAY);
        _progress.fillColor = HexRGB(THEME_RED);
    }
    else if (self.process >= 0.90f) {
        _progress.backgroundColor = HexRGB(THEME_LIGHTGRAY);
        _progress.fillColor = HexRGB(THEME_ORANGE);
    }
    else if (self.process >= 0.85f) {
        _progress.backgroundColor = HexRGB(THEME_LIGHTGRAY);
        _progress.fillColor = HexRGB(THEME_YELLOW);
        _progress.textLabel.textColor = HexRGB(THEME_ORANGE);
    }
    else if (self.process >= 0.65f) {
        _progress.backgroundColor = HexRGB(THEME_LIGHTGRAY);
        _progress.fillColor = HexRGB(THEME_GREEN);
    }
    else {
        _progress.backgroundColor = HexRGB(THEME_GRAY);
        _progress.fillColor = HexRGB(THEME_GREEN);
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
