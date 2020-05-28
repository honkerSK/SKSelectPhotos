//
//  UIView+Animation.m
//  CQ_App
//
//  Created by mac on 2019/4/18.
//  Copyright © 2019 mac. All rights reserved.
//

#import "UIView+Animation.h"

@implementation UIView (Animation)

- (void)shakeAnimationTranslationX {
    [self animationPath:@"transform.translation.x" fromValue:-3 toValue:3 duration:0.07 count:2];
}

- (void)shakeAnimationTranslationY {
    [self animationPath:@"transform.translation.y" fromValue:-5 toValue:5 duration:0.25 count:3];
}
-(void)dropAnimationTranslationY {
    return [self animationPath:@"transform.translation.y" fromValue:-5 toValue:5 duration:0.2 count:0];
}
- (void)animationPath:(NSString *)path fromValue:(CGFloat)fValue toValue:(CGFloat)toValue duration:(CGFloat)duration count:(CGFloat)count{
    
    CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:path];
    shakeAnimation.fromValue = [NSNumber numberWithFloat:fValue];
    shakeAnimation.toValue = [NSNumber numberWithFloat:toValue];
    shakeAnimation.autoreverses = YES;
    // 设置时间
    [shakeAnimation setDuration:duration];
    // 设置次数
    [shakeAnimation setRepeatCount:count];
    [self.layer addAnimation:shakeAnimation forKey:nil];
}

//缩放动画
- (void)addScaleAnimationRepeatCount:(float)repeatCount {
    //需要实现的帧动画，这里根据需求自定义
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.values = @[@1.0,@1.3,@0.9,@1.15,@0.95,@1.02,@1.0];
    animation.duration = 1;
    animation.repeatCount = repeatCount;
    animation.calculationMode = kCAAnimationCubic;
    [self.layer addAnimation:animation forKey:nil];
}

//缩放动画
- (void)addOnceScaleAnimationValues:(NSArray *)values {
    //需要实现的帧动画，这里根据需求自定义
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.values = values;
    animation.duration = 0.1;
    animation.calculationMode = kCAAnimationCubic;
    [self.layer addAnimation:animation forKey:nil];
}
//3d旋转动画
- (void)addRotateAnimationOnView:(UIView *)animationView {
    // 针对旋转动画，需要将旋转轴向屏幕外侧平移，最大图片宽度的一半
    // 否则背景与按钮图片处于同一层次，当按钮图片旋转时，转轴就在背景图上，动画时会有一部分在背景图之下。
    // 动画结束后复位
    animationView.layer.zPosition = 65.f / 2;
    [UIView animateWithDuration:0.32 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        animationView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
    } completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.70 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
            animationView.layer.transform = CATransform3DMakeRotation(2 * M_PI, 0, 1, 0);
        } completion:nil];
    });
}
//旋转动画
-(void)rotateAnimation:(CGFloat)rotation {
    
    [UIView beginAnimations:@"rotate" context:nil];
    [UIView setAnimationDuration:0.25];
    
    self.transform = CGAffineTransformMakeRotation(rotation);
    
    [UIView commitAnimations];
}
//从小变大动画
- (void)showSmallToBigAnimation{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.25;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [self.layer addAnimation:animation forKey:nil];
}
//渐变动画
- (void)gradientAnimation {
    CATransition *animation = [CATransition animation];
    animation.duration = 0.8;
    animation.type = kCATransitionFade;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.layer addAnimation:animation forKey:@"gradientAnimation"];
}
//背景颜色渐变动画
-(void)backgroundColorAnimation:(CGFloat)duration fromColor:(UIColor *)fColor toColor:(UIColor *)tColor {
    CABasicAnimation *anim1 = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    anim1.duration = duration;
    anim1.fromValue = (__bridge id _Nullable)(fColor.CGColor);
    anim1.toValue = (__bridge id _Nullable)(tColor.CGColor);;
    //填充效果：动画结束后，动画将保持最后的表现状态
    anim1.fillMode = kCAFillModeForwards;
    anim1.removedOnCompletion = NO;
    anim1.beginTime = 0.0f;
    [self.layer addAnimation:anim1 forKey:@"backgroundColor"];
}

- (void)counterclockwiseRotationAnimationForBool:(BOOL)b {
    CGFloat value = b ? (-M_PI *2):(M_PI *2);
    [self rotatingAnimationForTime:0.8 toValue:value];
}
- (void)rotatingAnimationForTime:(CGFloat)time toValue:(CGFloat)toValue {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue =  [NSNumber numberWithFloat: toValue];
    animation.duration  = time;
    animation.autoreverses = NO;
    animation.removedOnCompletion = NO;
    animation.fillMode =kCAFillModeForwards;
    animation.repeatCount = MAXFLOAT; //一直自旋转
    [self.layer addAnimation:animation forKey:@"NMRotating"];
}
- (void)removeAllAnimations {
    [self.layer removeAllAnimations];
}
@end
