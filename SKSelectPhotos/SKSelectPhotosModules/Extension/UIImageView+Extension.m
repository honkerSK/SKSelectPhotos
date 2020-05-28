//
//  UIImageView+Extension.m
//  xiangwan
//
//  Created by mac on 2020/1/9.
//  Copyright © 2020 mac. All rights reserved.
//

#import "UIImageView+Extension.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation UIImageView (Extension)


- (void)xw_setImageWithURL:(NSURL *)url {
    [self xw_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"empty_picture"]];
}
- (void)xw_setImageWithURL:(NSURL *)url placeholderImage:(nullable UIImage *)placeholder{
    [self xw_setImageWithURL:url placeholderImage:placeholder completed:nil];
}

- (void)xw_setImageWithURL:(NSURL *)url placeholderImage:(nullable UIImage *)placeholder completed:(nullable SDExternalCompletionBlock)completedBlock{
    [self xw_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:completedBlock];
}

- (void)xw_setImageWithURL:(NSURL *)url placeholderImage:(nullable UIImage *)placeholder options:(SDWebImageOptions)options progress:(nullable SDImageLoaderProgressBlock)progressBlock completed:(nullable SDExternalCompletionBlock)completedBlock {
    WeakSelf
    [self sd_setImageWithURL:url placeholderImage:placeholder options:options progress:progressBlock completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if(error){
            weakSelf.image =  [UIImage imageNamed:@"fail_picture"];
        }
        !completedBlock ?: completedBlock(image,error,cacheType,imageURL);
    }];
}

@end
