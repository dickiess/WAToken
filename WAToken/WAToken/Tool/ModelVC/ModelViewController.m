//
//  ModelViewController.m
//  KingOfUnrar
//
//  Created by dizhihao on 15/10/23.
//  Copyright © 2015年 dizhihao. All rights reserved.
//

#import "ModelViewController.h"

@interface ModelViewController () <ApiDelegate, UIGestureRecognizerDelegate>

@end

@implementation ModelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _myApi = AF_API;
    _myApi.defaultIcon = MY_ICON;
    _myApi.hostUrl = HOST_URL;
    _myApi.imageHostUrl = IMAGE_URL;
    
    [self initGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSNotificationCenter *cent = [NSNotificationCenter defaultCenter];
    SEL aSel = @selector(handleDeviceOrientationDidChange:);
    [cent addObserver:self selector:aSel name:UIDeviceOrientationDidChangeNotification object:nil];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSNotificationCenter *cent = [NSNotificationCenter defaultCenter];
    [cent removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    
    _rotatationDelegate = nil;
    
    // 取消所有网络请求
    [self cancelAllRequests];
}

- (void)initGestureRecognizer {
    
    // 向右划
    UISwipeGestureRecognizer *recognizer
    = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:recognizer];
    
    // 向左划
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [[self view] addGestureRecognizer:recognizer];
    
    // 向上划
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [[self view] addGestureRecognizer:recognizer];

    // 向下划
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [[self view] addGestureRecognizer:recognizer];
}

/****************************************************************************************************************/

// 设备旋转
- (NSInteger)handleDeviceOrientationDidChange:(UIInterfaceOrientation)interfaceOrientation {
    // 宣告一個UIDevice指標，並取得目前Device的方向
    UIDevice *device = [UIDevice currentDevice] ;
    _devicePortraitState = device.orientation;
    
    // 取得當前Device的方向，來當作判斷敘述。（Device的方向型態為Integer）
    //    switch (device.orientation) {
    //        case UIDeviceOrientationFaceUp:
    //            NSLog(@"螢幕朝上平躺");
    //            break;
    //
    //        case UIDeviceOrientationFaceDown:
    //            NSLog(@"螢幕朝下平躺");
    //            break;
    //
    //            //系統無法判斷目前Device的方向，有可能是斜置
    //        case UIDeviceOrientationUnknown:
    //            NSLog(@"未知方向");
    //            break;
    //
    //        case UIDeviceOrientationLandscapeLeft:
    //            NSLog(@"螢幕向左橫置");
    //            break;
    //
    //        case UIDeviceOrientationLandscapeRight:
    //            NSLog(@"螢幕向右橫置");
    //            break;
    //
    //        case UIDeviceOrientationPortrait:
    //            NSLog(@"螢幕直立");
    //            break;
    //
    //        case UIDeviceOrientationPortraitUpsideDown:
    //            NSLog(@"螢幕直立，上下顛倒");
    //            break;
    //
    //        default:
    //            NSLog(@"無法辨識");
    //            break;
    //    }
    
    if ([_rotatationDelegate respondsToSelector:@selector(DeviceDidRotatedAtState:)]) {
        [_rotatationDelegate DeviceDidRotatedAtState:device.orientation];
    }
    
    return device.orientation;
}

// 手势划动
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
    
    switch (recognizer.direction) {
        case UISwipeGestureRecognizerDirectionDown: {
            NSLog(@"swipe down");
        } break;
            
        case UISwipeGestureRecognizerDirectionUp: {
            NSLog(@"swipe up");
        } break;
            
        case UISwipeGestureRecognizerDirectionLeft: {
            NSLog(@"swipe left");
        } break;
            
        case UISwipeGestureRecognizerDirectionRight: {
            NSLog(@"swipe right");
        } break;
            
        default: break;
    }
}

/****************************************************************************************************************/

// 网络状态
- (BOOL)networkIsReachable {
    return [_myApi isReachable];
}

// 创建网络请求（调用网络接口）
- (void)createGetRequest:(NSString *)interface parameters:(NSDictionary *)parameters {
    _myApi.ApiDelegate = self;
    [_myApi GetWithInterface:interface Dictionary:parameters];
}

// 创建网络请求（调用网络接口）
- (void)createPostRequest:(NSString *)interface parameters:(NSDictionary *)parameters {
    _myApi.ApiDelegate = self;
    [_myApi PostWithInterface:interface Dictionary:parameters];
}

// 取消调用网络请求
- (void)cancelAllRequests {
    [_myApi cancelAllOperations];
}

// 创建上传图片接口
- (void)createPostUploadImageRequest:(NSString *)interface parameters:(NSDictionary *)parameters data:(NSData *)data {
    _myApi.ApiDelegate = self;
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"img" forKey:@"data_name"];
    [info setObject:@"1234.jpg" forKey:@"file_name"];
    [info setObject:@"image/jpeg" forKey:@"mime_type"];
    [_myApi PostUploadImageWithInterface:interface
                              Dictionary:parameters
                                    Info:[NSDictionary dictionaryWithDictionary:info]
                                    Data:data];
}

// 创建可取消的下载任务
- (void)cancellableDownloadWithInterface:(NSString *)interface filePath:(NSString *)filePath {
    _myApi.ApiDelegate = self;
    [_myApi cancellableDownloadWithInterface:interface infoPath:filePath];
}

/****************************************************************************************************************/


// 网络请求相关回调
// 回调开始
- (void)requestStartWithInterface:(NSString *)interface { }

// 请求进度
- (void)requestProgress:(NSInteger)progress interface:(NSString *)interface { }

// 回调结果
- (void)requestFinishedWithCallBackInfo:(NSDictionary *)info interface:(NSString *)interface { }

// 错误信息
- (void)requestFailedWithError:(NSError *)error interface:(NSString *)interface { }

/*******************************************************************************************************************/


#pragma mark - button actions

// 返回
- (void)tapBack {
    [self.navigationController popViewControllerAnimated:YES];
}

/*******************************************************************************************************************/


#pragma mark - warning message

// 弹窗警告
- (void)warningMessage:(NSString *)message {
    UIAlertControllerStyle style = UIAlertControllerStyleAlert;
    UIAlertController *alert
    = [UIAlertController alertControllerWithTitle:@"提示:" message:message preferredStyle:style];
    UIAlertActionStyle actionStyle = UIAlertActionStyleDefault;
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"关闭" style:actionStyle handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:^{ }];
}

// 弹窗后跳转
- (void)warningThenBackWithMessage:(NSString *)message {
    UIAlertControllerStyle style = UIAlertControllerStyleAlert;
    UIAlertController *alert
    = [UIAlertController alertControllerWithTitle:@"提示:" message:message preferredStyle:style];
    UIAlertActionStyle actionStyle = UIAlertActionStyleDefault;
    UIAlertAction *action
    = [UIAlertAction actionWithTitle:@"关闭" style:actionStyle handler:^(UIAlertAction *action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:^{ }];
}

// 弹窗后执行
- (void)warningMessage:(NSString *)message target:(id)aTarget selector:(SEL)aSel {
    UIAlertControllerStyle style = UIAlertControllerStyleAlert;
    UIAlertController *alert
    = [UIAlertController alertControllerWithTitle:@"提示:" message:message preferredStyle:style];
    UIAlertActionStyle actionStyle = UIAlertActionStyleDefault;
    
    UIAlertAction *action1
    = [UIAlertAction actionWithTitle:@"取消" style:actionStyle handler:^(UIAlertAction *action) { }];
    [alert addAction:action1];
    
    actionStyle = UIAlertActionStyleDefault;
    UIAlertAction *action2
    = [UIAlertAction actionWithTitle:@"确定" style:actionStyle handler:^(UIAlertAction *action) {
        [aTarget performSelectorOnMainThread:aSel withObject:nil waitUntilDone:YES];
    }];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:^{ }];
}


@end
