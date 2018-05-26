//
//  RichItem.h
//  KingOfUnzip
//
//  Created by dizhihao on 15/9/1.
//  Copyright (c) 2015年 dizhihao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RichFile.h"
#import "RichFolder.h"

@interface RichItem : NSObject

@property (nonatomic, assign)   BOOL  isSuperior;       // 上级目录
@property (nonatomic, assign)   BOOL  isFolder;         // 判断是否是文件夹
@property (nonatomic, assign)   BOOL  isSelected;       // 判断是否被选中
@property (nonatomic, strong)   UIImage    *iconImage;  // 图标
@property (nonatomic, strong)   NSString   *desc;       // 描述
@property (nonatomic, strong)   RichFile   *file;
@property (nonatomic, strong)   RichFolder *folder;

// 创建上级菜单
+ (RichItem *)itemWithSuperiorFolderPath:(NSString *)fdPath;

// 创建文件对象
+ (RichItem *)itemWithFile:(RichFile *)file;

// 创建文件夹对象
+ (RichItem *)itemWithFolder:(RichFolder *)folder;

@end
