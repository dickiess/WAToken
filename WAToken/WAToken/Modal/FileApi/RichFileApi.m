//
//  RichFileApi.m
//  KingOfUnzip
//
//  Created by dizhihao on 15/8/25.
//  Copyright (c) 2015年 dizhihao. All rights reserved.
//

#import "RichFileApi.h"
#import "WAServer.h"

#import <CommonCrypto/CommonDigest.h>
#import "ZipArchive.h"
#import "Unrar4iOS2.h"
//#import "RARExtractException.h"


#import "LzmaSDKObjC.h"

static RichFileApi *_fileApi = nil;
static UIAlertView *_warnningMsg = nil;
static UIAlertView *_inputNewName = nil;
static UIAlertView *_inputSecretCode = nil;

// section
#define SECTION_1K  (1024)
#define SECTION_16K (16 * 1024)
#define SECTION_16M (SECTION_1K * SECTION_16K)


@interface RichFileApi() <UITextFieldDelegate, UIAlertViewDelegate,
ZipArchiveDelegate, LzmaSDKObjCReaderDelegate, LzmaSDKObjCWriterDelegate>

@property (nonatomic, copy) NSString    *warningMsg;     // 报错

@end

@implementation RichFileApi

// 单例
+ (RichFileApi *)sharedInstance {
    if (_fileApi == nil) {
        _fileApi = [[RichFileApi alloc] init];
        _fileApi.localPath = nil;
        _fileApi.file = nil;
        _fileApi.folder = nil;
        _fileApi.selectedFolders = nil;
        _fileApi.selectedFiles = nil;
        _fileApi.warningMsg = nil;
    }

    return _fileApi;
}

// 文件类型获取
- (FILE_TYPE)flagOfFile {
    FILE_TYPE flag = ORDINARY;
    NSString *suffix = [_file getFileSuffix];
    if ([suffix isEqualToString:@"zip"] || [suffix isEqualToString:@"ZIP"]) {
        flag = ZIP_FILE;
    } else if ([suffix isEqualToString:@"rar"] || [suffix isEqualToString:@"RAR"]) {
        flag = RAR_FILE;
    } else if ([suffix isEqualToString:@"7z"] || [suffix isEqualToString:@"7Z"]) {
            flag = SevenZ_FILE;
    }
    
    return flag;
}

// 扩展名匹配
+ (BOOL)fileSuffixEqualList:(NSArray *)list byFile:(RichFile *)file {
    NSInteger flag = 0;
    NSString *suffix = [file getFileSuffix];
    
    for (NSString *sfx in list) {
        if ([suffix isEqualToString:sfx]) { flag ++; }
    }
    
    if (flag > 0) {
        return YES;
    }
    return NO;
}

/**********************************************************************************************************************/

// 移动文件及文件夹
- (void)moveItems {
    
    // 1.准备
    NSFileManager  *fm       = [NSFileManager defaultManager];
    NSMutableArray *oFolders = [NSMutableArray array];   // 移动前文件夹
    NSMutableArray *nFolders = [NSMutableArray array];   // 目标文件夹
    NSMutableArray *oFiles   = [NSMutableArray array];   // 移动前的文件
    NSMutableArray *nFiles   = [NSMutableArray array];   // 目标文件
    
    // 2.筛选要处理的文件及文件夹
    //NSLog(@" ********* 开始移动 ********* ");
    // 2.1 文件夹
    if (_selectedFolders && _selectedFolders.count > 0) {
        for (RichFolder *folder in _selectedFolders) {
            
            // 2.1.1 本文件夹
            NSString *lPath = [NSString stringWithFormat:@"%@/%@", _localPath, folder.name];
            [oFolders addObject:folder];
            [nFolders addObject:[RichFolder folderWithName:folder.name andLocalPath:lPath]];
            
            // 2.1.2 子文件夹
            NSDirectoryEnumerator *dirEnum = [fm enumeratorAtPath:folder.localPath];
            NSString *subPath = nil;
            while ((subPath = [dirEnum nextObject]) != nil) {       // 获得目录下所有内容(包括子目录)
                //NSLog(@"%@",subPath);
                if ([[subPath lastPathComponent] isEqualToString:@".DS_Store"]) {
                    continue;
                }
                
                NSString *localPath  = [NSString stringWithFormat:@"%@/%@", folder.localPath, subPath];
                NSString *targetPath = [NSString stringWithFormat:@"%@/%@/%@", _localPath, folder.name, subPath];
                BOOL isFolder = NO;
                
                if ([fm fileExistsAtPath:localPath isDirectory:&isFolder]) {
                    NSString *itemName = [localPath lastPathComponent];
                    if (isFolder) {                                 // 获得待处理文件夹和待处理文件
                        RichFolder *fd0 = [RichFolder folderWithName:itemName andLocalPath:localPath];
                        [oFolders addObject:fd0];
                        RichFolder *fd1 = [RichFolder folderWithName:itemName andLocalPath:targetPath];
                        [nFolders addObject:fd1];
                        //NSLog(@"\n源文件夹:%@\n目标文件夹:%@", fd0.localPath, fd1.localPath);
                    } else {
                        RichFile *fl0 = [RichFile fileWithName:itemName andLocalPath:localPath];
                        [oFiles addObject:fl0];
                        RichFile *fl1 = [RichFile fileWithName:itemName andLocalPath:targetPath];
                        [nFiles addObject:fl1];
                        //NSLog(@"\n源文件:%@\n目标文件:%@", fl0.localPath, fl1.localPath);
                    }
                }
            }
        }
    }
    
    // 2.2 文件
    //NSLog(@" ********* 添加文件 ********* ");
    if (_selectedFiles && _selectedFiles.count > 0) {
        for (RichFile *adFile in _selectedFiles) {
            [oFiles addObject:adFile];
            NSString *filePath = [NSString stringWithFormat:@"%@/%@", _localPath, adFile.name];
            RichFile *adFile1 = [RichFile fileWithName:adFile.name andLocalPath:filePath];
            [nFiles addObject:adFile1];
            //NSLog(@"%@", adFile.name);
        }
    }
    
    // 3.创建文件夹
    //NSLog(@" ********* 创建文件夹 ********* ");
    for (RichFolder *nFd in nFolders) {
        if (![fm fileExistsAtPath:nFd.localPath isDirectory:nil]) {
            //NSLog(@"%@", nFd.name);
            NSDictionary *attr = @{NSFileCreationDate:[NSDate date]};
            [fm createDirectoryAtPath:nFd.localPath withIntermediateDirectories:NO attributes:attr error:nil];
        }
    }
    
    // 4.移动文件
    //NSLog(@" ********* 移动文件 ********* ");
    for (int i = 0; i < oFiles.count; i ++) {
        RichFile *f0 = oFiles[i];
        RichFile *f1 = nFiles[i];
        
        if (![fm fileExistsAtPath:f1.localPath isDirectory:nil]) {
            [fm moveItemAtPath:f0.localPath toPath:f1.localPath error:nil];
            //NSLog(@"%@", f1.name);
        }
    }
    
    // 5.清除文件夹
    //NSLog(@" ********* 清除文件夹 ********* ");
    for (RichFolder *oFd in oFolders) {
        NSArray *itemsInFolder = [fm contentsOfDirectoryAtPath:oFd.localPath error:nil];
        //NSLog(@"%@", itemsInFolder);
        if (itemsInFolder.count <= 0) {
            [fm removeItemAtPath:oFd.localPath error:nil];
        } else if (itemsInFolder.count == 1 && [itemsInFolder[0] isEqualToString:@".DS_Store"]) {
            NSString *ds = [NSString stringWithFormat:@"%@/%@", oFd.localPath, @".DS_Store"];
            [fm removeItemAtPath:ds error:nil];
            [fm removeItemAtPath:oFd.localPath error:nil];
        }
    }
    
    // 6.清理战场
    oFolders = nil;
    nFolders = nil;
    oFiles   = nil;
    nFiles   = nil;
    
    [self noticeReloadFiles];
    [self clearAllDefaults];
}

// 删除文件及文件夹
- (void)deleteItems {
    // 1.准备
    NSFileManager  *fm       = [NSFileManager defaultManager];
    
    // 2.筛选要处理的文件及文件夹
    // 2.1 文件夹
    if (_selectedFolders && _selectedFolders.count > 0) {
        for (RichFolder *folder in _selectedFolders) {
            NSDirectoryEnumerator *dirEnum = [fm enumeratorAtPath:folder.localPath];
            NSString *subPath = nil;
            while ((subPath = [dirEnum nextObject]) != nil) {       // 获得目录下所有内容(包括子目录)
                //NSLog(@"%@",subPath);
                
                NSString *localPath = [NSString stringWithFormat:@"%@/%@", folder.localPath, subPath];
                [fm removeItemAtPath:localPath error:nil];
            }
            [fm removeItemAtPath:folder.localPath error:nil];
        }
    }
    
    // 2.2 文件
    if (_selectedFiles && _selectedFiles.count > 0) {
        for (RichFile *file in _selectedFiles) {
            [fm removeItemAtPath:file.localPath error:nil];
        }
    }
    
    // 3.清理战场
    [self noticeReloadFiles];
    [self clearAllDefaults];
}

/**********************************************************************************************************************/

// 复制一个(多个)文件
- (void)copySomeFiles {
    NSString *destination = _folder.localPath;
    if (_selectedFiles && [_selectedFiles count] > 0) {
        [self copyFilesToPath:destination];
    } else if (_file) {
        [self copyFileToPath:destination];
    }
}

// 复制文件
- (void)copyFileToPath:(NSString *)path {
    RichFile *mFile = _file;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *existLocal = [path stringByAppendingPathComponent:mFile.name];
    if ([fm fileExistsAtPath:existLocal isDirectory:nil]) {
        [self warnningWithMsg:@"文件已存在, 复制失败."];
    } else {
        if ([fm copyItemAtPath:mFile.localPath toPath:existLocal error:nil]) {
            NSLog(@"copied: %@", existLocal);
            [self noticeReloadFiles];
        }
    }
    [self clearAllDefaults];
}

// 复制多个文件
- (void)copyFilesToPath:(NSString *)path {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSInteger flag = 0;
    for (RichFile *mFile in _selectedFiles) {
        NSString *existLocal = [path stringByAppendingPathComponent:mFile.name];
        if ([fm fileExistsAtPath:existLocal isDirectory:nil]) {
            [self warnningWithMsg:@"文件已存在, 复制失败."];
            break;
        } else {
            if ([fm copyItemAtPath:mFile.localPath toPath:existLocal error:nil]) {
                NSLog(@"copied: %@", existLocal);
                flag ++;
            };
        }
    }
    if (flag > 0) {
        [self noticeReloadFiles];
    }
    [self clearAllDefaults];
}

/**********************************************************************************************************************/

// 移动多个文件
- (void)moveSomeFiles {
    NSString *destination = _folder.localPath;
    if (_selectedFiles && [_selectedFiles count] > 0) {
        [self moveFilesToPath:destination];
    } else if (_file) {
        [self moveFileToPath:destination];
    }
}

// 移动文件
- (void)moveFileToPath:(NSString *)path {
    RichFile *mFile = _file;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *existLocal = [path stringByAppendingPathComponent:mFile.name];
    if ([fm fileExistsAtPath:existLocal isDirectory:nil]) {
        [self warnningWithMsg:@"文件已存在, 移动失败."];
    } else {
        if ([fm moveItemAtPath:mFile.localPath toPath:existLocal error:nil]) {
            //[self warnningWithMsg:[NSString stringWithFormat:@"文件移动成功."]];
            [self noticeReloadFiles];
        }
    }
    [self clearAllDefaults];
}

// 移动多个文件
- (void)moveFilesToPath:(NSString *)path {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSInteger flag = 0;
    for (RichFile *mFile in self.selectedFiles) {
        NSString *existLocal = [path stringByAppendingPathComponent:mFile.name];
        if ([fm fileExistsAtPath:existLocal isDirectory:nil]) {
            [self warnningWithMsg:@"文件已存在, 移动失败."];
            break;
        } else {
            if ([fm moveItemAtPath:mFile.localPath toPath:existLocal error:nil]) {
                flag ++;
            };
        }
    }
    if (flag > 0) {
        //[self warnningWithMsg:[NSString stringWithFormat:@" %d 个文件移动成功.", flag]];
        [self noticeReloadFiles];
    }
    [self clearAllDefaults];
}

/**********************************************************************************************************************/

// 删除文件
- (void)deleteRichFile {
    [self deleteRichFile:_file];
    [self noticeReloadFiles];
    [self clearAllDefaults];
}

// 删除指定文件
- (void)deleteRichFile:(RichFile *)file {
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:file.localPath error:nil];
}

// 删除多个文件
- (void)deleteSomeFiles {
    for (RichFile *file in _selectedFiles) {
        [self deleteRichFile:file];
    }
    [self noticeReloadFiles];
    [self clearAllDefaults];
}

/**********************************************************************************************************************/

// 文件已经存在
+ (BOOL)fileExistAtLocalPath:(NSString *)lPath {
    NSFileManager *fm = [NSFileManager defaultManager];
    return [fm fileExistsAtPath:lPath isDirectory:nil];
}

// 写入文件
+ (BOOL)creatFileWithData:(NSData *)data atLocalPath:(NSString *)lPath {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDictionary *dictionary = [NSDictionary dictionary];
    BOOL createOk = NO;
    createOk = [fm createFileAtPath:lPath contents:data attributes:dictionary];
    
    if (!createOk) {
        NSLog(@"create file failure : %@", dictionary);
    }
    return createOk;
}

/**********************************************************************************************************************/

// 删除文件夹
- (void)deleteRichFolder {
    [self deleteRichFolder:_folder];
    [self clearAllDefaults];
    [self noticeReloadFiles];
}

// 删除指定文件夹
- (void)deleteRichFolder:(RichFolder *)folder {
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:folder.localPath error:nil];
}

// 清除所有默认对象
- (void)clearAllDefaults {
    _localPath = nil;
    _file = nil;
    _folder = nil;
    _selectedFolders = nil;
    _selectedFiles = nil;
    //_warningMsg = nil;       // 不能置空
}

/**********************************************************************************************************************/

#pragma mark - Algorithm

// compress(api file)
- (void)compressWithAlgorithm:(COMPRESS_TYPE)algorithm
                        files:(NSArray <RichFile *> *)files
                         code:(NSString *)code
                      newFile:(RichFile *)nFile
                      success:(Success)success {
    
    [self clearAllDefaults];
    
    // 1.ZIP
    if (algorithm == COMPRESS_ZIP) {
        // 压缩进度
        ZipArchiveProgressUpdateBlock progressBlock
        = ^(int percentage, int filesProcessed, unsigned long numFiles) {
            NSLog(@"zip: total %d, processed %d / %d", percentage, filesProcessed, (int)numFiles);
            if (self->_delegate && [self->_delegate respondsToSelector:@selector(processWhenCompressionOrUncompression:)]) {
                [self->_delegate processWhenCompressionOrUncompression:percentage];
            }
        };
        
        ZipArchive *za = [[ZipArchive alloc] init];
        [za CreateZipFile:nFile.localPath Password:code];
        za.progressBlock = progressBlock;
        za.delegate = self;
        for (int fi = 0; fi < files.count; fi ++) {
            RichFile *f = files[fi];
            [za AddFileToZip:f.localPath newname:f.name];
        }
        
        if (_delegate && [_delegate respondsToSelector:@selector(processWhenCompressionOrUncompression:)]) {
            [_delegate processWhenCompressionOrUncompression:100];
        }
        
        if (! [za CloseZipFile]) {
            success(NO, @"压缩文件保存失败");
            return;
        }
        success(YES, @"压缩成功");
        return;
    }
    
    // 2.LZMA
    else if (algorithm == COMPRESS_LZMA) {
        // 写包初始化，定义写包的保存位置
        LzmaSDKObjCWriter *cWriter
        = [[LzmaSDKObjCWriter alloc] initWithFileURL:[NSURL fileURLWithPath:nFile.localPath]];
        cWriter.delegate = self;
        cWriter.passwordGetter = ^NSString *(void) { return code; };
        
        // 可选参数
        cWriter.method = LzmaSDKObjCMethodLZMA;
        cWriter.solid = YES;
        cWriter.compressionLevel = 7;
        cWriter.encodeContent = YES;
        cWriter.encodeHeader = YES;
        cWriter.compressHeader = YES;
        cWriter.compressHeaderFull = YES;
        cWriter.writeModificationTime = NO;
        cWriter.writeCreationTime = YES;
        cWriter.writeAccessTime = NO;
        
        for (int fi = 0; fi < files.count; fi ++) {
            RichFile *f = files[fi];
            [cWriter addData:[NSData dataWithContentsOfFile:f.localPath] forPath:f.name];     // 添加数据
            if (_delegate &&
                [_delegate respondsToSelector:@selector(processWhenCompressionOrUncompression:)]) {
                [_delegate processWhenCompressionOrUncompression:(NSInteger)(fi / (files.count + 1) * 100)];
            }
        }
        
        NSError *error = nil;
        [cWriter open:&error];
        if (error) {
            success(NO, [NSString stringWithFormat:@"LZMA:%@", error]);
        }
        if (_delegate &&
            [_delegate respondsToSelector:@selector(processWhenCompressionOrUncompression:)]) {
            [_delegate processWhenCompressionOrUncompression:100];
        }
        if (! [cWriter write]) {
            success(NO, @"压缩文件保存失败");
        }
        success(YES, @"压缩成功");
        return;
    }
}

// extract(api file)
- (void)extractWithFile:(RichFile *)file
                   code:(NSString *)code
                 toPath:(NSString *)path
                success:(Success)success {
    
    [self clearAllDefaults];
    
    // 算法选择
    NSString *suffix = [[file getFileSuffix] lowercaseString];
    COMPRESS_TYPE algorithm = 0;
    if ([suffix isEqualToString:@"zip"]) {
        algorithm = UNCOMPRESS_ZIP;
    } else if ([suffix isEqualToString:@"rar"]) {
        algorithm = UNCOMPRESS_RAR;
    } else if ([suffix isEqualToString:@"7z"]) {
        algorithm = UNCOMPRESS_LZMA;
    }
    if (algorithm == 0) {
        success(NO, @"不是压缩文件");
        return;
    }
    
    // 1.ZIP
    if (algorithm == UNCOMPRESS_ZIP) {
        // 解压文件进度
        ZipArchiveProgressUpdateBlock progressBlock
        = ^(int percentage, int filesProcessed, unsigned long numFiles) {
            NSLog(@"unzip: total %d, processed %d / %d", percentage, filesProcessed, (int)numFiles);
            if (self->_delegate && [self->_delegate respondsToSelector:@selector(processWhenCompressionOrUncompression:)]) {
                [self->_delegate processWhenCompressionOrUncompression:percentage];
            }
        };
        
        ZipArchive *za = [[ZipArchive alloc] init];
        za.delegate = self;
        za.progressBlock = progressBlock;
        
        BOOL ret = NO;
        if ([za UnzipOpenFile:file.localPath Password:code]) {
            NSLog(@"files list: %@", [za getZipFileContents]);
            ret = [za UnzipFileTo:path overWrite:YES];
        }
        
        if (_delegate &&
            [_delegate respondsToSelector:@selector(processWhenCompressionOrUncompression:)]) {
            [_delegate processWhenCompressionOrUncompression:1];
        }
        
        
        if (ret == NO) {
            success(NO, @"解压文件保存失败");
            return;
        }
        
        if (_delegate &&
            [_delegate respondsToSelector:@selector(processWhenCompressionOrUncompression:)]) {
            [_delegate processWhenCompressionOrUncompression:100];
        }
        
        [za CloseZipFile];
        za = nil;
        
        success(YES, @"解压成功");
        return;
    }
    
    // 2.RAR
    else if (algorithm == UNCOMPRESS_RAR) {
        Unrar4iOS2 *unrar = [[Unrar4iOS2 alloc] init];
        BOOL unrarOK = NO;
        
        if ([unrar unrarOpenFile:file.localPath withPassword:code]) {
            NSLog(@"files list: %@", [unrar unrarListFiles]);
            unrarOK = [unrar unrarFileTo:path overWrite:YES];
        }
        
        if (_delegate &&
            [_delegate respondsToSelector:@selector(processWhenCompressionOrUncompression:)]) {
            [_delegate processWhenCompressionOrUncompression:1];
        }
        
        if (unrarOK == NO) {
            success(NO, @"解压文件保存失败");
            return;
        }

        [unrar unrarCloseFile];
        unrar = nil;
        
        if (_delegate &&
            [_delegate respondsToSelector:@selector(processWhenCompressionOrUncompression:)]) {
            [_delegate processWhenCompressionOrUncompression:2];
        }
        
        // 如解压结果为空，解压失败
        NSFileManager *fm = [NSFileManager defaultManager];
        NSArray *list = [fm contentsOfDirectoryAtPath:path error:nil];
        if (list.count == 0) {
            success(NO, @"解压文件保存失败");
            return;
        }
        
        if (_delegate &&
            [_delegate respondsToSelector:@selector(processWhenCompressionOrUncompression:)]) {
            [_delegate processWhenCompressionOrUncompression:100];
        }
        
        success(YES, @"解压成功");
        return;
    }
    
    // 3.LZMA
    else if (algorithm == UNCOMPRESS_LZMA) {
        LzmaSDKObjCReader *cReader
        = [[LzmaSDKObjCReader alloc] initWithFileURL:[NSURL fileURLWithPath:file.localPath]
                                             andType:LzmaSDKObjCFileType7z];
        cReader.delegate = self;
        cReader.passwordGetter = ^NSString *(void) { return code; };
        
        if (_delegate &&
            [_delegate respondsToSelector:@selector(processWhenCompressionOrUncompression:)]) {
            [_delegate processWhenCompressionOrUncompression:1];
        }
        
        NSError *error = nil;
        [cReader open:&error];
        if (error) {
            success(NO, [NSString stringWithFormat:@"LZMA:%@", error]);
            return;
        }
        
        if (_delegate &&
            [_delegate respondsToSelector:@selector(processWhenCompressionOrUncompression:)]) {
            [_delegate processWhenCompressionOrUncompression:2];
        }
        
        NSMutableArray *items = [NSMutableArray array]; // Array with selected items.
        // Iterate all archive items, track what items do you need & hold them in array.
        [cReader iterateWithHandler:^BOOL(LzmaSDKObjCItem *item, NSError *error){
            NSLog(@"\n%@", item);
            if (item) {
                [items addObject:item]; // if needs this item - store to array.
            }
            return YES; // YES - continue iterate, NO - stop iteration
        }];
        
        if (_delegate &&
            [_delegate respondsToSelector:@selector(processWhenCompressionOrUncompression:)]) {
            [_delegate processWhenCompressionOrUncompression:3];
        }
        
        [cReader test:items];
        if (cReader.lastError) {
            success(NO, [NSString stringWithFormat:@"Iteration error: %@", cReader.lastError]);
            return;
        }
        
        if (_delegate &&
            [_delegate respondsToSelector:@selector(processWhenCompressionOrUncompression:)]) {
            [_delegate processWhenCompressionOrUncompression:100];
        }
        
        if (! [cReader extract:items toPath:path withFullPaths:YES]) {
            success(NO, @"解压文件保存失败");
            return;
        }
        
        success(YES, @"压缩成功");
        return;
    }
}

/**********************************************************************************************************************/

#pragma mark - ZIP

// zip文件(api file)
- (void)zipFile {
    [self zipFileWithCode:nil];
}

// 自定义zip文件(api file)
- (void)zipFileWithCode:(NSString *)code {
    NSString *nFilePath = [_file getFilePath];
    NSString *nFileName = [[_file getFileFirstName] stringByAppendingPathExtension:@"zip"];
    NSString *nFileLocal = [NSString stringWithFormat:@"%@/%@", nFilePath, nFileName];
    RichFile *nFile = [RichFile fileWithName:nFileName andLocalPath:nFileLocal];
    
    // 如果文件已存在,则更名
    NSString *oFileName = [self changeRichFileNameByFile:nFile suffix:@"zip"];
    NSString *oFilePath = [NSString stringWithFormat:@"%@/%@", nFilePath, oFileName];
    RichFile *oFile = [RichFile fileWithName:oFileName andLocalPath:oFilePath];
    
    NSInteger progress = 0;
    if ([self _zipFile:_file withCode:code toFile:oFile] == NO) {
        [self warnningWithMsg:@"压缩文件失败"];
    } else {
        progress = 100;
    }
    
    [self clearAllDefaults];
    [self noticeReloadFiles];
    
    if ([_delegate respondsToSelector:@selector(zipingFileProcess:output:)]) {
        [_delegate zipingFileProcess:progress output:oFile.name];
    }
}

// Zip文件到指定目录(类方法)
+ (RichFile *)zipFileWithFile:(RichFile *)file Code:(NSString *)code toPath:(NSString *)path {
    NSString *nFileName = [[file getFileFirstName] stringByAppendingPathExtension:@"zip"];
    NSString *nFileLocal = [NSString stringWithFormat:@"%@/%@", path, nFileName];
    RichFile *nFile = [RichFile fileWithName:nFileName andLocalPath:nFileLocal];
    
    ZipArchive *za = [[ZipArchive alloc] init];
    [za CreateZipFile:nFileLocal Password:code];
    [za AddFileToZip:file.localPath newname:file.name];
    if (![za CloseZipFile]) {
        NSLog(@"压缩文件失败");
        return nil;
    };
    return nFile;
}

// 自定义zip文件
- (BOOL)_zipFile:(RichFile *)file withCode:(NSString *)code toFile:(RichFile *)oFile {
    ZipArchive *za = [[ZipArchive alloc] init];
    [za CreateZipFile:oFile.localPath Password:code];
    [za AddFileToZip:file.localPath newname:file.name];
    BOOL success = NO;
    success = [za CloseZipFile];
    
    return success;
}

// zip多个文件 D011
- (void)zipSomeFiles {
    // 1.input box
    _inputNewName = [[UIAlertView alloc] initWithTitle:@"文件名:"
                                               message:nil
                                              delegate:self
                                     cancelButtonTitle:@"确定"
                                     otherButtonTitles:@"取消", nil];
    [_inputNewName setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [_inputNewName setTag:205];
    
    // 2.text field
    UITextField *textField = [_inputNewName textFieldAtIndex:0];
    textField.delegate = self;
    NSString *existLocal = [_localPath stringByAppendingPathComponent:@"新Zip文件.zip"];
    RichFile *oFile = [RichFile fileWithName:@"新Zip文件.zip" andLocalPath:existLocal];
    textField.text = [self changeRichFileNameByFile:oFile suffix:@"zip"];
    
    // 3.show
    [_inputNewName show];
}

// 获得新文件名, zip多个文件 D013
- (void)zipFilesWithNewName:(NSString *)newName {
    NSString *existLocal = [_localPath stringByAppendingPathComponent:newName];
    RichFile *oFile = [RichFile fileWithName:newName andLocalPath:existLocal];
    
    // 1.suffix check
    if (![[oFile getFileSuffix] isEqualToString:@"zip"]) {
        NSString *cName = [newName stringByAppendingPathExtension:@"zip"];
        existLocal = [_localPath stringByAppendingPathComponent:cName];
        oFile = [RichFile fileWithName:newName andLocalPath:existLocal];
    }
    
    // 2.file exist check
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:oFile.localPath isDirectory:nil]) {
        [self warnningWithMsg:@"该文件已存在."];
        [self clearAllDefaults];
        return;
    }
    
    // 3.files zip
    if ([self _zipFiles:self.selectedFiles toNewFile:oFile]) {
        [self clearAllDefaults];
        [self noticeReloadFiles];
    } else {
        [self warnningWithMsg:@"压缩文件失败."];
        [self clearAllDefaults];
    }
}

// 选择多个文件以指定名字压缩 D014
- (BOOL)_zipFiles:(NSMutableArray *)files toNewFile:(RichFile *)nFile {
    ZipArchive *za = [[ZipArchive alloc] init];
    [za CreateZipFile:nFile.localPath];
    for (RichFile *sFile in files) {
        [za AddFileToZip:sFile.localPath newname:sFile.name];
    }
    BOOL success = NO;
    success = [za CloseZipFile];
    NSLog(@"%@", success ? @"some files zipped ok." : @"some files zipped failed.");
    
    return success;
}

// 错误(zip / unzip 报错委托)
- (void)ErrorMessage:(NSString *)msg {
    NSLog(@"zip / unzip error: %@", msg);
}

// unzip文件(api file)
- (void)unzipFile {
    [self unzipFileWithCode:nil];
}

// 自定义unzip文件(api file)
- (void)unzipFileWithCode:(NSString *)code {
    NSString *nFolderName = [_file getFileFirstName];
    NSString *nFolderPath = [[_file getFilePath] stringByAppendingPathComponent:nFolderName];
    RichFolder *nFolder = [RichFolder folderWithName:nFolderName andLocalPath:nFolderPath];
    
    // 如果文件夹已存在,则更名
    nFolderName = [self changeRichFolderName:nFolder create:YES];
    nFolderPath = [[_file getFilePath] stringByAppendingPathComponent:nFolderName];
    nFolder = [RichFolder folderWithName:nFolderName andLocalPath:nFolderPath];
    
    NSInteger progress = 0;
    if ([self _unzipFile:_file withCode:code toFolder:nFolder]) {
         progress = 100;
    } else {
        [self warnningWithMsg:@"解压文件失败，编辑Password后再试一下"];
    }
    
    [self clearAllDefaults];
    [self noticeReloadFiles];
    
    if ([_delegate respondsToSelector:@selector(unzipingFileProcess:)]) {
        [_delegate unzipingFileProcess:progress];
    }
}

// unzip文件
- (BOOL)_unzipFile:(RichFile *)file {
    ZipArchive *za = [[ZipArchive alloc] init];
    [za setDelegate:self];
    
    // 解压文件进度
    ZipArchiveProgressUpdateBlock progressBlock
    = ^(int percentage, int filesProcessed, unsigned long numFiles) {
        NSLog(@"total %d, filesProcessed %d / %d", percentage, filesProcessed, (int)numFiles);
    };
    za.progressBlock = progressBlock;
    
    BOOL ret = NO;
    if ([za UnzipOpenFile:file.localPath]) {
        NSLog(@"files list: %@", [za getZipFileContents]);
        ret = [za UnzipFileTo:[file getFilePath] overWrite:YES];
    }
    [za CloseZipFile];
    za = nil;
    
    return ret;
}

// 自定义unzip文件
- (BOOL)_unzipFile:(RichFile *)file withCode:(NSString *)code toFolder:(RichFolder *)folder {
    ZipArchive *za = [[ZipArchive alloc] init];
    za.delegate = self;
    
    // 解压文件进度
    ZipArchiveProgressUpdateBlock progressBlock
    = ^(int percentage, int filesProcessed, unsigned long numFiles) {
        NSLog(@"total %d, filesProcessed %d / %d", percentage, filesProcessed, (int)numFiles);
    };
    za.progressBlock = progressBlock;
    
    BOOL ret = NO;
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([za UnzipOpenFile:file.localPath Password:code]) {
        NSLog(@"files list: %@", [za getZipFileContents]);
        BOOL isDictionary = NO;
        if ([fm fileExistsAtPath:folder.localPath isDirectory:&isDictionary] && isDictionary) {
            ret = [za UnzipFileTo:folder.localPath overWrite:YES];
        } else {
            ret = [za UnzipFileTo:[file getFilePath] overWrite:YES];
        }
    }
    [za CloseZipFile];
    za = nil;
    
    return ret;
}

// unrar文件(api file)
- (void)unrarFile {
    if ([self unrarFile:_file]) {
        NSLog(@"file unrared!");
    } else {
        [self warnningWithMsg:@"解压文件失败，编辑Password后再试一下"];
    }
    
    [self clearAllDefaults];
    [self noticeReloadFiles];
}

// 自定义unrar文件(api file)
- (void)unrarFileWithCode:(NSString *)code {
    
    if ([self unrarFile:_file withCode:code]) {
        NSLog(@"file unrared!");
    } else {
        [self warnningWithMsg:@"解压文件失败，编辑Password后再试一下"];
    }
    
    _file = nil;
    [self noticeReloadFiles];
}

// unrar文件(api file)
- (BOOL)unrarFile:(RichFile *)file {
    
    Unrar4iOS2 *unrar = [[Unrar4iOS2 alloc] init];
    BOOL unrarOK = NO;
    
    if ([unrar unrarOpenFile:file.localPath]) {
        unrarOK = [unrar unrarFileTo:[file getFilePath] overWrite:YES];
    }
    [unrar unrarCloseFile];

    return unrarOK;
}

// 自定义unrar文件(api file)
- (BOOL)unrarFile:(RichFile *)file withCode:(NSString *)code {

    Unrar4iOS2 *unrar = [[Unrar4iOS2 alloc] init];
    BOOL unrarOK = NO;
    
    if ([unrar unrarOpenFile:file.localPath withPassword:code]) {
        unrarOK = [unrar unrarFileTo:[file getFilePath] overWrite:YES];
    }
    
    return [unrar unrarCloseFile];
}

/********************************************************************************************************************/


#pragma mark - lzma

// lzma文件(api file)
- (void)lzmaFile {
    [self lzmaFileWithCode:nil];
}

// 自定义lzma文件(api file)
- (void)lzmaFileWithCode:(NSString *)code {
    NSString *nFilePath = [_file getFilePath];
    NSString *nFileName = [[_file getFileFirstName] stringByAppendingPathExtension:@"7z"];
    NSString *nFileLocal = [NSString stringWithFormat:@"%@/%@", nFilePath, nFileName];
    RichFile *nFile = [RichFile fileWithName:nFileName andLocalPath:nFileLocal];
    
    // 如果文件已存在,则更名
    NSString *oFileName = [self changeRichFileNameByFile:nFile suffix:@"7z"];
    NSString *oFilePath = [NSString stringWithFormat:@"%@/%@", nFilePath, oFileName];
    RichFile *oFile = [RichFile fileWithName:oFileName andLocalPath:oFilePath];
    
    NSInteger progress = 0;
    if ([self _lzmaFile:_file withCode:code toFile:oFile] == NO) {
        [self warnningWithMsg:@"压缩文件失败"];
    } else {
        progress = 100;
    }
    
    [self clearAllDefaults];
    [self noticeReloadFiles];
    
    if ([_delegate respondsToSelector:@selector(lzmaFileProcess:output:)]) {
        [_delegate lzmaFileProcess:progress output:oFile.name];
    }
}

// lzma压缩算法
- (BOOL)_lzmaFile:(RichFile *)file withCode:(NSString *)code toFile:(RichFile *)oFile {
    // 写包初始化，定义写包的保存位置
    LzmaSDKObjCWriter *cWriter
    = [[LzmaSDKObjCWriter alloc] initWithFileURL:[NSURL fileURLWithPath:oFile.localPath]];
    [cWriter addData:[NSData dataWithContentsOfFile:file.localPath] forPath:file.name];     // 添加数据
    cWriter.delegate = self;
    cWriter.passwordGetter = ^NSString *(void) { return code; };
    
    // 可选参数
    cWriter.method = LzmaSDKObjCMethodLZMA;
    cWriter.solid = YES;
    cWriter.compressionLevel = 7;
    cWriter.encodeContent = YES;
    cWriter.encodeHeader = YES;
    cWriter.compressHeader = YES;
    cWriter.compressHeaderFull = YES;
    cWriter.writeModificationTime = NO;
    cWriter.writeCreationTime = YES;
    cWriter.writeAccessTime = NO;
    
    NSError *error = nil;
    [cWriter open:&error];
    if (error) {
        NSLog(@"lzma error: %@", error);
        return NO;
    }
    
    return [cWriter write];
}

// lzma多个文件
- (void)lzmaFiles {

}

// lzma算法过程
- (void)onLzmaSDKObjCWriter:(LzmaSDKObjCWriter *)writer writeProgress:(float)progress {
    if (progress * 100 > 1) {
        //NSLog(@"%.0f%%", progress * 100);
    }
}

// unlzma文件(api file)
- (void)unlzmaFile {
    [self unrarFileWithCode:nil];
}

// 自定义unlzma文件(api file)
- (void)unlzmaFileWithCode:(NSString *)code {
    NSString *nFilePath = [_file getFilePath];
    NSString *nFileName = [[_file getFileFirstName] stringByAppendingPathExtension:@"7z"];
    NSString *nFileLocal = [NSString stringWithFormat:@"%@/%@", nFilePath, nFileName];
    RichFile *nFile = [RichFile fileWithName:nFileName andLocalPath:nFileLocal];
    
    // 如果文件已存在,则更名
    NSString *oFileName = [self changeRichFileNameByFile:nFile suffix:@"7z"];
    NSString *oFilePath = [NSString stringWithFormat:@"%@/%@", nFilePath, oFileName];
    RichFile *oFile = [RichFile fileWithName:oFileName andLocalPath:oFilePath];
    
    NSInteger progress = 0;
    if ([self _lzmaFile:_file withCode:code toFile:oFile] == NO) {
        [self warnningWithMsg:@"压缩文件失败"];
    } else {
        progress = 100;
    }
    
    [self clearAllDefaults];
    [self noticeReloadFiles];
    
    if ([_delegate respondsToSelector:@selector(lzmaFileProcess:output:)]) {
        [_delegate lzmaFileProcess:progress output:oFile.name];
    }
}

// lzma压缩算法
- (BOOL)_unlzmaFile:(RichFile *)file withCode:(NSString *)code toPath:(NSString *)oPath {

    return NO;
}

/********************************************************************************************************************/

// 弹窗警告
- (void)warnningWithMsg:(NSString *)msg {
    _warnningMsg = [[UIAlertView alloc] initWithTitle:@"提示:"
                                              message:msg
                                             delegate:self
                                    cancelButtonTitle:@"确定"
                                    otherButtonTitles:nil, nil];
    [_warnningMsg setTag:201];
    [_warnningMsg show];
}

// 输入框
- (void)inputBoxWithTitle:(NSString *)title delegate:(UIViewController *)delegate
                  message:(NSString *)message placeholder:(NSString *)placeholder
                     text:(NSString *)text security:(BOOL)security rectForPad:(CGRect)rect
                      tag:(NSUInteger)tag
                completed:(Completed)completed {
    // 初始化
    UIAlertController *alertDialog
    = [UIAlertController alertControllerWithTitle:title
                                          message:message
                                   preferredStyle:UIAlertControllerStyleAlert];
    
    // 创建文本框
    [alertDialog addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = text;
        textField.placeholder = placeholder;
        textField.secureTextEntry = security;
    }];
    
    // 创建操作
    UIAlertAction *cancelAction
    = [UIAlertAction actionWithTitle:@"取消"
                               style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction *action) {}];
    
    // 添加操作（顺序就是呈现的上下顺序）
    [alertDialog addAction:cancelAction];
    
    // 创建操作
    UIAlertAction *okAction
    = [UIAlertAction actionWithTitle:@"确定"
                               style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction *action) {
                                 // 读取文本框的值显示出来
                                 UITextField *textField = alertDialog.textFields.firstObject;
                                 completed(textField.text);
                             }];
    
    // 添加操作（顺序就是呈现的上下顺序）
    [alertDialog addAction:okAction];
    
    // 呈现警告视图
    if (DEVICE_IPAD) {
        UIPopoverPresentationController *popPresenter = [alertDialog popoverPresentationController];
        popPresenter.sourceView = delegate.view;
        popPresenter.sourceRect = rect;
        [delegate presentViewController:alertDialog animated:YES completion:nil];
    } else {
        [delegate presentViewController:alertDialog animated:YES completion:nil];
    }
}


// 重命名输入 A011
- (void)inputFileName {
    
    _inputNewName = nil;
    
    // 1.input box
    _inputNewName = [[UIAlertView alloc] initWithTitle:@"文件名:"
                                               message:nil
                                              delegate:self
                                     cancelButtonTitle:@"确定"
                                     otherButtonTitles:@"取消", nil];
    [_inputNewName setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [_inputNewName setTag:202];
    
    // 2.text field
    UITextField *textField = [_inputNewName textFieldAtIndex:0];
    [textField setDelegate:self];
    textField.text = [_file getFileFirstName];
    
    // 3.show
    [_inputNewName show];
}

// 密码输入框 B011
- (void)inputSecretCodeBox {
    
    // 1.inputbox
    _inputSecretCode
    = [[UIAlertView alloc] initWithTitle:@"请输入密码:"
                                 message:nil
                                delegate:self
                       cancelButtonTitle:@"确定"
                       otherButtonTitles:@"取消", nil];
    [_inputSecretCode setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [_inputSecretCode setTag:204];
    
    // 2.text field
    UITextField *textField = [_inputSecretCode textFieldAtIndex:0];
    [textField setDelegate:self];
    [textField setSecureTextEntry:YES];
    [_inputSecretCode show];
}

// 获得重命名 A012, 获得压缩解压密码 B012, 新建文件夹 C012, 多个文件压缩 D012
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSInteger tag = alertView.tag;
    NSString *content = [alertView textFieldAtIndex:0].text;
    content = content == nil ? @"" : content;
    
    SEL aSelector = @selector(noticeReloadFiles);
    switch (tag) {
        case 201: { // 1.warning
        
        } break;
            
        case 202: { // 2.rename
            if (buttonIndex == 0) {
                aSelector = @selector(renameFileWithName:);
            } else if (buttonIndex == 1) {
                return;
            }
        } break;
            
        case 203: { // 3.create new folder
            if (buttonIndex == 0) {
                aSelector = @selector(createNewFolderWithName:);
            } else if (buttonIndex == 1) {
                
            }
        } break;
            
        case 204: { // 4.zip or unzip file
            if (buttonIndex == 0) {
                NSLog(@"secret code: %@", content);
                FILE_TYPE flag = [self flagOfFile];
                [WaitingHUD show:@""];
                if (flag == ORDINARY) {
                    aSelector = @selector(zipFileWithCode:);
                } else if (flag == ZIP_FILE) {
                    aSelector = @selector(unzipFileWithCode:);
                } else if (flag == RAR_FILE) {
                    aSelector = @selector(unrarFileWithCode:);
                }
            } else if (buttonIndex == 1) {

            }
        } break;
            
        case 205: { // 5.zip some files
            if (buttonIndex == 0) {
                aSelector = @selector(zipFilesWithNewName:);
            } else if (buttonIndex == 1) {

            }
        } break;
            
        default: break;
    }
    
    // 因为前端有键盘动作,所以执行要延后
    [self performSelector:aSelector withObject:content afterDelay:METHOD_DELAY];
}

// 通知刷新列表
- (void)noticeReloadFiles {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_REFRESH_LOCAL object:nil];
}

// 重命名更名 A013
- (void)renameFileWithName:(NSString *)replaceName {
    NSString *replaceFile = [replaceName stringByAppendingPathExtension:[_file getFileSuffix]];
    if ([replaceFile isEqualToString:_file.name]) {
        _warningMsg = @"该文件已存在.";
    } else {
        NSString *replaceFilePath = [[_file getFilePath] stringByAppendingPathComponent:replaceFile];
        [self renameFileWithFileName:[RichFile fileWithName:replaceFile andLocalPath:replaceFilePath]];
    }
    [self clearAllDefaults];
}

// 检查文件是否存在,重命名文件 A014
- (void)renameFileWithFileName:(RichFile *)file {
    // 1.file exist check
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *exFile = [[file getFilePath] stringByAppendingPathComponent:file.name];
    if ([fm fileExistsAtPath:exFile]) {
        _warningMsg = @"该文件已存在.";
    } else {
        // 2.rename file
        [fm moveItemAtPath:_file.localPath toPath:exFile error:nil];
        [self noticeReloadFiles];
    }
}

/**********************************************************************************************************************/

// 输入新建文件夹名 C011 (包括重命名文件夹)
- (void)inputFolderName {
    // 1.input box
    _inputNewName = [[UIAlertView alloc] initWithTitle:@"文件夹名:"
                                               message:nil
                                              delegate:self
                                     cancelButtonTitle:@"确定"
                                     otherButtonTitles:@"取消", nil];
    [_inputNewName setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [_inputNewName setTag:203];
    
    // 2.text field
    UITextField *textField = [_inputNewName textFieldAtIndex:0];
    [textField setDelegate:self];
    if (_folder) {
        textField.text = _folder.name;
    } else {
        textField.text = @"新建文件夹";
    }
    
    // 3.show
    [_inputNewName show];
}

// 新建文件夹 C013
- (void)createNewFolderWithName:(NSString *)folderName {
    // 1.file manager
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDictionary *attributes = @{NSFileCreationDate:[NSDate date]};
    NSError *err = nil;
    
    // 2.path
    BOOL isFolder = NO;
    NSString *local = _localPath;
    NSString *path = [local stringByAppendingPathComponent:folderName];
    if ([fm fileExistsAtPath:path isDirectory:&isFolder]) {
        [WA_API systemWarnning:@"文件夹已存在."];
        return;
    }
    
    // 3.folder
    [fm createDirectoryAtPath:path withIntermediateDirectories:NO attributes:attributes error:&err];
    if (_folder) {
        // 3.1 move file to new folder
        NSArray *files = [fm contentsOfDirectoryAtPath:_folder.localPath error:nil];
        if ([files count] > 0) {
            for (NSString *file in files) {
                NSString *orgPath = [_folder.localPath stringByAppendingPathComponent:file];
                NSString *desPath = [path stringByAppendingPathComponent:file];
                [fm moveItemAtPath:orgPath toPath:desPath error:nil];
            }
        }
        [fm removeItemAtPath:_folder.localPath error:nil];
    }
    
    // 4.fresh files list
    [self clearAllDefaults];
    [self noticeReloadFiles];
}

/**********************************************************************************************************************/

// 键盘回退
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

/**********************************************************************************************************************/

// SHA256加密
- (NSString *)getSha256String:(NSString *)srcString {
    
    const char *cstr = [srcString UTF8String];
    NSData *data = [NSData dataWithBytes:cstr length:strlen(cstr)];
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(data.bytes, (int)data.length, digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i ++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;
}

/**********************************************************************************************************************/

//  A021
/**
 文件名重名自动转换
 
 @param file 文件名，文件路径等
 @param suff 文件目标后缀
 @return     返回最终文件名
 */
- (NSString *)changeRichFileNameByFile:(RichFile *)file suffix:(NSString *)suff {
    // file exist check
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *exFileName = [[file getFileFirstName] stringByAppendingPathExtension:suff];
    NSString *exFile = [[file getFilePath] stringByAppendingPathComponent:exFileName];
    if (![fm fileExistsAtPath:exFile])  return exFileName;
    
    NSInteger num = 1;
    NSString *exportFileName;
    while (1) {
        NSString *addition = [NSString stringWithFormat:@"(%d)", (int)num];
        NSString *exportFirstName = [[file getFileFirstName] stringByAppendingString:addition];
        exportFileName = [exportFirstName stringByAppendingPathExtension:suff];
        NSString *exportFile = [[file getFilePath] stringByAppendingPathComponent:exportFileName];
        
        if ([fm fileExistsAtPath:exportFile]) {
            num ++;
        } else {
            break;
        }
    }
    
    return exportFileName;
}

// 文件夹重名自动转换(是否创建)
- (NSString *)changeRichFolderName:(RichFolder *)folder create:(BOOL)create {
    // file exist check
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:folder.localPath]) {
        if (create) {
            [fm createDirectoryAtPath:folder.localPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        return folder.name;
    }
    
    NSInteger num = 1;
    NSString *exFolderName;
    while (1) {
        exFolderName = [folder.name stringByAppendingString:[NSString stringWithFormat:@"(%d)", (int)num]];
        NSString *exFolderPath = [[folder getFolderPath] stringByAppendingPathComponent:exFolderName];
        if ([fm fileExistsAtPath:exFolderPath]) {
            num ++;
        } else {
            if (create) {
                [fm createDirectoryAtPath:exFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            break;
        }
    }
    
    return exFolderName;
}

// 文件名重名自动转换
+ (RichFile *)changeRichFileNameByFile:(RichFile *)file {
    
    // file exist check
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:file.localPath]) {
        return [RichFile fileWithName:file.name andLocalPath:file.localPath];
    }
    
    // file name change
    NSInteger num = 1;
    NSString *path = [file getFilePath];                   // 路径
    NSString *fileFirstName = [file getFileFirstName];     // 文件名
    NSString *suffix = [file getFileSuffix];               // 后缀
    NSString *exportFileName;                              // 输出文件名（带后缀）
    NSString *exportFilePath;                              // 输出路径（带文件名）
    while (1) {
        NSString *addition = [NSString stringWithFormat:@"(%d)", (int)num];
        NSString *exportFirstName = [fileFirstName stringByAppendingString:addition];
        exportFileName = [exportFirstName stringByAppendingPathExtension:suffix];
        exportFilePath = [path stringByAppendingPathComponent:exportFileName];
        
        BOOL exist = [fm fileExistsAtPath:exportFilePath];
        
        if (exist) {
            num ++;
        } else {
            break;
        }
    }
    
    return [RichFile fileWithName:exportFileName andLocalPath:exportFilePath];
}

// 判断是否同一个文件
- (BOOL)isEqualFile:(RichFile *)firstFile secondFile:(RichFile *)secondFile {
    
    if ([firstFile.name isEqualToString:secondFile.name] &&
        [firstFile.localPath isEqualToString:secondFile.localPath]) {
        return YES;
    }
    
    return NO;
}

/**********************************************************************************************************************/

// 命名日期获取
+ (NSString *)dateStringForFileName {
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFM = [[NSDateFormatter alloc] init];
    [dateFM setDateFormat:@"YYYYMMdd"];
    return [dateFM stringFromDate:nowDate];
}

@end
