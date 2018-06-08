//
//  CALayer + PulldownAnimation.m
//  WAToken
//
//  Created by dizhihao on 2018/6/7.
//  Copyright © 2018 dizhihao. All rights reserved.
//

#import "CALayer+PulldownAnimation.h"

@implementation CALayer (PulldownAnimation)

#pragma mark - layer drawing

/**
  文字Layer

 @param string 文本
 @param color  颜色
 @param fSize  字体大小
 @param pt     位置
 @return 文字Layer
 */
+ (CATextLayer *)createTextWithString:(NSString *)string
                                color:(UIColor *)color
                             fontsize:(CGFloat)fSize
                             position:(CGPoint)pt {
    CGSize size = [self boundsBySize:CGSizeMake(300, 0) text:string fontSize:fSize];
    
    NSInteger num = 3;  // 不知道想干啥，暂定是3吧
    CATextLayer *layer = [CATextLayer new];
    CGFloat sizeWidth = (size.width < frameWidth/num - 25) ? size.width : (frameWidth/num - 25);
    layer.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    layer.string = string;
    layer.fontSize = fSize;
    layer.alignmentMode = kCAAlignmentCenter;
    layer.foregroundColor = color.CGColor;
    layer.contentsScale = [[UIScreen mainScreen] scale];
    layer.position = pt;
    return layer;
}


/**
 指示Layer
 
 @param  color 颜色
 @param  pt 位置
 @return 指示Layer
 */
+ (CAShapeLayer *)createIndicatorWithColor:(UIColor *)color position:(CGPoint)pt {
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(8, 0)];
    [path addLineToPoint:CGPointMake(4, 5)];
    [path closePath];
    
    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
    layer.fillColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil,
                                                     layer.lineWidth, kCGLineCapButt,
                                                     kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    layer.position = pt;
    return layer;
}


/**
 分隔线Layer
 
 @param  color 颜色
 @param  pt 位置
 @return 分隔线Layer
 */
+ (CAShapeLayer *)createSeparatorLineWithColor:(UIColor *)color position:(CGPoint)pt {
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(160,0)];
    [path addLineToPoint:CGPointMake(160, 20)];
    
    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
    layer.strokeColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil,
                                                     layer.lineWidth, kCGLineCapButt,
                                                     kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    layer.position = pt;
    return layer;
}


/**
 大小尺寸
 
 @param aSize 原大小尺寸
 @param text  文本
 @param fSize 文字大小
 @return 大小尺寸
 */
+ (CGSize)boundsBySize:(CGSize)aSize text:(NSString *)text fontSize:(CGFloat)fSize {
    NSDictionary *attr = @{NSFontAttributeName: [UIFont systemFontOfSize:fSize]};
    NSStringDrawingOptions op = (NSStringDrawingUsesFontLeading |
                                 NSStringDrawingUsesLineFragmentOrigin |
                                 NSStringDrawingTruncatesLastVisibleLine);
    return [text boundingRectWithSize:aSize options:op attributes:attr context:nil].size;
}


/**
 添加动画
 
 @param animation 动画
 @param value   值
 @param keyPath 键
 */
- (void)animation:(CAAnimation *)animation value:(NSValue *)value forKeyPath:(NSString *)keyPath {
    [self addAnimation:animation forKey:keyPath];
    [self setValue:value forKeyPath:keyPath];
}

@end
