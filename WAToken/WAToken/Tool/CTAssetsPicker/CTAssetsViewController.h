//
//  CTAssetsViewController.h
//  KingOfUnzip
//
//  Created by dizhihao on 15/9/7.
//  Copyright (c) 2015年 dizhihao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTAssetsViewCell.h"
#import "CTAssetsSupplementaryView.h"
#import "CTAssetsPickerController.h"

#define kAssetsViewCellIdentifier           @"AssetsViewCellIdentifier"
#define kAssetsSupplementaryViewIdentifier  @"AssetsSupplementaryViewIdentifier"

@interface CTAssetsViewController : UICollectionViewController

@property (nonatomic, strong) ALAssetsGroup  *assetsGroup;
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, assign) NSInteger numberOfPhotos;
@property (nonatomic, assign) NSInteger numberOfVideos;

@end
