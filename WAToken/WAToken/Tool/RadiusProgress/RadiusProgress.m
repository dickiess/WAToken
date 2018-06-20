//
//  RadiusProgress.m
//  KingOfUnrar
//
//  Created by dizhihao on 2017/8/10.
//  Copyright © 2017年 dizhihao. All rights reserved.
//

#import "RadiusProgress.h"
#import <QuartzCore/QuartzCore.h>

#import "UIColor+Art.h"

@interface RadiusProgress()

@property (nonatomic, strong) UIColor *themeColor;


@end

/*************************************************************************************************************/

@implementation RadiusProgress

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _number = 0.0f;                         // 比率
        _radius = frame.size.width / 2 - 5;     // 半径
        _themeColor = HexRGB(0x4682B4);         // 主题色
        _percentLabel = [self labelWithFrame:frame font:[UIFont systemFontOfSize:14.0f]];
        if (_percentLabel) {
            [self addSubview:_percentLabel];
        }
    }
    return self;
}

- (UILabel *)labelWithFrame:(CGRect)frame font:(UIFont *)font {
    CGRect rect = frame;
    rect.origin.x = 0.0f;
    rect.origin.y = 0.0f;
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = font;
    label.textColor = _themeColor;
    return label;
}

+ (RadiusProgress *)radiusProgressWithFrame:(CGRect)frame {
    CGRect rect = frame;
//    rect.size.width = rect.size.width < 140 ? 140 : rect.size.width;
//    rect.size.width = rect.size.width > 400 ? 400 : rect.size.width;
    rect.size.height = rect.size.width;
    RadiusProgress *rProgress = [[RadiusProgress alloc] initWithFrame:rect];
    rProgress.backgroundColor = [UIColor clearColor];
    
    return rProgress;
}

- (void)radiusProgressSetValue:(CGFloat)value {
    CGFloat num = value > 0.0f ? value : 0.0f;
    _number = num <= 1.0f ? num : 1.0f;
    [self setNeedsDisplay];
    _percentLabel.text = [NSString stringWithFormat:@"%d%%", (int)(_number * 100)];
    _percentLabel.textColor = _themeColor;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self redraw];
}

// 重绘
- (void)redraw {
    
    CGFloat mWidth = self.frame.size.width;
    
    // 获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 设定线条宽度
    CGContextSetLineWidth(context, 3);
    // 设定线条样式
    CGContextSetLineCap(context, kCGLineCapButt);
    // 设定虚线
    CGFloat length[] = {4,0};
    /**
     参数1
     参数2 跳过的点数
     参数3 虚线
     参数4 数组的长度
     */
    CGContextSetLineDash(context, 0, length, 2);
    // 设置颜色
    [_themeColor set];
    // 设置路径
    CGFloat start = 0;
    CGFloat end = start + (2 * M_PI * _number);
    // 绘制圆
    /**
     参数1
     参数2 圆心x
     参数3 圆心y
     参数4 半径
     参数5 起点
     参数6 绘制大小
     参数7 0为逆时针 1为顺时针
     */
    CGContextAddArc(context, mWidth / 2, mWidth / 2, _radius, start, end, 0);
    // 绘制图形
    CGContextStrokePath(context);
}

// 颜色设定
- (void)setThemeColor:(UIColor *)color {
    if (_themeColor) {
        _themeColor = color;
        _percentLabel.textColor = color;
    }
}

@end
