//
//  UIView+Corners.h
//  CQ_App
//
//  Created by mac on 2019/4/8.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Corners)

/**
 *  设置圆角
 *
 *  @param cornerRadius 圆角半径
 */
-(void)makeRoundedCorner:(CGFloat)cornerRadius;

/**
 *  画半角
 */
-(void)makeCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;

/**
 *  画Top阴影
 */
-(void)makeTopShadow;
//-(void)makeTopShadowWidth:(CGFloat)width shadowOpacity:(CGFloat)shadowOpacity;
/**
 *  高斯模糊
 */
-(void)blurEffect;


/**
 *  带参数的高斯模糊效果
 *
 *  @param style 风格
 *  @param alpha 透明度
 */
-(void)blurEffectWithStyle:(UIBlurEffectStyle)style Alpha:(CGFloat)alpha;

///画顶部线
- (void)drawTopLine;
- (void)drawTopLineWithLeft:(CGFloat)left right:(CGFloat)right;

///画底部线 left 左边边距, right 右边距
- (void)drawBottomLineWithLeft:(CGFloat)left right:(CGFloat)right;
- (void)drawBottomLineWithViewHeight:(CGFloat)viewHeight;

@end

NS_ASSUME_NONNULL_END
