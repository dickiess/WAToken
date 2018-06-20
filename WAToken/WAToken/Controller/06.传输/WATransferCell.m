//
//  WATransferCell.m
//  WAToken
//
//  Created by dizhihao on 2018/6/8.
//  Copyright © 2018 dizhihao. All rights reserved.
//

#import "WATransferCell.h"



@implementation WATransferItem

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (WATransferItem *)itemWithTaskId:(NSString *)tId
                          filename:(NSString *)fName
                             state:(LOAD_STATE)state
                         starttime:(NSTimeInterval)sTime {
    WATransferItem *item = [[WATransferItem alloc] init];
    item.taskId = tId;
    item.fileName = fName;
    item.state = state;
    item.startTime = sTime;
    return item;
}

@end

/************************************************************************************************/

@interface WATransferCell ()

@property (weak, nonatomic) IBOutlet UILabel *filenameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;

@end

/************************************************************************************************/

@implementation WATransferCell

+ (instancetype)xibTableViewCell {
    /*
     在类方法中加载xib文件,注意:loadNibNamed:owner:options:这个方法返回的是NSArray,
     所以在后面加上firstObject或者lastObject或者[0]都可以;因为我们的Xib文件中,只有一个cell
     */
    return [[[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 文件名
    _filenameLabel.text = _itemInfo.fileName;
    
    // 详细
    NSString *detailString = @"";
    switch (_itemInfo.state) {
        // 下载结束
        case DNLOAD_FINISH: {
            detailString = [self loadFinish];
            [_moreBtn setImage:[UIImage imageNamed:@"btn_preview"] forState:UIControlStateNormal];
        } break;
            
        // 下载停止（未完成）
        case DNLOAD_STOP: {
            detailString = [self loadStop];
            [_moreBtn setImage:[UIImage imageNamed:@"btn_refresh"] forState:UIControlStateNormal];
        } break;
            
        // 下载暂停
        case DNLOAD_PAUSE: {
            detailString = [self loadPause];
            [_moreBtn setImage:[UIImage imageNamed:@"btn_play"] forState:UIControlStateNormal];
        } break;
        
        // 下载开始
        case DNLOAD_START: {
            detailString = [self loadStart];
            [_moreBtn setImage:[UIImage imageNamed:@"btn_pause"] forState:UIControlStateNormal];
        } break;
            
        // 上传结束
        case UPLOAD_FINISH: {
            detailString = [self loadFinish];
            [_moreBtn setImage:[UIImage imageNamed:@"btn_preview"] forState:UIControlStateNormal];
        } break;
        
        // 上传停止（未完成）
        case UPLOAD_STOP: {
            detailString = [self loadStop];
            [_moreBtn setImage:[UIImage imageNamed:@"btn_refresh"] forState:UIControlStateNormal];
        } break;
        
        // 上传暂停
        case UPLOAD_PAUSE: {
            detailString = [self loadPause];
            [_moreBtn setImage:[UIImage imageNamed:@"btn_play"] forState:UIControlStateNormal];
        } break;
        
        // 上传开始
        case UPLOAD_START: {
            detailString = [self loadStart];
            [_moreBtn setImage:[UIImage imageNamed:@"btn_pause"] forState:UIControlStateNormal];
        } break;
            
        default: break;
    }
    _detailLabel.text = detailString;
    
}

/*
 规范：
 结束：显示大小、完成时间
 停止：显示未完成/总体（百分比），开始时间，再开标志
 暂停：显示未完成/总体（百分比），开始时间，暂停标志
 开始：显示未完成/总体（百分比），传输速度
 
 */

// 任务完成
- (NSString *)loadFinish {
    NSString *finishTime = [NSDate timeDescriptionByTimeInterval:_itemInfo.finishTime];
    NSString *filesize = [self convertFileSize:_itemInfo.totalSize];
    return [NSString stringWithFormat:@"文件: %@   %@", filesize, finishTime];
}

// 任务中止
- (NSString *)loadStop {
    CGFloat rate = _itemInfo.loadSize * 100.0f / _itemInfo.totalSize;
    NSString *loadSize  = [self convertFileSize:_itemInfo.loadSize];
    NSString *totalSize = [self convertFileSize:_itemInfo.totalSize];
    NSString *starttime = [NSDate timeDescriptionByTimeInterval:_itemInfo.startTime];
    return [NSString stringWithFormat:@"文件: %@/%@(%.2f%%)   %@", loadSize, totalSize, rate, starttime];
}

// 任务暂停
- (NSString *)loadPause {
    CGFloat rate = _itemInfo.loadSize * 100.0f / _itemInfo.totalSize;
    NSString *loadSize  = [self convertFileSize:_itemInfo.loadSize];
    NSString *totalSize = [self convertFileSize:_itemInfo.totalSize];
    NSString *starttime = [NSDate timeDescriptionByTimeInterval:_itemInfo.startTime];
    return [NSString stringWithFormat:@"文件: %@/%@(%.2f%%)   %@", loadSize, totalSize, rate, starttime];
}

// 任务开始
- (NSString *)loadStart {
    CGFloat rate = _itemInfo.loadSize * 100.0f / _itemInfo.totalSize;
    NSString *loadSize  = [self convertFileSize:_itemInfo.loadSize];
    NSString *totalSize = [self convertFileSize:_itemInfo.totalSize];
    NSString *loadSpeed = [self convertFileSize:_itemInfo.loadSpeed];
    return [NSString stringWithFormat:@"文件: %@/%@(%.2f%%)   %@/s", loadSize, totalSize, rate, loadSpeed];
}

// 文件大小转换
- (NSString *)convertFileSize:(unsigned long long)fSize {
    // 1000以内，整数输出
    if (fSize < 1000) {
        return [NSString stringWithFormat:@"%dB", (int)fSize];
    }
    
    // 1000以上，小数输出
    CGFloat nSize = fSize / 1000.0f;
    NSString *unit = @"KB";
    for (int i = 1; i < 3; i ++) {
        if (nSize / 1000.0f > 1.0f) {
            nSize = nSize / 1000.0f;
            if (i == 1) {
                unit = @"MB";
            } else if (i == 2) {
                unit = @"GB";
            }
        }
    }
    return [NSString stringWithFormat:@"%.2f%@", nSize, unit];
}

/************************************************************************************************/

#pragma mark - button action

// 点击cell
- (IBAction)moreAction:(UIButton *)sender {
    if ([_cellDelegate respondsToSelector:@selector(tableViewCellDidSelected:)]) {
        [_cellDelegate tableViewCellDidSelected:self];
    }
}


@end
