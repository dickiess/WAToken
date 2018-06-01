//
//  WATitleGridButton.h
//  WAToken
//
//  Created by dizhihao on 2018/6/1.
//  Copyright © 2018 dizhihao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WATitleGridButton : UIView

@property (nonatomic, strong) UILabel  *titleLabel;
@property (nonatomic, strong) UILabel  *subtitleLabel;
@property (nonatomic, strong) UIButton *button;

+ (WATitleGridButton *)buttonInitWithPoint:(CGPoint)pt
                                     title:(NSString *)title
                                  subtitle:(NSString *)subtitle
                                     index:(NSInteger)idx;

@end
