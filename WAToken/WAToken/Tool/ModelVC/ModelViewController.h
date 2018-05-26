//
//  ModelViewController.h
//  KingOfUnrar
//
//  Created by dizhihao on 15/10/23.
//  Copyright © 2015年 dizhihao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworkApi.h"
#import "UIImageView+AFNetworking.h"
#import "DzhProcessHUD.h"


// 系统配置
#import "Defines.h"
#import "Interfaces.h"
#import "MyDevice.h"
#import "Utilities.h"


// 类型扩展
#import "NSDate+TimeInterval.h"
#import "NSObject+PerformBlockAfterDelay.h"
#import "NSString+Trimming.h"
#import "UIColor+Art.h"
#import "UIImage+Extension.h"


// 总类单例
#import "WAServer.h"


@class ModelViewController;
@protocol DeviceRotatationDelegate <NSObject>

// 设备正在旋转
- (void)DeviceDidRotatedAtState:(NSInteger)state;

@end


typedef void (^CallBack)(id obj);


@interface ModelViewController : UIViewController

@property (nonatomic, strong)   id<DeviceRotatationDelegate> rotatationDelegate;    // 委托对象
@property (nonatomic, assign)   NSInteger devicePortraitState;                      // 设备旋转状态
@property (nonatomic, strong)   AFNetworkApi *myApi;


/*******************************************************************************************************************/

// 网络状态
- (BOOL)networkIsReachable;

// 创建网络请求（调用网络接口）
- (void)createGetRequest:(NSString *)interface parameters:(NSDictionary *)parameters;

// 创建网络请求（调用网络接口）
- (void)createPostRequest:(NSString *)interface parameters:(NSDictionary *)parameters;

// 取消调用网络请求
- (void)cancelAllRequests;

// 创建上传图片接口
- (void)createPostUploadImageRequest:(NSString *)interface parameters:(NSDictionary *)parameters data:(NSData *)data;

// 创建可取消的下载任务
- (void)cancellableDownloadWithInterface:(NSString *)interface filePath:(NSString *)filePath;

// 网络请求相关回调:
// 回调开始
- (void)requestStartWithInterface:(NSString *)interface;

// 请求进度
- (void)requestProgress:(NSInteger)progress interface:(NSString *)interface;

// 回调结果
- (void)requestFinishedWithCallBackInfo:(NSDictionary *)info interface:(NSString *)interface;

// 错误信息
- (void)requestFailedWithError:(NSError *)error interface:(NSString *)interface;

/*******************************************************************************************************************/

// 返回
- (void)tapBack;

/*******************************************************************************************************************/

// 弹窗警告
- (void)warningMessage:(NSString *)message;

// 弹窗后跳转
- (void)warningThenBackWithMessage:(NSString *)message;

// 弹窗后执行
- (void)warningMessage:(NSString *)message target:(id)aTarget selector:(SEL)aSel;


/*******************************************************************************************************************/



@end

