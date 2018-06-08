//
//  WAPullDownMenu.h
//  WAToken
//
//  Created by dizhihao on 2018/6/6.
//  Copyright © 2018 dizhihao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WAPullDownMenu;

@protocol WAPullDownMenuDelegate <NSObject>

- (void)pullDownMenu:(WAPullDownMenu *)pMenu didSelectColumn:(NSInteger)column row:(NSInteger)row;

@end

/************************************************************************************************/

@interface WAPullDownMenu : UIView

@property (nonatomic, strong) id<WAPullDownMenuDelegate> pDelegate;

+ (WAPullDownMenu *)menuWithList:(NSArray *)list position:(CGPoint)pt selectedColor:(UIColor *)color;

- (void)reset;

@end
