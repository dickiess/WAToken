//
//  SGWiFiViewController.m
//  SGWiFiUpload
//
//  Created by soulghost on 30/6/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGWiFiViewController.h"
#import "SGWiFiView.h"
#import "HTTPServer.h"
#import "HYBIPHelper.h"
#import "SGWiFiUploadManager.h"
//#import "RichLanguage.h"

@interface SGWiFiViewController ()

@property (nonatomic, weak) SGWiFiView *wifiView;

@end

@implementation SGWiFiViewController

- (void)loadView {
    SGWiFiView *wifiView = [SGWiFiView new];
    self.wifiView = wifiView;
    self.view = wifiView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"WiFi";
    self.navigationItem.rightBarButtonItem
    = [[UIBarButtonItem alloc] initWithTitle:@"关闭"
                                       style:UIBarButtonItemStylePlain
                                      target:self action:@selector(dismiss)];
//    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    UIColor *fColor = [UIColor whiteColor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:fColor}];
    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view setNeedsDisplay];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    SGWiFiUploadManager *mgr = [SGWiFiUploadManager sharedManager];
    HTTPServer *server = mgr.httpServer;
    if (server.isRunning) {
        if ([HYBIPHelper deviceIPAdress] == nil) {
            [self.wifiView setAddress:@"Error, your Device is not connected to WiFi"];
            return;
        }
        NSString *ip_port = [NSString stringWithFormat:@"http://%@:%@",mgr.ip,@(mgr.port)];
        [self.wifiView setAddress:ip_port];
    } else {
        [self.wifiView setAddress:@"Error, Server Stopped"];
    }
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

/*************************************************************************************************************/

// 状态栏文字变白
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
