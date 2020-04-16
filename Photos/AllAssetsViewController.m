//
//  AllAssetsViewController.m
//  Photos
//
//  Created by qiyu on 2020/4/16.
//  Copyright © 2020 com.qiyu. All rights reserved.
//

#import "AllAssetsViewController.h"
#import "CollectionViewCell.h"
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>

@interface AllAssetsViewController () <UICollectionViewDelegate, UICollectionViewDataSource, PHPhotoLibraryChangeObserver>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) PHFetchResult<PHAsset *> *fetchResult;
@property (strong, nonatomic) PHImageManager *imageManager;

@end

@implementation AllAssetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    [self setupCollectionView];
    
    [self requiredPermissionAndGetPhotos];
    
    [PHPhotoLibrary.sharedPhotoLibrary registerChangeObserver:self];
    self.imageManager = [PHImageManager defaultManager];

//    NSLog(@"%ld", (long)[PHPhotoLibrary authorizationStatus]);
    
    self.title = @"All";
}

- (void)requiredPermissionAndGetPhotos {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized) {
        [self getPhotos];
    } else {
        if (status == PHAuthorizationStatusNotDetermined) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    [self getPhotos];
                } else {
                    NSLog(@"noPermission");
                }
            }];
        } else {
            NSLog(@"noPermission");
        }
    }
}

- (void)getPhotos {
    if (!self.fetchResult) {
        PHFetchOptions *allPhotoOptions = [[PHFetchOptions alloc] init];
        allPhotoOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        self.fetchResult = [PHAsset fetchAssetsWithOptions:allPhotoOptions];
//        NSLog(@"photos count %ld", self.fetchResult.count);
    }
}

- (void)dealloc {
    [PHPhotoLibrary.sharedPhotoLibrary unregisterChangeObserver:self];
}

- (void)setupCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(80.0, 80.0);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(5, 0, self.view.bounds.size.width - 10, self.view.bounds.size.height) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = UIColor.whiteColor;
    [self.collectionView registerClass:CollectionViewCell.class forCellWithReuseIdentifier:@"CollectionViewCellReuseId"];
    [self.view addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCellReuseId" forIndexPath:indexPath];
    PHAsset *asset = [self.fetchResult objectAtIndex:indexPath.item];
    
    if (asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
        cell.livePhotoBadgeImage = [PHLivePhotoView livePhotoBadgeImageWithOptions:PHLivePhotoBadgeOptionsOverContent];
    }
    
    PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
    [self.imageManager requestImageForAsset:asset targetSize:CGSizeMake(80.0, 80.0) contentMode:PHImageContentModeAspectFill options:imageRequestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            cell.thumbnailImage = result;
    }];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.fetchResult.count;
}

- (void)photoLibraryDidChange:(nonnull PHChange *)changeInstance {
    PHFetchResultChangeDetails *changes = [changeInstance changeDetailsForFetchResult:self.fetchResult];
    dispatch_sync(dispatch_get_main_queue(), ^{
        self.fetchResult = changes.fetchResultAfterChanges;
        if ([changes hasIncrementalChanges]) {
            [self.collectionView performBatchUpdates:^{
                NSIndexSet *removed = changes.removedIndexes;
                if (removed.count > 0) {
                    __block NSMutableArray<NSIndexPath *> *removedArray = [[NSMutableArray alloc] init];
                    [removed enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
                        [removedArray addObject:[NSIndexPath indexPathForItem:idx inSection:0]];
                    }];
                    [self.collectionView deleteItemsAtIndexPaths:removedArray];
                }
                NSIndexSet *inserted = changes.insertedIndexes;
                if (inserted.count > 0) {
                    __block NSMutableArray<NSIndexPath *> *insertedArray = [[NSMutableArray alloc] init];
                    [inserted enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
                        [insertedArray addObject:[NSIndexPath indexPathForItem:idx inSection:0]];
                    }];
                    [self.collectionView insertItemsAtIndexPaths:insertedArray];
                }
                [changes enumerateMovesWithBlock:^(NSUInteger fromIndex, NSUInteger toIndex) {
                    [self.collectionView moveItemAtIndexPath:[NSIndexPath indexPathForItem:fromIndex inSection:0] toIndexPath:[NSIndexPath indexPathForItem:toIndex inSection:0]];
                }];
            } completion:^(BOOL finished) {
                
            }];
            
            NSIndexSet *changed = changes.changedIndexes;
            if (changed.count > 0) {
                __block NSMutableArray<NSIndexPath *> *changedArray = [[NSMutableArray alloc] init];
                [changed enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
                    [changedArray addObject:[NSIndexPath indexPathForItem:idx inSection:0]];
                }];
                [self.collectionView reloadItemsAtIndexPaths:changedArray];
            }
        } else {
            [self.collectionView reloadData];
        }
    });
}

@end
