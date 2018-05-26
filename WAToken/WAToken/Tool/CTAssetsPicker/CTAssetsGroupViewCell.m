//
//  CTAssetsGroupViewCell.m
//  KingOfUnzip
//
//  Created by dizhihao on 15/9/7.
//  Copyright (c) 2015年 dizhihao. All rights reserved.
//

#import "CTAssetsGroupViewCell.h"

@implementation CTAssetsGroupViewCell

- (void)bind:(ALAssetsGroup *)assetsGroup {
    
    self.assetsGroup            = assetsGroup;
    
    CGImageRef posterImage      = assetsGroup.posterImage;
    size_t height               = CGImageGetHeight(posterImage);
    float scale                 = height / kThumbnailLength;
    
    self.imageView.image        = [UIImage imageWithCGImage:posterImage scale:scale orientation:UIImageOrientationUp];
    self.textLabel.text         = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    self.detailTextLabel.text   = [NSString stringWithFormat:@"%ld", (long)[assetsGroup numberOfAssets]];
    self.accessoryType          = UITableViewCellAccessoryDisclosureIndicator;
}

- (NSString *)accessibilityLabel {
    
    NSString *label = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    
    return [label stringByAppendingFormat:NSLocalizedString(@"%d Photos", nil), [self.assetsGroup numberOfAssets]];
}

@end
