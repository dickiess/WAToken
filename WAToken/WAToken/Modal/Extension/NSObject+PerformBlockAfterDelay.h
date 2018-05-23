//
//  NSObject+PerformBlockAfterDelay.h
//  LawManagerLawyer
//
//  Created by dizhihao on 16/4/6.
//  Copyright © 2016年 Dizhihao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (PerformBlockAfterDelay)

// 延时执行
+ (void)performAfterDelay:(NSTimeInterval)delay withBlock:(void (^)(void))block;

@end
