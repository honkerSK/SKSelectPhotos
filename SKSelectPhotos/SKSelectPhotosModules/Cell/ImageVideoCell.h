//
//  ImageVideoCell.h
//  xiangwan
//
//  Created by mac on 2019/8/15.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZLPhotoModel.h>

typedef NS_ENUM(NSInteger, ImageVideoCellType){
    ImageVideoCellTypeDef = 0,
    ImageVideoCellTypeImage,
    ImageVideoCellTypeVideo,
};

NS_ASSUME_NONNULL_BEGIN

@interface ImageVideoCell : UICollectionViewCell
/// 大于一个
@property (nonatomic, assign) BOOL moreOne;

@property (nonatomic, strong) ZLPhotoModel *model;

@property (nonatomic, assign) ImageVideoCellType type;

@property (nonatomic, copy) void(^selectAction)(void);

@property (nonatomic, copy) void(^showAction)(void);

@end


@interface TakePhotoCell : UICollectionViewCell

@property (nonatomic, copy) void(^takePhotoAction)(void);

@end

NS_ASSUME_NONNULL_END
