//
//  WATabBarController.m
//  WAToken
//
//  Created by dizhihao on 2018/5/25.
//  Copyright © 2018 dizhihao. All rights reserved.
//

#import "WATabBarController.h"
#import "WATabBar.h"

#import "WAMainPageVC.h"

#import "WAServer.h"

@interface WATabBarController () <UITabBarControllerDelegate, UITabBarDelegate>

@property (nonatomic, strong) WATabBar   *wTabBar;
@property (nonatomic, assign) NSUInteger wSelectedIndex;  // 选中的item

@property (nonatomic, strong) WAMainPageVC *vc1;
@property (nonatomic, strong) UIViewController *vc2;
@property (nonatomic, strong) UIViewController *vc3;
@property (nonatomic, strong) UIViewController *vc4;
@property (nonatomic, strong) UIViewController *vc5;

@end

@implementation WATabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTab];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"=== WATabBarController ===");
}

- (void)initTab {
    // 图标色彩和文字设置
    //    NSDictionary *nAttr = [Utilities textAttributesWithFontSize:11.0f bold:YES color:0x444444 alpha:1.0f];
        NSDictionary *sAttr = [Utilities textAttributesWithFontSize:11.0f bold:YES color:THEME_BLUE alpha:1.0f];
    //    [[UITabBarItem appearance] setTitleTextAttributes:nAttr forState:UIControlStateNormal];
        [[UITabBarItem appearance] setTitleTextAttributes:sAttr forState:UIControlStateSelected];
    
    _vc1 = [[WAMainPageVC alloc] init];
    [self addChildViewController:_vc1
                           title:@"首页"
                           image:[UIImage imageNamed:@"tab_ico_file_up"]
                  selecetedImage:[UIImage imageNamed:@"tab_ico_file_dn"]
                             tag:1];
    
    
    _vc2 = [[UIViewController alloc] init];
    _vc2.view.backgroundColor = [UIColor orangeColor];
    [self addChildViewController:_vc2
                           title:@"传输"
                           image:[UIImage imageNamed:@"tab_ico_ablum_up"]
                  selecetedImage:[UIImage imageNamed:@"tab_ico_ablum_dn"]
                             tag:2];
    
    _vc3 = [[UIViewController alloc] init];
    _vc3.view.backgroundColor = [UIColor yellowColor];
    [self addChildViewController:_vc3
                           title:@""
                           image:[UIImage imageNamed:@""]
                  selecetedImage:[UIImage imageNamed:@""]
                             tag:3];
    
    _vc4 = [[UIViewController alloc] init];
    _vc4.view.backgroundColor = [UIColor greenColor];
    [self addChildViewController:_vc4
                           title:@"用户"
                           image:[UIImage imageNamed:@"tab_ico_member_up"]
                  selecetedImage:[UIImage imageNamed:@"tab_ico_member_dn"]
                             tag:4];
    
    _vc5 = [[UIViewController alloc] init];
    _vc5.view.backgroundColor = [UIColor blueColor];
    [self addChildViewController:_vc5
                           title:@"更多"
                           image:[UIImage imageNamed:@"tab_ico_more_up"]
                  selecetedImage:[UIImage imageNamed:@"tab_ico_more_dn"]
                             tag:5];

    // tabbar
    _wTabBar = [[WATabBar alloc] init];
    [_wTabBar.centerBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    // 透明设置为NO，显示白色，view的高度到tabbar顶部截止，YES的话到底部
    _wTabBar.translucent = NO;
    // 利用KVC 将自己的tabbar赋给系统tabBar
    [self setValue:_wTabBar forKeyPath:@"tabBar"];
    
    self.wSelectedIndex = 0; // 默认选中第一个
    self.delegate = self;
    
}

// 添加子页面
- (void)addChildViewController:(UIViewController *)vc
                         title:(NSString *)title
                         image:(UIImage *)uImage
                selecetedImage:(UIImage *)sImage
                           tag:(NSInteger)tag {
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:nil tag:tag];
    [vc.tabBarItem setImage:[uImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [vc.tabBarItem setSelectedImage:[sImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    UIOffset offset = UIOffsetMake(4.0f, -6.0f);
    [vc.tabBarItem setTitlePositionAdjustment:offset];
    [self addChildViewController:vc];
}

/*****************************************************************************************************/

#pragma mark - delegate

// 选择控制
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    NSUInteger tag = viewController.tabBarItem.tag;
    // 如果点击中间按钮下方空白，不予跳转
    if (tag == 3) {
        self.selectedIndex = self.wSelectedIndex;
    } else {
        self.wSelectedIndex= self.selectedIndex;
    }
}

/*****************************************************************************************************/

#pragma mark - button action

// 添加按钮
- (void)buttonAction:(UIButton *)sender {
    NSLog(@"middle");
}



@end
