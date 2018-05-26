//
//  RichFolder.h
//  KingOfUnzip
//
//  Created by dizhihao on 15/9/1.
//  Copyright (c) 2015年 dizhihao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RichFolder : NSObject

@property (nonatomic, copy)   NSString  *name;          // 文件夹名
@property (nonatomic, copy)   NSString  *localPath;     // 文件夹路径
@property (nonatomic, strong) UIImage   *thumbImage;    // 缩略图
@property (nonatomic, strong) UIImage   *iconImage;     // 图标
@property (nonatomic, strong) NSString  *desc;          // 描述

// 创建文件夹
+ (RichFolder *)folderWithName:(NSString *)name
                  andLocalPath:(NSString *)localPath;

// 文件夹包含项统计
- (NSInteger)folderItemsCount;

// 获得文件夹路径(无该文件夹)
- (NSString *)getFolderPath;



@end
