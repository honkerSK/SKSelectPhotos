//
//  UIImageView+Extension.h
//  xiangwan
//
//  Created by mac on 2020/1/9.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/SDWebImageManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (Extension)

- (void)xw_setImageWithURL:(nullable NSURL *)url;
- (void)xw_setImageWithURL:(nullable NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder;

- (void)xw_setImageWithURL:(NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder
                 completed:(nullable SDExternalCompletionBlock)completedBlock;

- (void)xw_setImageWithURL:(NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder options:(SDWebImageOptions)options
                  progress:(nullable SDImageLoaderProgressBlock)progressBlock
                 completed:(nullable SDExternalCompletionBlock)completedBlock;

@end

NS_ASSUME_NONNULL_END
