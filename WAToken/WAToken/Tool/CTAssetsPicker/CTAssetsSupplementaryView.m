//
//  CTAssetsSupplementaryView.m
//  KingOfUnzip
//
//  Created by dizhihao on 15/9/7.
//  Copyright (c) 2015年 dizhihao. All rights reserved.
//

#import "CTAssetsSupplementaryView.h"

@implementation CTAssetsSupplementaryView

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        _sectionLabel               = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 8.0, 8.0)];
        _sectionLabel.font          = [UIFont systemFontOfSize:18.0];
        _sectionLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_sectionLabel];
    }
    
    return self;
}

- (void)setNumberOfPhotos:(NSInteger)numberOfPhotos numberOfVideos:(NSInteger)numberOfVideos {
    NSString *title;
    
    if (numberOfVideos == 0)
        title = [NSString stringWithFormat:NSLocalizedString(@"%d Photos", nil), numberOfPhotos];
    else if (numberOfPhotos == 0)
        title = [NSString stringWithFormat:NSLocalizedString(@"%d Videos", nil), numberOfVideos];
    else
        title = [NSString stringWithFormat:NSLocalizedString(@"%d Photos, %d Videos", nil), numberOfPhotos, numberOfVideos];
    
    self.sectionLabel.text = title;
}

@end
