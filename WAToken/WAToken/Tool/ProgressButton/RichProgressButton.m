//
//  RichProgressButton.m
//  KingOfUnrar
//
//  Created by dizhihao on 23/03/2018.
//  Copyright © 2018 dizhihao. All rights reserved.
//

#import "RichProgressButton.h"

@interface RichProgressButton ()

@property (nonatomic, assign) CGFloat moveWidth;
@property (nonatomic, strong) UITapGestureRecognizer *tapGR;


@end

@implementation RichProgressButton

// 初始化
- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

// 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        CGRect rect = CGRectMake(2, 2, frame.size.width - 4, frame.size.height - 4);
        _textLabel = [[UILabel alloc] initWithFrame:rect];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont fontWithName:@"GillSans-SemiBold" size:27];
        [self addSubview:_textLabel];
    }
    return self;
}

// 初始化
+ (RichProgressButton *)btnWithFrame:(CGRect)frame
                               title:(NSString *)title
                     backgroundColor:(UIColor *)bColor
                           fillColor:(UIColor *)fColor
                         borderWidth:(CGFloat)bWidth
                        cornerRadius:(CGFloat)cRadius {
    RichProgressButton *btn = [[RichProgressButton alloc] initWithFrame:frame];
    btn.textLabel.text = title;
    btn.backgroundColor = bColor;
    btn.fillColor = fColor;
    btn.layer.cornerRadius = cRadius;
    btn.layer.masksToBounds = YES;
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    btn.layer.borderWidth = bWidth;
    return btn;
}

// 刷新视图
- (void)layoutSubviews {
    [super layoutSubviews];
    _textLabel.frame = self.bounds;
}

// 重绘
- (void)drawRect:(CGRect)rect {
    UIBezierPath *bezierPath
    = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, _moveWidth, self.frame.size.height)];
    [_fillColor set];
    [bezierPath fill];
}

// 进度
- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    _moveWidth = progress * self.frame.size.width;
    
    float decimals = progress * 100;
    if (decimals > 100.00) decimals = 100.00;
    _textLabel.text = [NSString stringWithFormat:@"%0.2f%%", decimals];
    
    [self setNeedsDisplay];
}

// 填充色彩
- (void)setFillColor:(UIColor *)fillColor {
    _fillColor = fillColor;
    [self setNeedsDisplay];
}

// 添加点击事件
- (void)clickWithTarget:(id)target event:(SEL)aSel {
    if (_tapGR == nil) {
        _tapGR = [[UITapGestureRecognizer alloc] initWithTarget:target action:aSel];
        [self addGestureRecognizer:_tapGR];
    }
}


@end
