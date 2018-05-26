//
//  RichKeyChain.h
//  DSEM
//
//  Created by dizhihao on 2018/2/1.
//  Copyright © 2018年 dizhihao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

@interface RichKeyChain : NSObject

// 存储字符串到 KeyChain
+ (void)keyChainSaveKey:(NSString *)sKey value:(NSString *)sValue;

// 从 KeyChain 中读取存储的字符串
+ (NSString *)keyChainReadKey:(NSString *)sKey;

// 删除 KeyChain 信息
+ (void)keyChainDeleteKeyValueByKey:(NSString *)sKey;

@end
