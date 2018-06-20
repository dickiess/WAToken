//
//  WAPullDownMenu.m
//  WAToken
//
//  Created by dizhihao on 2018/6/6.
//  Copyright © 2018 dizhihao. All rights reserved.
//

#import "WAPullDownMenu.h"

#import "UIColor+Art.h"
#import "CALayer+PulldownAnimation.h"


@interface WAPullDownMenu () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView  *backgroundView;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *menuColor;
@property (nonatomic, strong) UIColor *shadowColor;

@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *indicators;
@property (nonatomic, strong) NSArray   *list;

@property (nonatomic, assign) BOOL      hasShown;
@property (nonatomic, assign) NSInteger currentIndex;

@end

/************************************************************************************************/

#define frameHeight  (40.0f)
#define textFont     (15.0f)

/************************************************************************************************/

@implementation WAPullDownMenu

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _backgroundColor = [UIColor whiteColor];
        _shadowColor = HexRGB(0xFF6666);
        _shadow = [self makeShadow];
        [self addSubview:_shadow];
//        [self addSubview:[self makeLine]];
    }
    return self;
}

+ (WAPullDownMenu *)menuWithList:(NSArray *)list position:(CGPoint)pt selectedColor:(UIColor *)color {
    CGRect rect = CGRectMake(pt.x, pt.y, frameWidth, frameHeight);
    WAPullDownMenu *wpm = [[WAPullDownMenu alloc] initWithFrame:rect];
    wpm.menuColor = color;
    wpm.shadow.backgroundColor = wpm.shadowColor;
    wpm.list = list;
    [wpm initUI];

    return wpm;
}

- (void)initUI {
    CGFloat m_y = self.frame.origin.y;
    CGSize m_size = self.frame.size;
    
    NSInteger numberOfMenu = _list.count;
    _titles = [NSMutableArray arrayWithCapacity:numberOfMenu];
    _indicators = [NSMutableArray arrayWithCapacity:numberOfMenu];
    
    CGFloat textLayerInterval = m_size.width / (numberOfMenu * 2);
    CGFloat separatorLineInterval = m_size.width / numberOfMenu;
    for (int i = 0; i < numberOfMenu; i ++) {
        CGPoint position = CGPointMake((i*2+1) * textLayerInterval, m_size.height / 2);
        CATextLayer *cText
        = [CALayer createTextWithString:_list[i][0] color:_menuColor fontsize:textFont position:position];
        [self.layer addSublayer:cText];
        [_titles addObject:cText];
        
        position = CGPointMake(position.x + cText.bounds.size.width/2 + 8, m_size.height / 2);
        CAShapeLayer *indicator = [CALayer createIndicatorWithColor:_menuColor position:position];
        [self.layer addSublayer:indicator];
        [_indicators addObject:indicator];
        
        if (i == numberOfMenu - 1) {
            continue;
        }
        
        position = CGPointMake((i + 1) * separatorLineInterval, m_size.height / 2);
        CAShapeLayer *separator
        = [CALayer createSeparatorLineWithColor:HexRGB(0xEFEFF3) position:position];
        [self.layer addSublayer:separator];
    }
    
    _tableView = [self creatTableViewAtPosition:CGPointMake(0, m_y + m_size.height)];
    _tableView.tintColor = _menuColor;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    // 设置menu, 并添加手势
    UIGestureRecognizer *tapGR1
    = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInMenu:)];
    [self addGestureRecognizer:tapGR1];
    
    // 创建背景
    _backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.6f];
    _backgroundView.backgroundColor = _backgroundColor;
    _backgroundView.opaque = YES;
    UIGestureRecognizer *tapGR2
    = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInScreen:)];
    [_backgroundView addGestureRecognizer:tapGR2];
    
    _currentIndex = -1;
    _hasShown = NO;
}

- (UITableView *)creatTableViewAtPosition:(CGPoint)pt {
    UITableView *tableView = [UITableView new];
    tableView.frame = CGRectMake(pt.x, pt.y, frameWidth, 0);
    tableView.rowHeight = frameHeight;
    return tableView;
}

- (UIView *)makeShadow {
    CGRect rect = self.frame;
    rect.origin = CGPointMake(5, self.frame.size.height - 3);
    rect.size.width = self.frame.size.width / 2 - 10;
    rect.size.height = 3.0f;
    UIView *shadow = [[UIView alloc] initWithFrame:rect];
    return shadow;
}

- (UIView *)makeLine {
    CGRect rect = self.frame;
    rect.origin = CGPointMake(0, self.frame.size.height);
    rect.size.height = 1.0f;
    UIView *grayline = [[UIView alloc] initWithFrame:rect];
    grayline.backgroundColor = [UIColor lightGrayColor];
    return grayline;
}

/************************************************************************************************/

#pragma mark - datasource

// row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *subList = (NSArray *)_list[_currentIndex];
    return subList.count;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndentifier = @"pulldownCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIndentifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:textFont];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    NSArray *subList = (NSArray *)_list[_currentIndex];
    cell.textLabel.text = subList[indexPath.row];
    
    if ([cell.textLabel.text isEqualToString:[(CATextLayer *)_titles[_currentIndex] string]]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        [cell.textLabel setTextColor:[tableView tintColor]];
    }
    
    return cell;
}

/************************************************************************************************/

#pragma mark - delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self selectRow:indexPath.row];
    CGRect rect = self.shadow.frame;
    rect.origin = CGPointMake(5, self.frame.size.height - 3);
    if (_currentIndex > 0) {
        rect.origin.x += self.frame.size.width / 2;
    }
    [UIView animateWithDuration:0.2f animations:^{
        self.shadow.frame = rect;
    }];
    
    if ([_pDelegate respondsToSelector:@selector(pullDownMenu:didSelectColumn:row:)]) {
        [_pDelegate pullDownMenu:self didSelectColumn:_currentIndex row:indexPath.row];
    }
}

/************************************************************************************************/

#pragma mark - button action

// 点击按钮
- (void)tapInMenu:(UITapGestureRecognizer *)sender {
    CGPoint touchPoint = [sender locationInView:self];
    
    // 得到tapIndex
    CGRect rect = self.frame;
    NSInteger num = _list.count;
    NSInteger tapIndex = touchPoint.x / (rect.size.width / num);
    for (int i = 0; i < num; i ++) {
        if (i == tapIndex) {
            continue;
        }
        [self animateIndicator:_indicators[i] forward:NO complete:^{
            [self animateTitle:self.titles[i] show:NO complete:^{
            }];
        }];
    }
    
    // 收起列表
    if (tapIndex == _currentIndex && _hasShown) {
        [self animateIdicator:_indicators[_currentIndex]
                   background:_backgroundView
                    tableView:_tableView
                        title:_titles[_currentIndex]
                      forward:NO
                    complecte:^{
            self.currentIndex = tapIndex;
            self.hasShown = NO;
        }];
    }
    // 显示列表
    else {
        _currentIndex = tapIndex;
        [_tableView reloadData];
        [self animateIdicator:_indicators[tapIndex]
                   background:_backgroundView
                    tableView:_tableView
                        title:_titles[tapIndex]
                      forward:YES
                    complecte:^{
            self.hasShown = YES;
        }];
    }
}

// 点击黑玻璃
- (void)tapInScreen:(UITapGestureRecognizer *)sender {
    [self animateIdicator:_indicators[_currentIndex]
               background:_backgroundView
                tableView:_tableView
                    title:_titles[_currentIndex]
                  forward:NO
                complecte:^{
        self.hasShown = NO;
    }];
}

/************************************************************************************************/

#pragma mark - function

// 重置
- (void)reset {
    _currentIndex = 1;
    [self selectRow:0];
    _currentIndex = 0;
    [self selectRow:0];
}

// 选择行
- (void)selectRow:(NSInteger)row {
    CATextLayer *cText = (CATextLayer *)_titles[_currentIndex];
    cText.string = [_list[_currentIndex] objectAtIndex:row];
    
    [self animateIdicator:_indicators[_currentIndex]
               background:_backgroundView
                tableView:_tableView
                    title:_titles[_currentIndex]
                  forward:NO
                complecte:^{
        self.hasShown = NO;
    }];
    
    CAShapeLayer *indicator = (CAShapeLayer *)_indicators[_currentIndex];
    indicator.position
    = CGPointMake(cText.position.x + cText.frame.size.width / 2 + 8, indicator.position.y);
}

/************************************************************************************************/

#pragma mark - animation

// 箭头转换动画
- (void)animateIndicator:(CAShapeLayer *)indicator forward:(BOOL)forward complete:(void(^)(void))complete {
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.25f];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.4f:0.0f:0.2f:1.0f]];
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    anim.values = forward ? @[ @0, @(M_PI) ] : @[ @(M_PI), @0 ];
    
    if (! anim.removedOnCompletion) {
        [indicator addAnimation:anim forKey:anim.keyPath];
    } else {
        [indicator animation:anim value:anim.values.lastObject forKeyPath:anim.keyPath];
    }
    
    [CATransaction commit];
    indicator.fillColor = forward ? _tableView.tintColor.CGColor : _menuColor.CGColor;
    complete();
}

// 背景玻璃动画
- (void)animateBackgroundView:(UIView *)view show:(BOOL)show complete:(void(^)(void))complete {
    if (show) {
        [self.superview addSubview:view];
        [view.superview addSubview:self];
        
        [UIView animateWithDuration:0.2f animations:^{
            view.backgroundColor = self.backgroundColor;
        }];
    } else {
        [UIView animateWithDuration:0.2f animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.0f];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }
    complete();
}

// 下拉菜单动画
- (void)animateTableView:(UITableView *)tableView show:(BOOL)show complete:(void(^)(void))complete {
    CGRect rect = self.frame;
    if (show) {
        tableView.frame = CGRectMake(0, rect.origin.y + rect.size.height, rect.size.width, 0);
        [self.superview addSubview:tableView];
        
        NSInteger num = [tableView numberOfRowsInSection:0];
        CGFloat tableViewHeight = (num > 5 ? 5 : num) * _tableView.rowHeight;
        [UIView animateWithDuration:0.2f animations:^{
            self.tableView.frame = CGRectMake(0, rect.origin.y + rect.size.height, rect.size.width, tableViewHeight);
        }];
    } else {
        [UIView animateWithDuration:0.2f animations:^{
            self.tableView.frame = CGRectMake(0, rect.origin.y + rect.size.height, rect.size.width, 0);
        } completion:^(BOOL finished) {
            [self.tableView removeFromSuperview];
        }];
    }
    complete();
}

// 文字显示动画
- (void)animateTitle:(CATextLayer *)title show:(BOOL)show complete:(void(^)(void))complete {
    CGRect rect = self.frame;
    if (show) {
        title.foregroundColor = _tableView.tintColor.CGColor;
    } else {
        title.foregroundColor = _menuColor.CGColor;
    }
    CGSize size = [CALayer boundsBySize:CGSizeMake(0, 300) text:title.string fontSize:textFont];
    NSInteger numberOfMenu = _list.count;
    CGFloat sizeWidth = (size.width < (rect.size.width / numberOfMenu) - 25) ? size.width : rect.size.width / numberOfMenu - 25;
    title.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    
    complete();
}

// 全体动画
- (void)animateIdicator:(CAShapeLayer *)indicator
             background:(UIView *)background
              tableView:(UITableView *)tableView
                  title:(CATextLayer *)title
                forward:(BOOL)forward
              complecte:(void(^)(void))complete {
    [self animateIndicator:indicator forward:forward complete:^{
        [self animateTitle:title show:forward complete:^{
            [self animateBackgroundView:background show:forward complete:^{
                [self animateTableView:tableView show:forward complete:^{ }];
            }];
        }];
    }];
    
    complete();
}

/************************************************************************************************/


@end
