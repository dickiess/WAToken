//
//  RichFile.m
//  KingOfUnzip
//
//  Created by dizhihao on 15/8/24.
//  Copyright (c) 2015年 dizhihao. All rights reserved.
//

#import "RichFile.h"
#import "NSString+Trimming.h"

@implementation RichFile

- (id)init {
    self = [super init];
    if (self) {
        _name = nil;
        _localPath = nil;
        _thumbImage = nil;
    }
    
    return self;
}

// 创建文件
+ (RichFile *)fileWithName:(NSString *)name andLocalPath:(NSString *)localPath {
    RichFile *file = [[RichFile alloc] init];
    file.name = name;
    file.localPath = localPath;
    [file updateIcon];
    
    return file;
}

// 获得文件后缀名
- (NSString *)getFileSuffix {
    return [_name pathExtension];
}

// 获得文件名(无后缀)
- (NSString *)getFileFirstName {
    return [_name stringByDeletingPathExtension];
}

// 获得文件路径(无文件名)
- (NSString *)getFilePath {
    return [_localPath stringByDeletingLastPathComponent];
}

// 获取文件大小
- (NSString *)getFileSize {
    if (!_localPath || [_localPath isEqualToString:@""]) {
        return @"";
    }

    NSFileManager *fm = [NSFileManager defaultManager];
    CGFloat sizeKB = 1024.0f;
    CGFloat sizeFile = [[fm attributesOfItemAtPath:_localPath error:nil] fileSize] / sizeKB;
        
    if (sizeFile > 1024.0f) {
        return [NSString stringWithFormat:@"%.2f MB", (sizeFile / sizeKB)];
    } else {
        return [NSString stringWithFormat:@"%.2f KB", sizeFile];
    }
}

// 获取文件创建时间
- (NSString *)getFileCreateTime {
    
    NSError *error = nil;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDictionary *attribute = [fm attributesOfItemAtPath:_localPath error:&error];
    
    if (error) {
        
        //NSLog(@"getFileCreateTime ERROR: %@", _name);
        //NSLog(@"getFileCreateTime ERROR: %@", error);
        return @"";
    }
    
    // 1.时区调整
//    NSDate *cDate = [attr objectForKey:NSFileCreationDate];
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate:cDate];
//    NSDate *date = [cDate dateByAddingTimeInterval:interval];
    
    // 2.无时区调整
    NSDate *date = [attribute objectForKey:NSFileCreationDate];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy/MM/dd HH:mm"];

    return [df stringFromDate:date];
}

// 获取文件属性
- (NSDictionary *)getFileAttributes {
    NSError *error = nil;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDictionary *attributes = [fm attributesOfItemAtPath:_localPath error:&error];
    if (error) {
        // handle error found in 'error'
        NSLog(@"getFileAttributes ERROR: %@", error);
        return nil;
    }
    
    // make use of attributes
    //NSLog(@"%@", attributes);
    return attributes;
}

// 是否ZIP文件
- (BOOL)isZipFile {
    return
    [[self getFileSuffix] isEqualToString:@"zip"] ||
    [[self getFileSuffix] isEqualToString:@"ZIP"];
}

// 是否RAR文件
- (BOOL)isRarFile {
    return
    [[self getFileSuffix] isEqualToString:@"rar"] ||
    [[self getFileSuffix] isEqualToString:@"RAR"];
}

// 是否7z文件
- (BOOL)isSevenZipFile {
    return
    [[self getFileSuffix] isEqualToString:@"7z"] ||
    [[self getFileSuffix] isEqualToString:@"7Z"];
}

// 更新图标
- (void)updateIcon {
    
    NSString *imageName = @"ico_other";
    
    NSString *suffix = [self getFileSuffix];
    NSArray *wordArray  = @[@"doc", @"DOC", @"docx", @"DOCX"];
    NSArray *excelArray = @[@"xls", @"XLS", @"xlsx", @"XLSX"];
    NSArray *ppointArray  = @[@"ppt", @"PPT", @"pptx", @"PPTX"];
    
    NSArray *bmpArray = @[@"bmp", @"BMP"];
    NSArray *gifArray = @[@"gif", @"GIF"];
    NSArray *jpgArray = @[@"jpg", @"JPG", @"jpeg", @"JPEG"];
    NSArray *pngArray = @[@"png", @"PNG"];
    
    NSArray *pdfArray = @[@"pdf", @"PDF"];
    NSArray *txtArray = @[@"txt", @"TXT"];
    
    NSArray *mp3Array = @[@"mp3", @"MP3"];
    NSArray *m4aArray = @[@"m4a", @"M4a", @"M4A"];
    NSArray *mp4Array = @[@"mp4", @"MP4"];
    NSArray *movArray = @[@"mov", @"MOV"];
    
    if ([NSString equalString:suffix amongStrings:wordArray]) {
        imageName = @"ico_doc";
    } else if ([NSString equalString:suffix amongStrings:excelArray]) {
        imageName = @"ico_xls";
    } else if ([NSString equalString:suffix amongStrings:ppointArray]) {
        imageName = @"ico_ppt";
    } else if ([NSString equalString:suffix amongStrings:bmpArray]) {
        imageName = @"ico_bmp";
    } else if ([NSString equalString:suffix amongStrings:gifArray]) {
        imageName = @"ico_gif";
    } else if ([NSString equalString:suffix amongStrings:jpgArray]) {
        imageName = @"ico_jpg";
    } else if ([NSString equalString:suffix amongStrings:pngArray]) {
        imageName = @"ico_png";
    } else if ([NSString equalString:suffix amongStrings:pdfArray]) {
        imageName = @"ico_pdf";
    } else if ([NSString equalString:suffix amongStrings:txtArray]) {
        imageName = @"ico_txt";
    } else if ([NSString equalString:suffix amongStrings:mp3Array]) {
        imageName = @"ico_mp3";
    } else if ([NSString equalString:suffix amongStrings:m4aArray]) {
        imageName = @"ico_m4a";
    } else if ([NSString equalString:suffix amongStrings:mp4Array]) {
        imageName = @"ico_mp4";
    } else if ([NSString equalString:suffix amongStrings:movArray]) {
        imageName = @"ico_mov";
    } else if ([self isZipFile]) {
        imageName = @"ico_zip";
    } else if ([self isRarFile]) {
        imageName = @"ico_rar";
    } else if ([self isSevenZipFile]) {
        imageName = @"ico_7z";
    }
    
    _iconImage = [UIImage imageNamed:imageName];
}


































@end
