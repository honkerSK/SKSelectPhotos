//
//  PhotoEditViewController.h
//  xiangwan
//
//  Created by mac on 2019/10/29.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN
@class ZLPhotoModel;
@interface PhotoEditViewController : UIViewController

@property (nonatomic, strong) UIImage *oriImage;
@property (nonatomic, strong) ZLPhotoModel *model;
/**
 编辑图片后是否保存编辑后的图片至相册，默认YES
 */
@property (nonatomic, assign) BOOL saveNewImageAfterEdit;

@property (nonatomic, strong) NSArray<NSDictionary *> *clipRatios;

/**
 编辑图片后回调
 */
@property (nonatomic, copy) void (^callSelectClipImageBlock)(UIImage *image, PHAsset *asset);

@end

NS_ASSUME_NONNULL_END
