//
//  CollectionViewCell.h
//  Photos
//
//  Created by qiyu on 2020/4/16.
//  Copyright © 2020 com.qiyu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *thumbnailImage;
@property (nonatomic, strong) UIImage *livePhotoBadgeImage;
@property (nonatomic, strong) NSString *representedAssetIdentifier;

@end

NS_ASSUME_NONNULL_END
