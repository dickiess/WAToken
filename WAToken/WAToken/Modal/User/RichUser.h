//
//  RichUser.h
//  KingOfUnzip
//
//  Created by dizhihao on 15/8/24.
//  Copyright (c) 2015年 dizhihao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RichUser : NSObject

@property (nonatomic, copy)   NSString *userID;         // 用户
//@property (nonatomic, copy)   NSString *userKey;        // 用户密钥
@property (nonatomic, copy)   NSString *folderPath;     // 文件夹

// 创建用户
+ (RichUser *)userWithUserID:(NSString *)userID;

@end
