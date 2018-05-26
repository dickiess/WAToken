//
//  SLMyApis.m
//  faceAD
//
//  Created by dizhihao on 15/7/17.
//  Copyright (c) 2015年 dizhihao. All rights reserved.
//

#import "AFNetworkApi.h"
#import "AppDelegate.h"
#import "AFURLRequestSerialization.h"

static AFNetworkApi *_apis = nil;

/**********************************************************************************************************/

@interface AFNetworkApi() <NSURLSessionDownloadDelegate>

@property (strong, nonatomic) AFHTTPSessionManager *manager;

/* NSURLSessions */
@property (strong, nonatomic)           NSURLSession *currentSession;    // 当前会话
@property (strong, nonatomic, readonly) NSURLSession *backgroundSession; // 后台会话

/* 下载任务 */
@property (strong, nonatomic) NSURLSessionDownloadTask *cancellableTask; // 可取消的下载任务
@property (strong, nonatomic) NSURLSessionDownloadTask *resumableTask;   // 可恢复的下载任务
@property (strong, nonatomic) NSURLSessionDownloadTask *backgroundTask;  // 后台的下载任务

/* 用于可恢复的下载任务的数据 */
@property (strong, nonatomic) NSData   *partialData;

@property (copy, nonatomic)   NSString *downloadedFile;       // 下载文件名
@property (copy, nonatomic)   NSString *downloadedFolder;     // 下载文件夹

/* 显示已经下载的图片 */
@property (strong, nonatomic) UIImage  *downloadedImage;

@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;

@end

/**********************************************************************************************************/

@implementation AFNetworkApi

// 初始化
+ (AFNetworkApi *)sharedInstance {
    if (_apis == nil) {
        _apis = [[AFNetworkApi alloc] init];
        _apis.defaultIcon = @"";
        _apis.hostUrl = @"";
        _apis.imageHostUrl = @"";
    }
    return _apis;
}

#pragma mark - 检测网络连接
- (void)reach {
    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // 局域网络,不花钱
     */
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    
    // 检测网络连接的单例,网络变化时的回调方法
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: {
                NSLog(@"=!= 网络情况未知 ===");
            } break;
            
            case AFNetworkReachabilityStatusNotReachable: {
                NSLog(@"=!= 网络无连接 ===");
            } break;
            
            case AFNetworkReachabilityStatusReachableViaWWAN: {
                NSLog(@"=!= 3G 网络 ===");
            } break;
            
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                NSLog(@"=!= 局域网 ===");
            } break;
                
            default: break;
        }
    }];
}


// 网络状态
- (BOOL)isReachable {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    return [reachability currentReachabilityStatus] > 0;
}


/**
 
 要使用常规的AFN网络访问
 
 1. AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
 所有的网络请求,均有manager发起
 
 2. 需要注意的是,默认提交请求的数据是二进制的,返回格式是JSON
 1> 如果提交数据是JSON的,需要将请求格式设置为AFJSONRequestSerializer
 2> 如果返回格式不是JSON的,
 
 3. 请求格式
 AFHTTPRequestSerializer            二进制格式
 AFJSONRequestSerializer            JSON
 AFPropertyListRequestSerializer    PList(是一种特殊的XML,解析起来相对容易)
 
 4. 返回格式
 AFHTTPResponseSerializer           二进制格式
 AFJSONResponseSerializer           JSON
 AFXMLParserResponseSerializer      XML,只能返回XMLParser,还需要自己通过代理方法解析
 AFXMLDocumentResponseSerializer    (Mac OS X)
 AFPropertyListResponseSerializer   PList
 AFImageResponseSerializer          Image
 AFCompoundResponseSerializer       组合
 
 5.acceptableContentTypes 设置为集合NSSet
 设置成 @"text/html"  或  @"application/json"
 
 
 */


// 发送服务器Post请求
- (void)PostWithInterface:(NSString *)interface Dictionary:(NSDictionary *)dictionary {
    
    __weak typeof(self) af = self;
    
    _manager = [AFHTTPSessionManager manager];
    _manager.requestSerializer  = [AFHTTPRequestSerializer serializer];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    if ([_hostUrl isEqualToString:@""]) {
        NSLog(@"缺少host地址");
        return;
    }
    NSString *postCommand = [_hostUrl stringByAppendingString:interface];
    NSLog(@"\npost request: %@\n%@", postCommand, dictionary);
    
    // 调用开始
    if ([af.ApiDelegate respondsToSelector:@selector(requestStartWithInterface:)]) {
        [af.ApiDelegate requestStartWithInterface:interface];
    }
    
    // 网络访问是异步的,回调是主线程的,因此程序员不用管在主线程更新UI的事情
    [_manager POST:postCommand parameters:dictionary progress:^(NSProgress *downloadProgress) {
        NSInteger progress = (NSInteger)downloadProgress.fractionCompleted * 100;
        //NSLog(@"progress: %d%%", (int)progress);
        if ([af.ApiDelegate respondsToSelector:@selector(requestProgress:interface:)]) {
            [af.ApiDelegate requestProgress:progress interface:interface];
        }
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        // 提问:NSURLConnection异步方法回调,是在子线程
        // 得到回调之后,通常更新UI,是在主线程
        NSDictionary *info = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:0 error:nil];
        //NSLog(@"\n---------服务器POST请求---------\n接口：%@\n返回：\n%@\n\n", interface, info);
        
        if ([af.ApiDelegate respondsToSelector:@selector(requestFinishedWithCallBackInfo:interface:)] ) {
            [af.ApiDelegate requestFinishedWithCallBackInfo:info interface:interface];
        }
        //NSLog(@"POST --> Response:%@, Thread:%@", responseObject, [NSThread currentThread]); // 自动返回主线程
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //NSLog(@"错误信息------------------------:\n%@", error);
        if ([af.ApiDelegate respondsToSelector:@selector(requestFailedWithError:interface:)] ) {
            [af.ApiDelegate requestFailedWithError:error interface:interface];
        }
    }];
}

// 发送服务器Get请求
- (void)GetWithInterface:(NSString *)interface Dictionary:(NSDictionary *)dictionary {
    
    __weak typeof(self) af = self;
    
    _manager = [AFHTTPSessionManager manager];
    _manager.requestSerializer  = [AFHTTPRequestSerializer serializer];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    if ([_hostUrl isEqualToString:@""]) {
        NSLog(@"缺少host地址");
        return;
    }
    NSString *getCommand = [_hostUrl stringByAppendingString:interface];
    NSLog(@"\nget request: %@\n%@", getCommand, dictionary);
    
    // 调用开始
    if ([af.ApiDelegate respondsToSelector:@selector(requestStartWithInterface:)]) {
        [af.ApiDelegate requestStartWithInterface:interface];
    }
    
    // 网络访问是异步的,回调是主线程的,因此程序员不用管在主线程更新UI的事情
    [_manager GET:getCommand parameters:dictionary progress:^(NSProgress *downloadProgress) {
        NSInteger progress = (NSInteger)downloadProgress.fractionCompleted * 100;
        //NSLog(@"progress: %d%%", (int)progress);
        if ([af.ApiDelegate respondsToSelector:@selector(requestProgress:interface:)]) {
            [af.ApiDelegate requestProgress:progress interface:interface];
        }
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        // 提问:NSURLConnection异步方法回调,是在子线程
        // 得到回调之后,通常更新UI,是在主线程
        NSDictionary *info = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:0 error:nil];
        //NSLog(@"\n---------服务器GET请求---------\n接口：%@\n返回：\n%@\n\n", interface, info);
        
        if ([af.ApiDelegate respondsToSelector:@selector(requestFinishedWithCallBackInfo:interface:)] ) {
            [af.ApiDelegate requestFinishedWithCallBackInfo:info interface:interface];
        }
        //NSLog(@"GET --> Response:%@, Thread:%@", responseObject, [NSThread currentThread]); // 自动返回主线程
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //NSLog(@"错误信息------------------------:\n%@", error);
        if ([af.ApiDelegate respondsToSelector:@selector(requestFailedWithError:interface:)] ) {
            [af.ApiDelegate requestFailedWithError:error interface:interface];
        }
    }];
}

/**********************************************************************************************************/

// 上传数据
- (void)PostUploadImageWithInterface:(NSString *)interface
                          Dictionary:(NSDictionary *)dictionary
                                Info:(NSDictionary *)info
                                Data:(NSData *)data {
    if ([_imageHostUrl isEqualToString:@""]) {
        NSLog(@"缺少image host地址");
        return;
    }
    NSString *postCommand = [_imageHostUrl stringByAppendingString:interface];
//    NSLog(@"\npost request image: %@\n%@\n%@", postCommand, dictionary, info);
    NSLog(@"\npost request image: %@\n%@", postCommand, dictionary);
    
    NSString *dataName = info[@"data_name"];    // @"img"
    NSString *fileName = info[@"file_name"];    // @"1234.jpg"
    NSString *mimeType = info[@"mime_type"];    // @"image/jpeg"
                                                // @"audio/mpeg" MP3
    
    NSMutableURLRequest *request
    = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST"
                                                                 URLString:postCommand
                                                                parameters:dictionary
                                                 constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                     [formData appendPartWithFileData:data
                                                                                 name:dataName
                                                                             fileName:fileName
                                                                             mimeType:mimeType];
                                                 } error:nil];
    
    NSURLSessionConfiguration *urlsession = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:urlsession];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer = serializer;
    
    // 调用开始
    if ([_ApiDelegate respondsToSelector:@selector(requestStartWithInterface:)]) {
        [_ApiDelegate requestStartWithInterface:interface];
    }
    
    NSURLSessionUploadTask *uploadTask
    = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress *uploadProgress) {
        NSInteger progress = (NSInteger)uploadProgress.fractionCompleted * 100;
        //NSLog(@"progress: %d%%", (int)progress);
        // 进度百分比
        if ([self->_ApiDelegate respondsToSelector:@selector(requestProgress:interface:)]) {
            [self->_ApiDelegate requestProgress:progress interface:interface];
        }
    } completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            // 错误信息
            if ([self->_ApiDelegate respondsToSelector:@selector(requestFailedWithError:interface:)] ) {
                [self->_ApiDelegate requestFailedWithError:error interface:interface];
            }
        } else if (responseObject) {
            // 返回信息
            NSDictionary *uInfo = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:0 error:nil];
            if ([self->_ApiDelegate respondsToSelector:@selector(requestFinishedWithCallBackInfo:interface:)] ) {
                [self->_ApiDelegate requestFinishedWithCallBackInfo:uInfo interface:interface];
            }
        }
    }];
    
    [uploadTask resume];
}

/**********************************************************************************************************/

// 发送服务器DownloadFile请求
- (void)DownloadFileWithInterface:(NSString *)interface {
    if ([_hostUrl isEqualToString:@""]) {
        NSLog(@"缺少host地址");
        return;
    }
    NSString *downloadCommand = [_hostUrl stringByAppendingString:interface];
    NSLog(@"\ndownload request : %@", downloadCommand);
    NSURL *downloadUrl = [NSURL URLWithString:downloadCommand];
    
    // AFN3.0 基于封住URLSession的句柄
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    // 请求
    NSURLRequest *request = [NSURLRequest requestWithURL:downloadUrl];
    // 调用开始
    if ([_ApiDelegate respondsToSelector:@selector(requestStartWithInterface:)]) {
        [_ApiDelegate requestStartWithInterface:interface];
    }
    
    // 下载Task操作
    _downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * downloadProgress) {
        
        // @property int64_t totalUnitCount;     需要下载文件的总大小
        // @property int64_t completedUnitCount; 当前已经下载的大小
        
        NSInteger progress = (NSInteger)downloadProgress.fractionCompleted * 100;
        //NSLog(@"progress: %d%%", (int)progress);
        if ([self->_ApiDelegate respondsToSelector:@selector(requestProgress:interface:)]) {
            [self->_ApiDelegate requestProgress:progress interface:interface];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 设置进度条的百分比
        });
        
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        // block的返回值, 要求返回一个URL, 返回的这个URL就是文件的位置的路径
        
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:path];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        // 设置下载完成操作
        // filePath就是你下载文件的位置，你可以解压，也可以直接拿来使用
        NSDictionary *info = [NSDictionary dictionaryWithObject:[filePath path] forKey:@"FilePath"];
        
        if ([self->_ApiDelegate respondsToSelector:@selector(requestFinishedWithCallBackInfo:interface:)] ) {
            [self->_ApiDelegate requestFinishedWithCallBackInfo:info interface:interface];
        }
    }];
}

/**********************************************************************************************************/

// 创建可取消的下载任务
- (void)cancellableDownloadWithInterface:(NSString *)interface infoPath:(NSString *)infoPath {
    if (_cancellableTask == nil) {
        if (_currentSession == nil) {
            [self createCurrentSession];
        }
        
        if ([_imageHostUrl isEqualToString:@""]) {
            NSLog(@"缺少image host地址");
            return;
        }
        NSString *downloadCommand = [_imageHostUrl stringByAppendingPathComponent:interface];
        NSLog(@"\n cancellable download request : %@", downloadCommand);
        NSString *suffix  = [[interface lastPathComponent] pathExtension];
        if ([_defaultIcon isEqualToString:@""]) {
            NSLog(@"缺少default icon名");
            return;
        }

        _downloadedFile   = [_defaultIcon stringByAppendingPathExtension:suffix];
        _downloadedFolder = infoPath;
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:downloadCommand]];
        _cancellableTask = [_currentSession downloadTaskWithRequest:request];
        _downloadedImage = nil;
        
        [_cancellableTask resume];
    }
}

/* 创建当前的session */
- (void)createCurrentSession {
    NSURLSessionConfiguration *defaultConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    _currentSession = [NSURLSession sessionWithConfiguration:defaultConfig delegate:self delegateQueue:nil];
}

/* 取消当前的session */
- (void)cancelCurrentSession {
    if (_cancellableTask) {
        [_cancellableTask cancel];
        _cancellableTask = nil;
    }
}

/**********************************************************************************************************/

// 创建可恢复的下载任务
- (void)resumableDownloadWithInterface:(NSString *)interface {}

// 创建后台下载任务
- (void)backgroundDownloadWithInterface:(NSString *)interface {}

// 取消所有下载任务
- (void)cancelDownloadTask {}

/**********************************************************************************************************/

// 开始后台下载
- (void)startBackgroundSessionWithInterface:(NSString *)interface {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:interface]];
    _backgroundTask = [self.backgroundSession downloadTaskWithRequest:request];

    // Start the download
    [_backgroundTask resume];
}

// 后台会话
- (NSURLSession *)backgroundSession {
    static NSURLSession *backgroundSession = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *ident = @"sweetLawyerForLawyer.BackgroundSession";
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:ident];
        backgroundSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    });
    return backgroundSession;
}

/**********************************************************************************************************/

#pragma mark - NSURLSessionDownloadDelegate methods

// 下载百分比
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
    double currentProgress = totalBytesWritten / (double)totalBytesExpectedToWrite;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Did Write %.f%%", currentProgress * 100);
    });
}

// 续传百分比
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes {

    double currentProgress = fileOffset / (double)expectedTotalBytes;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Did Resume %.f%%", currentProgress * 100);
    });
}

// 完成下载
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    
    // We've successfully finished the download. Let's save the file
    //NSString *filePath = [_downloadedFolder stringByAppendingPathComponent:_downloadedFile];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    
    // Make sure we overwrite anything that's already there
    NSURL *documentsDirectory = [fm URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask][0];
    NSURL *destinationPath = [documentsDirectory URLByAppendingPathComponent:[location lastPathComponent]];
    [fm removeItemAtURL:destinationPath error:nil];
    BOOL success = [fm copyItemAtURL:location toURL:destinationPath error:&error];
    if (success == NO) {
        NSLog(@"download file failure: %@", error);
        return;
    }   // 首先文件会被下载到应用目录，并以tmp文件的形式保存在本地
    
    NSData *fileData = [NSData dataWithContentsOfURL:destinationPath];
    NSString *filePath = [_downloadedFolder stringByAppendingPathComponent:_downloadedFile];
    if ([fm fileExistsAtPath:filePath]) {
        [fm removeItemAtPath:filePath error:nil];
    }
    NSDictionary *attributes = [NSDictionary dictionary];
    BOOL createOk = [fm createFileAtPath:filePath contents:fileData attributes:attributes];
    if (createOk == NO) {
        NSLog(@"create file failure : %@", attributes);
        return;
    }   // 通过读取临时文件，生成相应的本地文件，存放到本地文件夹
    
    // Make sure we overwrite anything that's already there
    [fm removeItemAtURL:destinationPath error:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Destiself->nation Path: %@", self->_downloadedFolder);
//        NSNotificationCenter *cent = [NSNotificationCenter defaultCenter];
//        [cent postNotificationName:UpdateThumbImage object:nil];        // 发送通知消息，告知图片文件已经可以显示
    });
    
    if ([_ApiDelegate respondsToSelector:@selector(requestFinishedWithCallBackInfo:interface:)] ) {
        [_ApiDelegate requestFinishedWithCallBackInfo:nil interface:_downloadedFolder];
    }
    
    if (downloadTask == _cancellableTask) {
        _cancellableTask = nil;
    } else if (downloadTask == _resumableTask) {
        _resumableTask = nil;
        _partialData = nil;
    } else if (session == self.backgroundSession) {
        _backgroundTask = nil;
        // Get hold of the app delegate
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (app.backgroundURLSessionCompletionHandler) {
            // Need to copy the completion handler
            void (^handler)(void) = app.backgroundURLSessionCompletionHandler;
            app.backgroundURLSessionCompletionHandler = nil;
            handler();
        }
    }
}

// 完成并错误
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error == nil) { return; }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Failure: %@", error);
    });
}

// 取消所有任务
- (void)cancelAllOperations {
    if (_manager) {
        [_manager.operationQueue cancelAllOperations];
        NSLog(@"Cancel All Operations!");
    }
    _manager = nil;
}

@end
