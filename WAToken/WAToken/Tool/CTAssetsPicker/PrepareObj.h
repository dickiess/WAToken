//
//  PrepareObj.h
//  KingOfUnzip
//
//  Created by dizhihao on 15/9/8.
//  Copyright (c) 2015年 dizhihao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "RichFile.h"

@interface PrepareObj : NSObject

@property (nonatomic, copy  ) NSString *name;
@property (nonatomic, copy  ) NSString *cachePath;
@property (nonatomic, strong) NSURL *assetURL;
@property (nonatomic, strong) AVAssetExportSession *exporter;

// 创建对象
+ (PrepareObj *)objCreateByALAsset:(ALAsset *)asset;

// 创建对象(基于Richfile)
+ (PrepareObj *)objCreateByAssetURL:(NSURL *)url andNonExistentFile:(RichFile *)file;

// 是否图片
- (BOOL)isPicture;

// 是否视频
- (BOOL)isVideo;

@end
