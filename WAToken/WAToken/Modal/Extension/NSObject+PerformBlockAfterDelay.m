//
//  NSObject+PerformBlockAfterDelay.m
//  LawManagerLawyer
//
//  Created by dizhihao on 16/4/6.
//  Copyright © 2016年 Dizhihao. All rights reserved.
//

#import "NSObject+PerformBlockAfterDelay.h"

@implementation NSObject (PerformBlockAfterDelay)

// 延时执行
+ (void)performAfterDelay:(NSTimeInterval)delay withBlock:(void (^)(void))block {
    block = [block copy];
    [self performSelector:@selector(fireBlockAfterDelay:) withObject:block afterDelay:delay];
}

- (void)fireBlockAfterDelay:(void (^)(void))block {
    block();
}


@end
