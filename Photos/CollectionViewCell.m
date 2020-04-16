//
//  CollectionViewCell.m
//  Photos
//
//  Created by qiyu on 2020/4/16.
//  Copyright © 2020 com.qiyu. All rights reserved.
//

#import "CollectionViewCell.h"

@interface CollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *livePhotoBadgeImageView;

@end

@implementation CollectionViewCell

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (UIImageView *)livePhotoBadgeImageView {
    if (!_livePhotoBadgeImageView) {
        _livePhotoBadgeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        [self addSubview:_livePhotoBadgeImageView];
    }
    return _livePhotoBadgeImageView;
}

- (void)setThumbnailImage:(UIImage *)image {
    _thumbnailImage = image;
    self.imageView.image = image;
}

- (void)setLivePhotoBadgeImage:(UIImage *)livePhotoBadgeImage {
    _livePhotoBadgeImage = livePhotoBadgeImage;
    self.livePhotoBadgeImageView.image = livePhotoBadgeImage;
}

-  (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
    self.livePhotoBadgeImageView.image = nil;
}

@end
