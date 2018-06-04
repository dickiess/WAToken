//
//  WAGridButton.m
//  WAToken
//
//  Created by dizhihao on 2018/5/31.
//  Copyright © 2018 dizhihao. All rights reserved.
//

#import "WAGridButton.h"

#import "MyDevice.h"

#define frameWidth   ([[UIScreen mainScreen] bounds].size.width/3)
                                                  // 框架尺寸参考宽度屏幕3分之一
#define frameHeight  (frameWidth)                 // 框架尺寸参考高度与宽度一致
#define imageWidth   (frameWidth *30/125)         // 图片尺寸参考宽度35
#define imageHeight  (frameHeight*30/125)         // 图片尺寸参考高度35
#define image_x      ((frameWidth-imageWidth)/2)  // 图片X位置参考位置居中
#define image_y      (frameHeight*32/125)         // 图片Y位置参考位置32
#define titleWidth   (frameWidth*125/125)         // 文字尺寸参考宽度125
#define titleHeight  (frameHeight*28/125)         // 文字尺寸参考高度28
#define title_x      (frameWidth * 0/125)         // 文字X位置参考位置0
#define title_y      (frameHeight*80/125)         // 文字Y位置参考位置80


@implementation WAGridButton

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, frameWidth, frameHeight)];
    if (self) {
        // icon
        CGRect imageRect = CGRectMake(image_x, image_y, imageWidth, imageHeight);
        _imageView = [[UIImageView alloc] initWithFrame:imageRect];
        [self addSubview:_imageView];
        
        // label
        CGRect labelRect = CGRectMake(title_x, title_y, titleWidth, titleHeight);
        _titleLabel = [[UILabel alloc] initWithFrame:labelRect];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:(DEVICE_IPAD ? 18.0f : 14.0f)];
        _titleLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:_titleLabel];
        
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

+ (WAGridButton *)buttonInitWithPoint:(CGPoint)pt
                                image:(UIImage *)image
                                title:(NSString *)title
                                index:(NSInteger)idx {
    WAGridButton *wButton = [[WAGridButton alloc] init];
    CGRect frame = wButton.frame;
    frame.origin = CGPointMake(pt.x, pt.y);
    wButton.frame = frame;
    wButton.imageView.image = image;
    wButton.titleLabel.text = title;
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
