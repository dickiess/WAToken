//
//  CTAssetsGroupViewCell.h
//  KingOfUnzip
//
//  Created by dizhihao on 15/9/7.
//  Copyright (c) 2015年 dizhihao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define kThumbnailLength    78.0f
#define kThumbnailSize      CGSizeMake(kThumbnailLength, kThumbnailLength)
#define kPopoverContentSize CGSizeMake(320, 480)

@interface CTAssetsGroupViewCell : UITableViewCell

@property (nonatomic, strong) ALAssetsGroup *assetsGroup;

- (void)bind:(ALAssetsGroup *)assetsGroup;

@end
