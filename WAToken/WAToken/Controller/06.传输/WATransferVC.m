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

@interface WATransferVC () <WAPullDownMenuDelegate, WATransferCellDelegate>

@property (nonatomic, strong) WAPullDownMenu *menu;

@property (nonatomic, assign) NSInteger      currentColumn;
@property (nonatomic, strong) NSMutableArray *list_download;
@property (nonatomic, strong) NSMutableArray *list_upload;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

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
    
    NSLog(@"=== WATransferVC ===");
    [_menu reset];
    [self fakeData];
}

- (void)initUI {
    NSArray *list = (@[@[@"下载", @"已下载", @"下载中"],
                       @[@"上传", @"已上传", @"上传中"],
                       ]);
    CGPoint pt = CGPointMake(0, NAVI_BAR_HEIGHT);
    _menu = [WAPullDownMenu menuWithList:list position:pt selectedColor:HexRGB(0x101010)];
    _menu.pDelegate = self;
    [self.view addSubview:_menu];
    _currentColumn = 0;
    
    UINib *nib = [UINib nibWithNibName:@"WATransferCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
}

/************************************************************************************************/

#pragma mark - datasource

// row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_currentColumn > 0) {
        return _list_upload.count;
    } else {
        return _list_download.count;
    }
}

// cell
- (WATransferCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WATransferCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [WATransferCell xibTableViewCell];
        
    }
    
    cell.cellDelegate = self;
    if (_currentColumn > 0) {
        cell.itemInfo = _list_upload[indexPath.row];
    } else {
        cell.itemInfo = _list_download[indexPath.row];
    }
    
    
    return cell;
}

/************************************************************************************************/

#pragma mark - delegate

// cell height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = HexRGB(0xE0E0E0);
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableViewCellDidSelected:(WATransferCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSInteger row = indexPath.row;
    NSLog(@"%d %d", (int)_currentColumn, (int)row);
}

- (void)pullDownMenu:(WAPullDownMenu *)pMenu didSelectColumn:(NSInteger)column row:(NSInteger)row {
//    NSLog(@"column: %d, row: %d", (int)column, (int)row);
    _currentColumn = column;
    [self.tableView reloadData];
}

/************************************************************************************************/

- (void)fakeData {
    
    _list_download = [NSMutableArray array];
    
    // 下载完成
    WATransferItem *item11
    = [WATransferItem itemWithTaskId:@"475943534861"
                            filename:@"这丫IE感冒么公司1.docx"
                               state:DNLOAD_FINISH
                           starttime:1528783841];
    item11.totalSize = 25489568221;
    item11.finishTime = 1528784517;
    [_list_download addObject:item11];
    
    // 下载中止
    WATransferItem *item12
    = [WATransferItem itemWithTaskId:@"475943534862"
                            filename:@"这丫IE感冒么公司1.docx"
                               state:DNLOAD_STOP
                           starttime:1528783842];
    item12.totalSize = 25489568221;
    item12.loadSize  = 12249568221;
    [_list_download addObject:item12];
    
    // 下载暂停
    WATransferItem *item13
    = [WATransferItem itemWithTaskId:@"475943534863"
                            filename:@"这丫IE感冒么公司1.docx"
                               state:DNLOAD_PAUSE
                           starttime:1528783843];
    item13.totalSize = 25489568221;
    item13.loadSize  = 12249568221;
    [_list_download addObject:item13];
    
    // 下载开始
    WATransferItem *item14
    = [WATransferItem itemWithTaskId:@"475943534864"
                            filename:@"这丫IE感冒么公司1.docx"
                               state:DNLOAD_START
                           starttime:1528783844];
    item14.totalSize = 25489568221;
    item14.loadSize  = 12249568221;
    item14.loadSpeed = 1623789;
    [_list_download addObject:item14];
    
    
    _list_upload = [NSMutableArray array];
    
    // 上传完成
    WATransferItem *item21
    = [WATransferItem itemWithTaskId:@"475943534861"
                            filename:@"这丫IE感冒么公司2.docx"
                               state:UPLOAD_FINISH
                           starttime:1528783841];
    item21.totalSize = 25489568221;
    item21.finishTime = 1528784517;
    [_list_upload addObject:item21];
    
    // 下载中止
    WATransferItem *item22
    = [WATransferItem itemWithTaskId:@"475943534862"
                            filename:@"这丫IE感冒么公司2.docx"
                               state:UPLOAD_STOP
                           starttime:1528783842];
    item22.totalSize = 25489568221;
    item22.loadSize  = 12249568221;
    [_list_upload addObject:item22];
    
    // 下载暂停
    WATransferItem *item23
    = [WATransferItem itemWithTaskId:@"475943534863"
                            filename:@"这丫IE感冒么公司2.docx"
                               state:UPLOAD_PAUSE
                           starttime:1528783843];
    item23.totalSize = 25489568221;
    item23.loadSize  = 12249568221;
    [_list_upload addObject:item23];
    
    // 下载开始
    WATransferItem *item24
    = [WATransferItem itemWithTaskId:@"475943534864"
                            filename:@"这丫IE感冒么公司2.docx"
                               state:UPLOAD_START
                           starttime:1528783844];
    item24.totalSize = 25489568221;
    item24.loadSize  = 22249568221;
    item24.loadSpeed = 1623789;
    [_list_upload addObject:item24];

    [self.tableView reloadData];
}



@end
