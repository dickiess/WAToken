//
//  WAMainPageVC.m
//  WAToken
//
//  Created by dizhihao on 2018/5/28.
//  Copyright © 2018 dizhihao. All rights reserved.
//

#import "WAMainPageVC.h"
#import "WAQRCodeScanVC.h"
#import "WASettingVC.h"

#import "WAWideGridButton.h"
#import "WATitleGridButton.h"
#import "WAGridButton.h"

#import "WAServer.h"

@interface WAMainPageVC ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) WAWideGridButton  *btn1;

@property (strong, nonatomic) WATitleGridButton *btn11;
@property (strong, nonatomic) WATitleGridButton *btn12;
@property (strong, nonatomic) WATitleGridButton *btn13;

@property (strong, nonatomic) WAGridButton *btn21;
@property (strong, nonatomic) WAGridButton *btn22;
@property (strong, nonatomic) WAGridButton *btn23;
@property (strong, nonatomic) WAGridButton *btn24;
@property (strong, nonatomic) WAGridButton *btn25;
@property (strong, nonatomic) WAGridButton *btn26;
@property (strong, nonatomic) WAGridButton *btn27;
@property (strong, nonatomic) WAGridButton *btn28;
@property (strong, nonatomic) WAGridButton *btn29;

@property (weak, nonatomic) IBOutlet UIStepper *stepper;

@end

/*****************************************************************************************************/

@implementation WAMainPageVC

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
    
    NSLog(@"=== WAMainPageVC ===");
    [self fakeData];
}

// 视图布局
- (void)initUI {
    // 基本数据
    CGFloat w = FULL_SCREEN.width / 3;
    CGFloat h = w;
    CGFloat gap = 13;
    
    // scrollview
    CGSize sSize = FULL_SCREEN;
    sSize.height = h*(2+3)+gap*2;
    _scrollView.contentSize = sSize;
    
    //
    CGPoint pt = CGPointMake(w*0, h*0+gap*1);
    [self addButton:_btn1 title:@"" subTitle:@"" process:0.0f point:pt index:10];
    
    // title button
    pt = CGPointMake(w*0, h*1+gap*1);
    [self addButton:_btn11 title:@"正常" subTitle:@"设备管理" point:pt index:11];

    pt = CGPointMake(w*1, h*1+gap*1);
    [self addButton:_btn12 title:@"1025" subTitle:@"CBC积分" point:pt index:12];
    
    pt = CGPointMake(w*2, h*1+gap*1);
    [self addButton:_btn13 title:@"1人" subTitle:@"成员管理" point:pt index:13];
    
    // grid button
    pt = CGPointMake(w*0, h*2+gap*2);
    [self addButton:_btn21 image:[UIImage imageNamed:@"ico_backup"] title:@"自动备份"
              point:pt index:21];
    
    pt = CGPointMake(w*1, h*2+gap*2);
    [self addButton:_btn22 image:[UIImage imageNamed:@"ico_download"] title:@"远程下载"
              point:pt index:22];
    
    pt = CGPointMake(w*2, h*2+gap*2);
    [self addButton:_btn23 image:[UIImage imageNamed:@"ico_safe_box"] title:@"保险箱"
              point:pt index:23];
    
    pt = CGPointMake(w*0, h*3+gap*2);
    [self addButton:_btn24 image:[UIImage imageNamed:@"ico_trash_can"] title:@"最近删除"
              point:pt index:24];

    pt = CGPointMake(w*1, h*3+gap*2);
    [self addButton:_btn25 image:[UIImage imageNamed:@"ico_movie"] title:@"我的电影"
              point:pt index:25];

    pt = CGPointMake(w*2, h*3+gap*2);
    [self addButton:_btn26 image:[UIImage imageNamed:@"ico_other_device"] title:@"外接设备"
              point:pt index:26];

    pt = CGPointMake(w*0, h*4+gap*2);
    [self addButton:_btn27 image:[UIImage imageNamed:@"ico_favourite_book"] title:@"我的收藏"
              point:pt index:27];
    
    pt = CGPointMake(w*1, h*4+gap*2);
    [self addButton:_btn28 image:[UIImage imageNamed:@"ico_double_backup"] title:@"双重备份"
              point:pt index:28];
    
    pt = CGPointMake(w*2, h*4+gap*2);
    [self addButton:_btn29 image:[UIImage imageNamed:@""] title:@"" point:pt index:29];
}

// 省力加载按钮
- (void)addButton:(WAWideGridButton *)btn
            title:(NSString *)title
         subTitle:(NSString *)sTitle
          process:(CGFloat)process
            point:(CGPoint)pt
            index:(NSInteger)idx {
    btn = [WAWideGridButton buttonInitWithPoint:pt
                                          title:title
                                       subtitle:sTitle
                                        process:process
                                          index:idx];
    [btn.button addTarget:self
                   action:@selector(buttonAction:)
         forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:btn];
    
    switch (idx) {
        case 10: _btn1 = btn; break;
        default: break;
    }
}

// 省力加载按钮
- (void)addButton:(WATitleGridButton *)btn
            title:(NSString *)title
         subTitle:(NSString *)sTitle
            point:(CGPoint)pt
            index:(NSInteger)idx {
    btn = [WATitleGridButton buttonInitWithPoint:pt
                                           title:title
                                        subtitle:sTitle
                                           index:idx];
    [btn.button addTarget:self
                   action:@selector(buttonAction:)
         forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:btn];
    
    switch (idx) {
        case 11: _btn11 = btn; break;
        case 12: _btn12 = btn; break;
        case 13: _btn13 = btn; break;
        default: break;
    }
}

// 省力加载按钮
- (void)addButton:(WAGridButton *)btn
            image:(UIImage *)image
            title:(NSString *)title
            point:(CGPoint)pt
            index:(NSInteger)idx {
    btn = [WAGridButton buttonInitWithPoint:pt
                                      image:image
                                      title:title
                                      index:idx];
    UIColor *c = [UIColor colorWithHex:0xFFFF00 andAlpha:0.5f];
    [btn.button setBackgroundImage:[UIImage imageWithColor:c size:btn.frame.size]
                          forState:UIControlStateHighlighted];
    [btn.button addTarget:self
                   action:@selector(buttonAction:)
         forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:btn];
    
    switch (idx) {
        case 21: _btn21 = btn; break;
        case 22: _btn22 = btn; break;
        case 23: _btn23 = btn; break;
        case 24: _btn24 = btn; break;
        case 25: _btn25 = btn; break;
        case 26: _btn26 = btn; break;
        case 27: _btn27 = btn; break;
        case 28: _btn28 = btn; break;
        case 29: _btn29 = btn; break;
        default: break;
    }
}

/*****************************************************************************************************/

#pragma mark - button action

- (void)buttonAction:(UIButton *)sender {
    NSInteger tag = sender.tag;
    if (tag <= 10) {

    }
    else if (tag <= 20) {

    }
    else if (tag <= 30) {
        [self warningMessage:@"敬请期待" action:nil];
    }
}

- (IBAction)scanAction:(UIButton *)sender {
    WAQRCodeScanVC *scanVC = [[WAQRCodeScanVC alloc] init];
    [self.navigationController pushViewController:scanVC animated:NO];
}

- (IBAction)setAction:(UIButton *)sender {
    WASettingVC *setVC = [[WASettingVC alloc] init];
    [self.navigationController pushViewController:setVC animated:YES];
}

- (IBAction)tapStepper:(UIStepper *)sender {
    CGFloat rate = _stepper.value;
    _btn1.subtitleLabel.text = [NSString stringWithFormat:@"已用%.2fGB，共%.2fGB", rate*60.0f, 60.0f];
    [_btn1 updateProcess:rate];
}

/*****************************************************************************************************/

#pragma mark - warning message

// 弹窗警告并返回
- (void)warningMessage:(NSString *)message action:(UIAlertAction *)newAction {
    UIAlertControllerStyle style = UIAlertControllerStyleAlert;
    UIAlertController *alert
    = [UIAlertController alertControllerWithTitle:@"提示:" message:message preferredStyle:style];
    
    if (newAction == nil) {
        UIAlertActionStyle actionStyle = UIAlertActionStyleDefault;
        UIAlertAction *action
        = [UIAlertAction actionWithTitle:@"关闭" style:actionStyle handler:^(UIAlertAction *action) {}];
        [alert addAction:action];
    } else {
        [alert addAction:newAction];
    }
    
    [self presentViewController:alert animated:YES completion:^{ }];
}

/*****************************************************************************************************/

#pragma mark - fake data

- (void)fakeData {
    CGFloat rate = _stepper.value;
    _btn1.titleLabel.text = @"WAToken ( Richard 的磁盘空间 )";
    _btn1.subtitleLabel.text = [NSString stringWithFormat:@"已用%.2fGB，共%.2fGB", rate*60.0f, 60.0f];
    [_btn1 updateProcess:rate];
}

@end
