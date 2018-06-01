//
//  WAWebUrlVC.m
//  WAToken
//
//  Created by dizhihao on 2018/5/31.
//  Copyright © 2018 dizhihao. All rights reserved.
//

#import "WAWebUrlVC.h"

#import "WATabBarController.h"

@interface WAWebUrlVC ()

@property (weak, nonatomic) IBOutlet UIButton *pasteBtn;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation WAWebUrlVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"url: %@", self.strUrl);
    
    self.textView.layer.cornerRadius = 5.0f;
    self.textView.layer.masksToBounds = YES;
    self.textView.text = self.strUrl;
    
    self.pasteBtn.layer.cornerRadius = 5.0f;
    self.pasteBtn.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.textView addObserver:self
                    forKeyPath:@"contentSize"
                       options:NSKeyValueObservingOptionNew
                       context:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"=== WAQRCodeScanVC ===");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.textView removeObserver:self forKeyPath:@"contentSize"];
}

/*****************************************************************************************************/

#pragma mark - observer

// textview 垂直居中
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
        UITextView *tv = object;
        CGFloat deadSpace = ([tv bounds].size.height - [tv contentSize].height);
        CGFloat inset = MAX(0, deadSpace/2.0f);
        tv.contentInset = UIEdgeInsetsMake(inset, tv.contentInset.left, inset, tv.contentInset.right);
    }
}

/*****************************************************************************************************/

#pragma mark - button action

// 跳转
- (IBAction)gotoBrowser:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.strUrl]];
}

// 复制到剪贴板
- (IBAction)tapForCopy:(UIButton *)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.textView.text;
    [self warningMessage:@"已经复制到剪贴板" action:nil];
}

// 返回
- (IBAction)tapBack:(UIButton *)sender {
    [self gotoMainVC];
}

// 返回到主页面
- (void)gotoMainVC {
    for (id vc in self.navigationController.viewControllers) {
        //        NSLog(@"%@", vc);
        if ([vc isKindOfClass:[WATabBarController class]]) {
            [self.navigationController popToViewController:vc animated:NO];
        }
    }
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


@end
