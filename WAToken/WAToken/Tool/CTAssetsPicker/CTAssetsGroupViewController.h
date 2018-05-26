//
//  CTAssetsGroupViewController.h
//  KingOfUnzip
//
//  Created by dizhihao on 15/9/7.
//  Copyright (c) 2015年 dizhihao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTAssetsGroupViewCell.h"
#import "CTAssetsViewController.h"

@interface CTAssetsGroupViewController : UITableViewController

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) NSMutableArray  *groups;

@end
