//
//  CTAssetsViewController.m
//  KingOfUnzip
//
//  Created by dizhihao on 15/9/7.
//  Copyright (c) 2015年 dizhihao. All rights reserved.
//

#import "CTAssetsViewController.h"


@implementation CTAssetsViewController

- (id)init {
    
    UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize                     = kThumbnailSize;
    layout.sectionInset                 = UIEdgeInsetsMake(9.0, 0, 0, 0);
    layout.minimumInteritemSpacing      = 2.0;
    layout.minimumLineSpacing           = 2.0;
    layout.footerReferenceSize          = CGSizeMake(0, 44.0);
    
    if (self = [super initWithCollectionViewLayout:layout]) {
        self.collectionView.allowsMultipleSelection = YES;
        
        [self.collectionView registerClass:[CTAssetsViewCell class]
                forCellWithReuseIdentifier:kAssetsViewCellIdentifier];
        
        [self.collectionView registerClass:[CTAssetsSupplementaryView class]
                forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                       withReuseIdentifier:kAssetsSupplementaryViewIdentifier];
        
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
            [self setEdgesForExtendedLayout:UIRectEdgeNone];
        
//        if ([self respondsToSelector:@selector(setContentSizeForViewInPopover:)]) {
//            [self setContentSizeForViewInPopover:kPopoverContentSize];
//        }
        if ([self respondsToSelector:@selector(setPreferredContentSize:)]) {
            [self setPreferredContentSize:kPopoverContentSize];
        }
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self setupButtons];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupAssets];
}

#pragma mark - Setup

- (void)setupViews {
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

- (void)setupButtons {
    
    self.navigationItem.rightBarButtonItem
    = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil)
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(finishPickingAssets:)];
}

- (void)setupAssets {
    
    self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    
    if (!self.assets)
        self.assets = [[NSMutableArray alloc] init];
    else
        [self.assets removeAllObjects];
    
    ALAssetsGroupEnumerationResultsBlock resultsBlock = ^(ALAsset *asset, NSUInteger index, BOOL *stop) {
        
        if (asset) {
            //[self.assets addObject:asset];
            [self.assets insertObject:asset atIndex:0]; //
            
            NSString *type = [asset valueForProperty:ALAssetPropertyType];
            
            if ([type isEqual:ALAssetTypePhoto])
                self.numberOfPhotos ++;
            if ([type isEqual:ALAssetTypeVideo])
                self.numberOfVideos ++;
        } else if (self.assets.count > 0) {
            
            [self.collectionView reloadData];
            
            NSIndexPath *idx = [NSIndexPath indexPathForItem:(self.assets.count - 1) inSection:0];
            [self.collectionView scrollToItemAtIndexPath:idx atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
        }
    };
    
    [self.assetsGroup enumerateAssetsUsingBlock:resultsBlock];
}


#pragma mark - Collection View Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = kAssetsViewCellIdentifier;
    
    CTAssetsViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell bind:[self.assets objectAtIndex:indexPath.row]];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *viewIdentifiert = kAssetsSupplementaryViewIdentifier;
    
    CTAssetsSupplementaryView *view
    = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                         withReuseIdentifier:viewIdentifiert forIndexPath:indexPath];
    
    [view setNumberOfPhotos:self.numberOfPhotos numberOfVideos:self.numberOfVideos];
    
    return view;
}


#pragma mark - Collection View Delegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CTAssetsPickerController *vc = (CTAssetsPickerController *)self.navigationController;
    return ([collectionView indexPathsForSelectedItems].count < vc.maximumNumberOfSelection);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self setTitleWithSelectedIndexPaths:collectionView.indexPathsForSelectedItems];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self setTitleWithSelectedIndexPaths:collectionView.indexPathsForSelectedItems];
}


#pragma mark - Title

- (void)setTitleWithSelectedIndexPaths:(NSArray *)indexPaths {
    
    // Reset title to group name
    if (indexPaths.count == 0) {
        self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
        return;
    }
    
    BOOL photosSelected = NO;
    BOOL videoSelected  = NO;
    
    for (NSIndexPath *indexPath in indexPaths) {
        ALAsset *asset = [self.assets objectAtIndex:indexPath.item];
        
        if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypePhoto])
            photosSelected  = YES;
        
        if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo])
            videoSelected   = YES;
        
        if (photosSelected && videoSelected)
            break;
    }
    
    NSString *format;
    if (photosSelected && videoSelected) {
        format = NSLocalizedString(@"%d Items Selected", nil);
    } else if (photosSelected) {
        format = (indexPaths.count > 1) ? NSLocalizedString(@"%d Photos Selected", nil) : NSLocalizedString(@"%d Photo Selected", nil);
    } else if (videoSelected) {
        format = (indexPaths.count > 1) ? NSLocalizedString(@"%d Videos Selected", nil) : NSLocalizedString(@"%d Video Selected", nil);
    }
    
    self.title = [NSString stringWithFormat:format, indexPaths.count];
}


#pragma mark - Actions

- (void)finishPickingAssets:(id)sender {
    
    NSMutableArray *assets = [[NSMutableArray alloc] init];
    
    for (NSIndexPath *indexPath in self.collectionView.indexPathsForSelectedItems) {
        [assets addObject:[self.assets objectAtIndex:indexPath.item]];
    }
    
    CTAssetsPickerController *picker = (CTAssetsPickerController *)self.navigationController;
    
    if ([picker.delegate respondsToSelector:@selector(assetsPickerController:didFinishPickingAssets:)]) {
        [picker.delegate assetsPickerController:picker didFinishPickingAssets:assets];
    }
    
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

@end
