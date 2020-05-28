//
//  UIView+Animation.h
//  CQ_App
//
//  Created by mac on 2019/4/18.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Animation)

///左右抖动动画
- (void)shakeAnimationTranslationX;
///上下抖动动画
- (void)shakeAnimationTranslationY;
///上下抖动动画
- (void)dropAnimationTranslationY;

///缩放动画
- (void)addScaleAnimationRepeatCount:(float)repeatCount;
- (void)addOnceScaleAnimationValues:(NSArray *)values;

//渐变动画
- (void)gradientAnimation;
//从小变大动画
- (void)showSmallToBigAnimation;

///3D旋转动画
- (void)addRotateAnimationOnView:(UIView *)animationView;
///2D旋转动画
-(void)rotateAnimation:(CGFloat)rotation;
///背景颜色渐变动画
-(void)backgroundColorAnimation:(CGFloat)duration fromColor:(UIColor *)fColor toColor:(UIColor *)tColor;
///菊花旋转动画 YES:(逆时针动画)
- (void)counterclockwiseRotationAnimationForBool:(BOOL)b;
///移除所有动画
- (void)removeAllAnimations;
@end

NS_ASSUME_NONNULL_END
