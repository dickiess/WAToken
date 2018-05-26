//
//  RichItem.m
//  KingOfUnzip
//
//  Created by dizhihao on 15/9/1.
//  Copyright (c) 2015年 dizhihao. All rights reserved.
//

#import "RichItem.h"

@implementation RichItem

- (instancetype)init {
    self  = [super init];
    if (self) {
        _isSuperior = NO;
        _isFolder = NO;
        _isSelected = NO;
        _file = nil;
        _folder = nil;
    }
    return self;
}

// 创建上级菜单
+ (RichItem *)itemWithSuperiorFolderPath:(NSString *)fdPath {
    RichItem *item = [[RichItem alloc] init];
    item.isSuperior = YES;
    NSString *folderPath = [fdPath stringByDeletingLastPathComponent];
    NSString *folderName = [folderPath lastPathComponent];
    item.folder = [RichFolder folderWithName:folderName andLocalPath:folderPath];
    item.iconImage = [UIImage imageNamed:@"green_arrow"];
    return item;
}

// 创建文件对象
+ (RichItem *)itemWithFile:(RichFile *)file {
    RichItem *item = [[RichItem alloc] init];
    item.isFolder = NO;
    item.file = file;
    return item;
}

// 创建文件夹对象
+ (RichItem *)itemWithFolder:(RichFolder *)folder {
    RichItem *item = [[RichItem alloc] init];
    item.isFolder = YES;
    item.folder = folder;
    return item;
}

@end
