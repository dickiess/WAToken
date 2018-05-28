//
//  WAQRCodeScanVC.m
//  WAToken
//
//  Created by dizhihao on 2018/5/28.
//  Copyright © 2018 dizhihao. All rights reserved.
//

#import "WAQRCodeScanVC.h"
#import "SGQRCode.h"

#import "WAServer.h"

@interface WAQRCodeScanVC () <SGQRCodeScanManagerDelegate, SGQRCodeAlbumManagerDelegate>

@property (nonatomic, strong) SGQRCodeScanManager *manager;
@property (nonatomic, strong) SGQRCodeScanningView *scanningView;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, copy)   NSString  *scanResult;

@end

@implementation WAQRCodeScanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"=== WAQRCodeScanVC ===");

    [self initNavigationBar];
    
    UIImagePickerControllerSourceType sourType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:sourType] == NO) {
        [self warningMessage:@"该设备不支持摄像头"];
    } else {
        [self setupQRCodeScanning];
    }
    [self.scanningView addTimer];
    [self.manager startRunning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.scanningView removeTimer];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)dealloc {
//    NSLog(@"WBQRCodeScanningVC - dealloc");
    [self removeScanningView];
}

/*****************************************************************************************************/

- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.scanningView];
    [self.view addSubview:self.promptLabel];
}

// 扫描镜头
- (SGQRCodeScanningView *)scanningView {
    if (_scanningView == nil) {
        _scanningView = [[SGQRCodeScanningView alloc] initWithFrame:FULL_FRAME];
        _scanningView.scanningImageName = @"SGQRCode.bundle/QRCodeScanningLineGrid";
        _scanningView.scanningAnimationStyle = ScanningAnimationStyleGrid;
        _scanningView.cornerColor = [UIColor orangeColor];
    }
    return _scanningView;
}

// 提示文字
- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.backgroundColor = [UIColor clearColor];
        CGFloat promptLabelX = 0;
        CGFloat promptLabelY = 0.73 * FULL_SCREEN.height;
        CGFloat promptLabelW = FULL_SCREEN.width;
        CGFloat promptLabelH = 25;
        _promptLabel.frame = CGRectMake(promptLabelX, promptLabelY, promptLabelW, promptLabelH);
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.font = [UIFont boldSystemFontOfSize:13.0];
        _promptLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        _promptLabel.text = @"将二维码/条码放入框内, 即可自动扫描";
    }
    return _promptLabel;
}

// 导航栏初始化
- (void)initNavigationBar {
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = @"扫一扫";
    self.navigationItem.rightBarButtonItem
    = [[UIBarButtonItem alloc] initWithTitle:@"相册"
                                       style:(UIBarButtonItemStyleDone)
                                      target:self
                                      action:@selector(rightBarButtonItemAction:)];
}

/*****************************************************************************************************/

- (void)setupQRCodeScanning {
    if (_manager == nil) {
        _manager = [SGQRCodeScanManager sharedManager];
        NSArray *arr = @[AVMetadataObjectTypeQRCode,
                         AVMetadataObjectTypeEAN13Code,
                         AVMetadataObjectTypeEAN8Code,
                         AVMetadataObjectTypeCode128Code];
        // AVCaptureSessionPreset1920x1080 推荐使用，对于小型的二维码读取率较高
        [_manager setupSessionPreset:AVCaptureSessionPreset1920x1080
                 metadataObjectTypes:arr
                   currentController:self];
        [_manager cancelSampleBufferDelegate];
    }
    _manager.delegate = self;
}

// 移除扫描镜头
- (void)removeScanningView {
    [self.scanningView removeTimer];
    [self.scanningView removeFromSuperview];
    self.scanningView = nil;
    [self.promptLabel removeFromSuperview];
    self.promptLabel = nil;
}

/*****************************************************************************************************/

#pragma mark -- SGQRCodeAlbumManagerDelegate

- (void)QRCodeAlbumManagerDidCancelWithImagePickerController:(SGQRCodeAlbumManager *)albumManager {
    [self.view addSubview:self.scanningView];
}

// 照片扫描结果
- (void)QRCodeAlbumManager:(SGQRCodeAlbumManager *)albumManager didFinishPickingMediaWithResult:(NSString *)result {
    if ([result hasPrefix:@"http"]) {
        NSLog(@"url: %@", result);
    } else {
        NSLog(@"rlt: %@", result);
    }
}

- (void)QRCodeAlbumManagerDidReadQRCodeFailure:(SGQRCodeAlbumManager *)albumManager {
    NSLog(@"暂未识别出二维码");
    [self warningMessage:@"暂未识别出二维码"];
}

/*****************************************************************************************************/

#pragma mark -- SGQRCodeScanManagerDelegate

- (void)QRCodeScanManager:(SGQRCodeScanManager *)scanManager didOutputMetadataObjects:(NSArray *)metadataObjects {
//    NSLog(@"metadataObjects - - %@", metadataObjects);
    if (metadataObjects != nil && metadataObjects.count > 0) {
        [scanManager playSoundName:@"SGQRCode.bundle/sound.caf"];
        [scanManager stopRunning];
        
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        NSLog(@"mgr: %@", [obj stringValue]);
        NSString *scanResult = [obj stringValue];
        if (scanResult) {
            self.scanResult = scanResult;
        }
    } else {
        NSLog(@"暂未识别出扫描的二维码");
        [self warningMessage:@"暂未识别出扫描的二维码"];
    }
}

/*****************************************************************************************************/

#pragma mark - button action

- (void)rightBarButtonItemAction:(UIBarButtonItem *)sender {
    SGQRCodeAlbumManager *manager = [SGQRCodeAlbumManager sharedManager];
    [manager readQRCodeFromAlbumWithCurrentController:self];
    manager.delegate = self;
    
    if (manager.isPHAuthorization == YES) {
        [self.scanningView removeTimer];
    }
}

/*****************************************************************************************************/

#pragma mark - warning message

// 弹窗警告并返回
- (void)warningMessage:(NSString *)message {
    UIAlertControllerStyle style = UIAlertControllerStyleAlert;
    UIAlertController *alert
    = [UIAlertController alertControllerWithTitle:@"提示:" message:message preferredStyle:style];
    UIAlertActionStyle actionStyle = UIAlertActionStyleDefault;
    UIAlertAction *action
    = [UIAlertAction actionWithTitle:@"关闭"
                               style:actionStyle
                             handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:^{ }];
}

/*****************************************************************************************************/

#pragma mark - status bar style

// 状态栏黑字
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

@end
