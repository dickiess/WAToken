//
//  RichUser.m
//  KingOfUnzip
//
//  Created by dizhihao on 15/8/24.
//  Copyright (c) 2015年 dizhihao. All rights reserved.
//

#import "RichUser.h"

@implementation RichUser

- (id)init {
    self = [super init];
    if (self) {
        _userID = nil;
    }
    
    return self;
}

// 创建用户
+ (RichUser *)userWithUserID:(NSString *)userID andSecretCode:(NSString *)secrectCode {
    RichUser *user = [[RichUser alloc] init];
    user.userID = userID;
    NSString *folderPath = [NSString stringWithFormat:@"%@_", user.userID];
    
    // 1.document path
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *docUrls = [fm URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *docUrl = docUrls[0];
    NSString *docPath = [docUrl path];
    user.folderPath = [docPath stringByAppendingPathComponent:folderPath];
    
    NSMutableArray *folders = [NSMutableArray array];
    [folders addObject:user.folderPath];
    
    // 2.create folders
    BOOL isFolder = NO;
    for (int i = 0; i < folders.count ; i++) {
        if(![fm fileExistsAtPath:folders[i] isDirectory:&isFolder]){
            [fm createDirectoryAtPath:folders[i] withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    
    NSLog(@"\nFolder Path: {\n%@\n}\n", user.folderPath);
    return  user;
}

@end
