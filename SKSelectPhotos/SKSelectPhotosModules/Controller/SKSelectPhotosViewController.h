//
//  SKSelectPhotosViewController.h
//  SKSelectPhotos
//
//  Created by sunke on 2020/4/21.
//  Copyright © 2020 KentSun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZLPhotoConfiguration.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, SelectType){
    SelectTypeNone = 0,
    SelectTypeOnlyImage,
    SelectTypeOnlyVideo,
    SelectTypeAll,
};

@class ZLPhotoModel;
@interface SKSelectPhotosViewController : UIViewController

@property (nonatomic, strong) NSMutableArray <ZLPhotoModel *>*datas;
///相册类型
@property (nonatomic, assign) SelectType type;
///可录视频时间
@property (nonatomic, assign) NSInteger maxRecordDuration;
///可选视频数
@property (nonatomic, assign) NSInteger maxVideoSelectCount;
///可选图片数
@property (nonatomic, assign) NSInteger maxImageSelectCount;
@property (nonatomic, strong) NSArray<NSDictionary *> *clipRatios;
///是否只选择图片
@property (nonatomic, assign) BOOL onlyImage;
///是否需要裁减
@property (nonatomic, assign) BOOL isCrop;
///点击完成按钮回调
@property (nonatomic, copy) void(^selectFinishBlock)(NSMutableArray <ZLPhotoModel *>*datas,SelectType type);
///选中图片回调
@property (nonatomic, copy, nullable) void (^selectImageBlock)(NSArray<UIImage *> *_Nullable images, NSArray<PHAsset *> *assets);

@end

NS_ASSUME_NONNULL_END
