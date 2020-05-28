//
//  MainButton.h
//  xiangwan
//
//  Created by mac on 2019/8/6.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainButton : UIView

+ (instancetype)mainButton;

@property (nonatomic, copy) void(^clickBlock)(void);

@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) UIFont *font;

/// 正常文字颜色
@property (nonatomic, strong) UIColor *normalTextColor;
/// 选择（enabled、selected为NO）文字颜色
@property (nonatomic, strong) UIColor *selectedTextColor;

/// 正常背景颜色
@property (nonatomic, strong) UIColor *normalBgColor;
/// 选择（enabled、selected为NO）背景颜色
@property (nonatomic, strong) UIColor *selectedBgColor;

/// 正常边框线颜色
@property (nonatomic, strong) UIColor *normalBorderColor;
/// 选择（enabled、selected为NO）边框线颜色
@property (nonatomic, strong) UIColor *selectedBorderColor;

/// NO： 不可点击
@property(nonatomic,getter=isEnabled) BOOL enabled;

@property(nonatomic,getter=isSelected) BOOL selected;

@property (nonatomic, assign) CGFloat cornerRadius;
@end

NS_ASSUME_NONNULL_END
