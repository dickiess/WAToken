//
//  PrepareObj.m
//  KingOfUnzip
//
//  Created by dizhihao on 15/9/8.
//  Copyright (c) 2015年 dizhihao. All rights reserved.
//

#import "PrepareObj.h"
#import "RichFileApi.h"

@implementation PrepareObj

- (id)init {

    self = [super init];
    if (self) {
        
    }
    
    return self;
}

// 创建对象
+ (PrepareObj *)objCreateByALAsset:(ALAsset *)asset {
 
    PrepareObj *pObj = [[PrepareObj alloc] init];
    
    // 1.name
    NSString *assetName = asset.defaultRepresentation.filename;
    pObj.name = assetName;
    NSLog(@"asset name: %@", assetName);
    
    
    if ([pObj isVideo]) {
        assetName = [assetName stringByDeletingPathExtension];
        assetName = [assetName stringByAppendingPathExtension:@"mp4"];
        pObj.name = assetName;
    }
    
    // 2.exporter
    NSURL *assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
    pObj.assetURL = assetURL;
    AVURLAsset *urlAsset = [[AVURLAsset alloc] initWithURL:assetURL options:nil];
    AVAssetExportSession *exporter
    = [[AVAssetExportSession alloc] initWithAsset:urlAsset presetName:AVAssetExportPresetHighestQuality];
    exporter.outputFileType = AVFileTypeMPEG4;
    pObj.exporter = exporter;
    
    // 3.cache path
    NSString *documentsDirectoryPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    NSString *scrPath = [documentsDirectoryPath stringByAppendingPathComponent:pObj.name];
    pObj.exporter.outputURL = [NSURL fileURLWithPath:scrPath];
    pObj.cachePath = scrPath;
    
    return pObj;
}

// 创建对象
+ (PrepareObj *)objCreateByAssetURL:(NSURL *)url andNonExistentFile:(RichFile *)file {

    // 1.name
    PrepareObj *pObj = [[PrepareObj alloc] init];
    pObj.name = file.name;
    
    // 2.exporter
    pObj.assetURL = url;
    AVURLAsset *urlAsset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetExportSession *exporter
    = [[AVAssetExportSession alloc] initWithAsset:urlAsset presetName:AVAssetExportPresetHighestQuality];
    exporter.outputFileType = AVFileTypeMPEG4;
    pObj.exporter = exporter;
    
    // 3.exporter path
    // 如果没有设置,则默认写入cache,如需指定输出,必须对参数重新赋值
    pObj.exporter.outputURL = [NSURL fileURLWithPath:file.localPath];
    pObj.cachePath = file.localPath;
    
    return pObj;
}

// 是否图片
- (BOOL)isPicture {
    
    NSArray *list = @[@"jpg", @"JPG", @"jpeg", @"JPEG", @"png", @"PNG"];
    RichFile *file = [RichFile fileWithName:_name andLocalPath:_cachePath];
    BOOL cOk = [RichFileApi fileSuffixEqualList:list byFile:file];
    if (cOk) {
        return YES;
    }
    return NO;
}

// 是否视频
- (BOOL)isVideo {

    NSArray *list = @[@"mov", @"MOV", @"mp4", @"MP4"];
    RichFile *file = [RichFile fileWithName:_name andLocalPath:_cachePath];
    BOOL cOk = [RichFileApi fileSuffixEqualList:list byFile:file];
    if (cOk) {
        return YES;
    }
    return NO;
}

@end
