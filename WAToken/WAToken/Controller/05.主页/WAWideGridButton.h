//
//  WAWideGridButton.h
//  WAToken
//
//  Created by dizhihao on 2018/6/1.
//  Copyright © 2018 dizhihao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WAWideGridButton : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, assign) CGFloat process;
@property (nonatomic, strong) UIButton *button;

+ (WAWideGridButton *)buttonInitWithPoint:(CGPoint)pt
                                    title:(NSString *)title
                                 subtitle:(NSString *)subtitle
                                  process:(CGFloat)process
                                    index:(NSInteger)idx;

- (void)updateProcess:(CGFloat)process;

@end
