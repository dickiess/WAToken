//
//  RichFileApi.h
//  KingOfUnzip
//
//  Created by dizhihao on 15/8/25.
//  Copyright (c) 2015年 dizhihao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "RichUser.h"
#import "RichItem.h"

#import "ZipArchive.h"

typedef enum {
    ORDINARY = 0,
    ZIP_FILE,
    RAR_FILE,
    SevenZ_FILE,
} FILE_TYPE;

typedef enum {
    UNCOMPRESS_ZIP = 1,
    UNCOMPRESS_RAR,
    UNCOMPRESS_LZMA,
    COMPRESS_ZIP = 11,
    COMPRESS_RAR,
    COMPRESS_LZMA,
} COMPRESS_TYPE;

#define FILE_API        [RichFileApi sharedInstance]
#define METHOD_DELAY    (0.6f)


// 弹窗输入口令，获取口令
typedef void (^Completed)(NSString *inputString);

typedef void (^Process)(NSInteger process);

// 完成回调
typedef void (^Success)(BOOL success, NSString *reason);


/**********************************************************************************************************************/

@class RichFileApi;

@protocol RichFileApiDelegate < NSObject >

@optional
- (void)fileManagerInfo:(NSMutableArray *)info;

// zip算法过程
- (void)zipingFileProcess:(NSInteger)process output:(NSString *)filename;
- (void)unzipingFileProcess:(NSInteger)process;

// rar算法过程
- (void)unraringFileProcess:(NSInteger)process;

// lzma算法过程
- (void)lzmaFileProcess:(NSInteger)process output:(NSString *)filename;
- (void)unlzmaFileProcess:(NSInteger)process;

// 压缩或解压缩过程百分比（协议方法）
- (void)processWhenCompressionOrUncompression:(NSInteger)process;

@end

/**********************************************************************************************************************/

@interface RichFileApi : NSObject

@property (nonatomic, strong)   RichFile   *file;                 // 默认处理文件
@property (nonatomic, strong)   RichFolder *folder;               // 默认处理文件

@property (nonatomic, copy)     NSString   *localPath;            // 默认路径
@property (nonatomic, strong)   NSMutableArray *selectedFolders;  // 选中的文件
@property (nonatomic, strong)   NSMutableArray *selectedFiles;    // 选中的文件
@property (nonatomic, retain)   id<RichFileApiDelegate> delegate; // 委托协议

// 单例
+ (RichFileApi *)sharedInstance;

// 文件类型获取
- (FILE_TYPE)flagOfFile;

// 扩展名匹配
+ (BOOL)fileSuffixEqualList:(NSArray *)list byFile:(RichFile *)file;

// 移动文件及文件夹
- (void)moveItems;

// 删除文件及文件夹
- (void)deleteItems;

// 复制一个(多个)文件
- (void)copySomeFiles;

// 移动一个(多个)文件
- (void)moveSomeFiles;

// 删除文件
- (void)deleteRichFile;

// 删除多个文件
- (void)deleteSomeFiles;

// 文件已经存在
+ (BOOL)fileExistAtLocalPath:(NSString *)lPath;

// 写入文件
+ (BOOL)creatFileWithData:(NSData *)data atLocalPath:(NSString *)lPath;

// 删除文件夹
- (void)deleteRichFolder;

/**********************************************************************************************************************/

// 压缩文件
- (void)compressWithAlgorithm:(COMPRESS_TYPE)algorithm
                        files:(NSArray <RichFile *> *)files
                         code:(NSString *)code
                      newFile:(RichFile *)nFile
                      success:(Success)success;

// 解压文件
- (void)extractWithFile:(RichFile *)file
                   code:(NSString *)code
                 toPath:(NSString *)path
                success:(Success)success;

/**********************************************************************************************************************/

// 文件名重名自动转换
- (NSString *)changeRichFileNameByFile:(RichFile *)file suffix:(NSString *)suff;

// 文件夹重名自动转换(是否创建)
- (NSString *)changeRichFolderName:(RichFolder *)folder create:(BOOL)create;

// 文件名重名de自动转换
+ (RichFile *)changeRichFileNameByFile:(RichFile *)file;

// 输入框
- (void)inputBoxWithTitle:(NSString *)title delegate:(UIViewController *)delegate
                  message:(NSString *)message placeholder:(NSString *)placeholder
                 text:(NSString *)text security:(BOOL)security rectForPad:(CGRect)rect
                      tag:(NSUInteger)tag completed:(Completed)completed;

// 重命名输入 A011
- (void)inputFileName;

// 密码输入框 B011
- (void)inputSecretCodeBox;

// 输入新建文件夹名 C011
- (void)inputFolderName;

// 判断是否同一个文件
- (BOOL)isEqualFile:(RichFile *)firstFile secondFile:(RichFile *)secondFile;

/**********************************************************************************************************************/

// 命名日期获取
+ (NSString *)dateStringForFileName;

@end
