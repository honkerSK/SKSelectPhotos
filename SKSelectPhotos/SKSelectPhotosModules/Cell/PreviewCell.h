//
//  PreviewCell.h
//  xiangwan
//
//  Created by mac on 2019/8/17.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZLPhotoModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface PreviewCell : UICollectionViewCell

@property (nonatomic, strong) ZLPhotoModel *model;

@property (nonatomic, copy) void(^cellTap)(void);
@end

NS_ASSUME_NONNULL_END
