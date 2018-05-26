
//
//  CTAssetsPickerController.h
//  KingOfUnzip
//
//  Created by dizhihao on 15/9/7.
//  Copyright (c) 2015年 dizhihao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTAssetsGroupViewController.h"
#import "PrepareObj.h"

@class CTAssetsPickerController;

@protocol CTAssetsPickerDelegate <NSObject>

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets;

@optional

- (void)assetsPickerControllerDidCancel:(CTAssetsPickerController *)picker;

@end

@interface CTAssetsPickerController : UINavigationController

@property (nonatomic, weak) id <UINavigationControllerDelegate, CTAssetsPickerDelegate> delegate;
@property (nonatomic, strong) ALAssetsFilter *assetsFilter;
@property (nonatomic, assign) NSInteger maximumNumberOfSelection;
@property (nonatomic, assign) BOOL showsCancelButton;

@end
