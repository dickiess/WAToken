//
//  WATabBar.m
//  WAToken
//
//  Created by dizhihao on 2018/5/28.
//  Copyright © 2018 dizhihao. All rights reserved.
//

#import "WATabBar.h"

// 屏幕尺寸
#define FULL_FRAME   [[UIScreen mainScreen] bounds]
#define FULL_SCREEN  FULL_FRAME.size

@implementation WATabBar

- (instancetype)init{
    self = [super init];
    if (self){
        [self initView];
    }
    
    return self;
}

- (void)initView{
    _centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // 设定button大小为适应图片
    UIImage *normalImage = [UIImage imageNamed:@"tab_ico_add_up"];
    CGFloat imageW = normalImage.size.width;
    CGFloat imageH = normalImage.size.height;
    _centerBtn.frame = CGRectMake(0, 0, imageW, imageH);
    [_centerBtn setImage:normalImage forState:UIControlStateNormal];
    
    // 去除选择时高亮
    _centerBtn.adjustsImageWhenHighlighted = NO;
    
    // 根据图片调整button的位置(图片中心在tabbar的中间最上部，这个时候由于按钮是有一部分超出tabbar的，所以点击无效，要进行处理)
    _centerBtn.frame = CGRectMake((FULL_SCREEN.width - imageW) / 2, - imageH / 2, imageW, imageH);
    [self addSubview:_centerBtn];
}

// 处理超出区域点击无效的问题
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.hidden) {
        return [super hitTest:point withEvent:event];
    } else {
        // 转换坐标
        CGPoint tempPoint = [self.centerBtn convertPoint:point fromView:self];
        // 判断点击的点是否在按钮区域内
        if (CGRectContainsPoint(self.centerBtn.bounds, tempPoint)) {
            // 返回按钮
            return _centerBtn;
        } else {
            return [super hitTest:point withEvent:event];
        }
    }
}

@end
