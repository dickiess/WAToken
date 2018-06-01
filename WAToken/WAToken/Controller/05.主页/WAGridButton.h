//
//  WAGridButton.h
//  WAToken
//
//  Created by dizhihao on 2018/5/31.
//  Copyright © 2018 dizhihao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WAGridButton : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UIButton    *button;

+ (WAGridButton *)buttonInitWithPoint:(CGPoint)pt
                                image:(UIImage *)image
                                title:(NSString *)title
                                index:(NSInteger)idx;

@end
