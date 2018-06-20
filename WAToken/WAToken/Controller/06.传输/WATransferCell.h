//
//  WATransferCell.h
//  WAToken
//
//  Created by dizhihao on 2018/6/8.
//  Copyright © 2018 dizhihao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WAServer.h"

// 状态
typedef enum {
    DNLOAD_FINISH = 10,
    DNLOAD_STOP,
    DNLOAD_PAUSE,
    DNLOAD_START,
    
    UPLOAD_FINISH = 20,
    UPLOAD_STOP,
    UPLOAD_PAUSE,
    UPLOAD_START,
    
} LOAD_STATE;

/************************************************************************************************/

@interface WATransferItem : NSObject

@property (nonatomic, strong) NSString      *taskId;
@property (nonatomic, strong) NSString      *fileName;
@property (nonatomic, assign) LOAD_STATE    state;
@property (nonatomic, assign) unsigned long long loadSize;
@property (nonatomic, assign) unsigned long long totalSize;
@property (nonatomic, assign) unsigned long long loadSpeed;
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, assign) NSTimeInterval finishTime;

+ (WATransferItem *)itemWithTaskId:(NSString *)tId
                          filename:(NSString *)fName
                             state:(LOAD_STATE)state
                         starttime:(NSTimeInterval)sTime;

@end

/************************************************************************************************/

#define cellIdentifier  @"WATransferCell"
#define cellHeight      (80.0f)

/************************************************************************************************/

@class WATransferCell;
@protocol WATransferCellDelegate <NSObject>

@required
- (void)tableViewCellDidSelected:(WATransferCell *)cell;

@end

@interface WATransferCell : UITableViewCell

@property (nonatomic, strong) WATransferItem *itemInfo;
@property (nonatomic, strong) id<WATransferCellDelegate> cellDelegate;

+ (instancetype)xibTableViewCell;

@end
