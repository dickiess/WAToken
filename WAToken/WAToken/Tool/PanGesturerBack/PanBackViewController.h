//
//  PanBackViewController.h
//  KingOfUnrar
//
//  Created by dizhihao on 2017/4/21.
//  Copyright © 2017年 dizhihao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PanBackViewController : UIViewController

/**
 用了自定义的手势返回，则系统的手势返回屏蔽
 不用自定义的手势返回，则系统的手势返回启用
 */
@property (nonatomic, assign) BOOL enablePanGesture;            // 是否支持自定义拖动pop手势，默认yes,支持手势

@end
