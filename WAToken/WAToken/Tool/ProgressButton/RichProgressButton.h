//
//  RichProgressButton.h
//  KingOfUnrar
//
//  Created by dizhihao on 23/03/2018.
//  Copyright © 2018 dizhihao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RichProgressButton : UIView

@property (nonatomic, strong, readonly) UILabel *textLabel;
@property (nonatomic, strong)           UIColor  *fillColor;
@property (nonatomic, assign)           CGFloat  progress;

// 初始化
+ (RichProgressButton *)btnWithFrame:(CGRect)frame
                               title:(NSString *)title
                     backgroundColor:(UIColor *)bColor
                           fillColor:(UIColor *)fColor
                         borderWidth:(CGFloat)bWidth
                        cornerRadius:(CGFloat)cRadius;

/*
 成员方法的好处：
 1.实现了事务与对象的分离，使定义与实现脱离耦合
 2.避免使用协议，避免功能实现过程中的代码过于分散
 
 实现方法：
 输入控制器和触发事件方法名，并在控制器中调用该方法
 */

// 添加点击事件
- (void)clickWithTarget:(id)target event:(SEL)aSel;

@end
