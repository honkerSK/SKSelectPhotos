//
//  NMIcnTleButton.h
//  xiangwan
//
//  Created by mac on 2019/11/14.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, NMIcnTleButtonType){
    NMIcnTleButtonTypeIconTop = 0,
    NMIcnTleButtonTypeIconBottom,
    NMIcnTleButtonTypeIconLeft,
    NMIcnTleButtonTypeIconRight,
};

@interface NMIcnTleButton : UIView

@property (nonatomic, assign) BOOL selected;

@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIFont *selectedTitleFont;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *selectedTitleColor;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *normalImage;
@property (nonatomic, strong) NSString *selectedImage;

@property (nonatomic, strong) NSString *imageUrl;

@property (nonatomic, copy) void(^touchAction)(void);

- (void)makeImageRoundedCorner:(CGFloat)cornerRadius;

- (instancetype)initType:(NMIcnTleButtonType)type;

+ (instancetype)iconInTop;
+ (instancetype)iconInBottom;
+ (instancetype)iconInRight;
//半圆旋转
- (void)halfPiDegreeRotation:(BOOL)b ;


@end

NS_ASSUME_NONNULL_END
