//
//  RichFile.h
//  KingOfUnzip
//
//  Created by dizhihao on 15/8/24.
//  Copyright (c) 2015年 dizhihao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    SORT_LATEST = 1,          // 时间最新
    SORT_EARLIEST,            // 时间最早
    SORT_NAME_UP,             // 文件名升序
    SORT_NAME_DN,             // 文件名降序
    SORT_SUFFIX_UP,           // 后缀名升序
    SORT_SUFFIX_DN,           // 后缀名降序
} APR_SORT;

typedef enum {
    FILTER_ALL = 0,           // 不过滤
    
    FILTER_DOC = 10,          // 所有文档
    FILTER_WORD,              // word文档
    FILTER_EXCEL,             // excel文档
    FILTER_PPOINT,            // ppt文档
    FILTER_PDF,               // pdf文档
    FILTER_TXT,               // txt文档
    
    FILTER_COMPRESSION = 20,  // 所有压缩文件
    FILTER_ZIP,               // 所有Zip文件
    FILTER_RAR,               // 所有RAR文件
    FILTER_7Z,                // 所有7z文件
    
    FILTER_PICTURE = 30,      // 所有图片
    FILTER_JPG,               // jpg图片
    FILTER_PNG,               // png图片
    FILTER_BMP,               // bmp图片
    FILTER_GIF,               // gif图片
    
    FILTER_MEDIA = 40,        // 所有媒体文件
    FILTER_AUDIO,             // 所有音频文件
    FILTER_VIDEO,             // 所有视频文件
    
    FILTER_OTHER = 99,        // 其他文档
    
} APR_FILTER;


@interface RichFile : NSObject

@property (nonatomic, copy)     NSString  *name;          // 文件名
@property (nonatomic, copy)     NSString  *localPath;     // 文件路径
@property (nonatomic, strong)   UIImage   *thumbImage;    // 缩略图
@property (nonatomic, strong)   UIImage   *iconImage;     // 图标
@property (nonatomic, strong)   NSString  *desc;          // 描述

// 创建文件
+ (RichFile *)fileWithName:(NSString *)name
              andLocalPath:(NSString *)localPath;

// 是否ZIP文件
- (BOOL)isZipFile;

// 是否RAR文件
- (BOOL)isRarFile;

// 是否7z文件
- (BOOL)isSevenZipFile;

// 获得文件后缀名
- (NSString *)getFileSuffix;

// 获得文件名(无后缀)
- (NSString *)getFileFirstName;

// 获得文件路径(无文件名)
- (NSString *)getFilePath;

// 获取文件大小
- (NSString *)getFileSize;

// 获取文件创建时间
- (NSString *)getFileCreateTime;

// 获取文件属性
- (NSDictionary *)getFileAttributes;



@end
