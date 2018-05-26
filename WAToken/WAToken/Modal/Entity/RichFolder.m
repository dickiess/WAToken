//
//  RichFolder.m
//  KingOfUnzip
//
//  Created by dizhihao on 15/9/1.
//  Copyright (c) 2015年 dizhihao. All rights reserved.
//

#import "RichFolder.h"

@implementation RichFolder

- (id)init {
    self = [super init];
    if (self) {
        _name = nil;
        _localPath = nil;
        _thumbImage = nil;
    }
    
    return self;
}

// 创建文件夹
+ (RichFolder *)folderWithName:(NSString *)name andLocalPath:(NSString *)localPath {
    RichFolder *folder = [[RichFolder alloc] init];
    folder.name = name;
    folder.localPath = localPath;
    folder.iconImage = [UIImage imageNamed:@"ico_folder"];
    
    return folder;
}

// 获得文件夹路径(无该文件夹)
- (NSString *)getFolderPath {
    return [_localPath stringByDeletingLastPathComponent];
}

// 文件夹包含项统计
- (NSInteger)folderItemsCount {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *allItems = [fm contentsOfDirectoryAtPath:_localPath error:nil];
    
    NSInteger foldersCount = 0;
    NSInteger filesCount = 0;
    BOOL isFolder = NO;
    for (NSString *theName in allItems) {
        
        NSString *thePath = [_localPath stringByAppendingPathComponent:theName];
        if ([fm fileExistsAtPath:thePath isDirectory:&isFolder]) {
            
            if ([theName isEqualToString:@".DS_Store"]) {
                continue;
            } else if (isFolder) {
                foldersCount ++;
            } else {
                filesCount ++;
            }
        }
    }
    //NSLog(@" %d files, %d folders in folder.", (int)filesCount, (int)foldersCount);
    
    return filesCount + foldersCount;
}

@end
