//
//  SLMyApis.h
//  faceAD
//
//  Created by dizhihao on 15/7/17.
//  Copyright (c) 2015年 dizhihao. All rights reserved.
//

#import "AFNetworking.h"
#import "Reachability.h"

#define AF_API  [AFNetworkApi sharedInstance]

/************************************************************************************************************/

@protocol ApiDelegate <NSObject>

@optional

// 回调开始
- (void)requestStartWithInterface:(NSString *)interface;

// 请求进度
- (void)requestProgress:(NSInteger)progress interface:(NSString *)interface;

// 回调结果
- (void)requestFinishedWithCallBackInfo:(NSDictionary *)info interface:(NSString *)interface;

// 错误信息
- (void)requestFailedWithError:(NSError *)error interface:(NSString *)interface;

@end

/************************************************************************************************************/

@interface AFNetworkApi : NSObject

@property (nonatomic, copy) NSString  *defaultIcon;
@property (nonatomic, copy) NSString  *hostUrl;
@property (nonatomic, copy) NSString  *imageHostUrl;
@property (nonatomic, weak) id<ApiDelegate> ApiDelegate;

// 初始化
+ (AFNetworkApi *)sharedInstance;

// 网络状态
- (BOOL)isReachable;

// 发送服务器Post请求
- (void)PostWithInterface:(NSString *)interface Dictionary:(NSDictionary *)dictionary;

// 发送服务器Get请求
- (void)GetWithInterface:(NSString *)interface Dictionary:(NSDictionary *)dictionary;

// 上传图片
- (void)PostUploadImageWithInterface:(NSString *)interface
                          Dictionary:(NSDictionary *)dictionary
                                Info:(NSDictionary *)info
                                Data:(NSData *)data;

// 创建可取消的下载任务
- (void)cancellableDownloadWithInterface:(NSString *)interface infoPath:(NSString *)infoPath;

// 创建可恢复的下载任务
- (void)resumableDownloadWithInterface:(NSString *)interface;

// 创建后台下载任务
- (void)backgroundDownloadWithInterface:(NSString *)interface;

// 取消所有下载任务
- (void)cancelDownloadTask;

// 开始后台下载
- (void)startBackgroundSessionWithInterface:(NSString *)interface;

// 取消所有任务
- (void)cancelAllOperations;


@end


