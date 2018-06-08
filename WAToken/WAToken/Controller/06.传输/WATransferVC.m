//
//  WATransferVC.m
//  WAToken
//
//  Created by dizhihao on 2018/6/6.
//  Copyright © 2018 dizhihao. All rights reserved.
//

#import "WATransferVC.h"

#import "WAPullDownMenu.h"
#import "WATransferCell.h"

#import "WAServer.h"

@interface WATransferVC () <WAPullDownMenuDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) WAPullDownMenu *menu;

@end



@implementation WATransferVC

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
    
    [_menu reset];
}

- (void)initUI {
    NSArray *list = (@[@[@"下载", @"已下载", @"下载中"],
                       @[@"上传", @"已上传", @"上传中"],
                       ]);
    CGPoint pt = CGPointMake(0, NAVI_BAR_HEIGHT);
    _menu = [WAPullDownMenu menuWithList:list position:pt selectedColor:HexRGB(0x101010)];
    _menu.pDelegate = self;
    [self.view addSubview:_menu];
    
    UINib *nib = [UINib nibWithNibName:@"WATransferCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
}

/************************************************************************************************/

#pragma mark - datasource

// row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

// cell
- (WATransferCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WATransferCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [WATransferCell xibTableViewCell];
    }
    

    
    
    return cell;
}

/************************************************************************************************/

#pragma mark - delegate

// cell height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

- (void)pullDownMenu:(WAPullDownMenu *)pMenu didSelectColumn:(NSInteger)column row:(NSInteger)row {
    NSLog(@"column: %d, row: %d", (int)column, (int)row);
}

@end
