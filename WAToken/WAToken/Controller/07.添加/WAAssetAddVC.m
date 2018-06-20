//
//  WAAssetAddVC.m
//  WAToken
//
//  Created by dizhihao on 2018/6/13.
//  Copyright © 2018 dizhihao. All rights reserved.
//

#import "WAAssetAddVC.h"

#import "HyPopMenuView.h"

#import "WAServer.h"

@interface WAAssetAddVC () <HyPopMenuViewDelegate>

@property (nonatomic, strong) HyPopMenuView *menu;

@property (weak, nonatomic) IBOutlet UIImageView *animationView;

@end

@implementation WAAssetAddVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"=== WAAssetAddVC ===");
    [self initUI];
    [self animateToStart];
}

- (void)initUI {
    PopMenuModel *m1 = [PopMenuModel
                        allocPopMenuModelWithImageNameString:@"btn_album"
                        AtTitleString:@"相册/视频"
                        AtTextColor:[UIColor grayColor]
                        AtTransitionType:PopMenuTransitionTypeSystemApi
                        AtTransitionRenderingColor:nil];
    
    PopMenuModel *m2 = [PopMenuModel
                        allocPopMenuModelWithImageNameString:@"btn_camera"
                        AtTitleString:@"拍摄/短视频"
                        AtTextColor:[UIColor grayColor]
                        AtTransitionType:PopMenuTransitionTypeCustomizeApi
                        AtTransitionRenderingColor:nil];
    
    PopMenuModel *m3 = [PopMenuModel
                        allocPopMenuModelWithImageNameString:@"btn_more"
                        AtTitleString:@"更多"
                        AtTextColor:[UIColor grayColor]
                        AtTransitionType:PopMenuTransitionTypeSystemApi
                        AtTransitionRenderingColor:nil];
    
    _menu = [HyPopMenuView sharedPopMenuManager];
    _menu.dataSource = @[m1, m2, m3];
    _menu.delegate = self;
    _menu.popMenuSpeed = 12.0f;
    _menu.automaticIdentificationColor = NO;
    _menu.animationType = HyPopMenuViewAnimationTypeSina;
    _menu.backgroundType = HyPopMenuViewBackgroundTypeDarkBlur;
}

/************************************************************************************************/

#pragma mark - animation

// 动画开始
- (void)animateToStart {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5f];
    _animationView.transform = CGAffineTransformMakeRotation((-0.25f) * M_PI);
    [UIView commitAnimations];
    [_menu openMenu];
}

// 动画结束
- (void)animateToClose {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5f];
    _animationView.transform = CGAffineTransformMakeRotation((0.0f) * M_PI);
    [UIView commitAnimations];
    
    [NSObject performAfterDelay:1.0f withBlock:^{
       [self.navigationController popViewControllerAnimated:NO];
    }];
}

/************************************************************************************************/

#pragma mark - delegate

- (void)popMenuView:(HyPopMenuView *)popMenuView didSelectItemAtIndex:(NSUInteger)index {
    
}

/************************************************************************************************/

#pragma mark - button action

// 退出
- (IBAction)tapBack:(UIButton *)sender {
    [self animateToClose];
}

@end
