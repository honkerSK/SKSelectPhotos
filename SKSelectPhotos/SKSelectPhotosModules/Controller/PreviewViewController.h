//
//  PreviewViewController.h
//  xiangwan
//
//  Created by mac on 2019/8/17.
//  Copyright © 2019 mac. All rights reserved.
//
// 预览
//#import "CYLBaseViewController.h"

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PreviewViewType){
    PreviewViewTypeNormal = 0,
    PreviewViewTypePreview,
    PreviewViewTypeEdit,
};

NS_ASSUME_NONNULL_BEGIN

@class ZLPhotoModel;
@interface PreviewViewController : UIViewController

@property (nonatomic, strong) NSMutableArray <ZLPhotoModel *>*datas;

@property (nonatomic, assign) NSInteger idx;

@property (nonatomic, copy) void(^reloadAction)(NSMutableArray <ZLPhotoModel *>*data);

@property (nonatomic, copy) void(^cancelAction)(ZLPhotoModel *obj);

@property (nonatomic, assign) PreviewViewType type;

@end

NS_ASSUME_NONNULL_END
