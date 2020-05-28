//
//  UIView+Extension.m
//  DiscountBeWorthBuy
//
//  Created by Nemo on 15/7/1.
//  Copyright (c) 2015年 Nemo. All rights reserved.
//

#import "UIView+Extension.h"
#import <objc/runtime.h>


@interface UIView()<CAAnimationDelegate>
@property (nonatomic, strong) CALayer *cLy;
@property (nonatomic, copy) animationFinisnBlock block ;
@end

@implementation UIView (Extension)

- (void)playAnimationForEndPoint:(CGPoint)point completion:(animationFinisnBlock)completion{
    /// a -> b -> 结束点
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    CGRect rect = [self convertRect:self.bounds toView:keyWindow];
    
    self.cLy = [CALayer layer];
    self.cLy.contents = self.layer.contents;
    self.cLy.contentsGravity = kCAGravityResizeAspectFill;
    rect.size.width  = 16;
    rect.size.height = 16;   //重置图层尺寸
    self.cLy.bounds = rect;
    self.cLy.cornerRadius  = rect.size.width/2;
    self.cLy.masksToBounds = YES;          //圆角
    self.cLy.backgroundColor = RGBCOLOR(230, 47, 92).CGColor;
    
    [keyWindow.layer addSublayer:self.cLy];

    self.cLy.position = CGPointMake(rect.origin.x+self.frame.size.width/2, CGRectGetMidY(rect)); //a 点
    
    /// 路径动画
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:self.cLy.position];
    /// 第一个参数为结束点  第二参数为上升的b点
    [path addQuadCurveToPoint:point controlPoint:CGPointMake(nScreenWidth()/2, rect.origin.y-80)];
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.path = path.CGPath;
    /// 旋转动画
    CABasicAnimation *rotateAnimation   = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotateAnimation.removedOnCompletion = YES;
    rotateAnimation.fromValue = [NSNumber numberWithFloat:0];
    rotateAnimation.toValue   = [NSNumber numberWithFloat:12];
    rotateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    /// 添加动画动画组合
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[pathAnimation,rotateAnimation];
    groups.duration = 0.6f;
    groups.removedOnCompletion = NO;
    groups.fillMode=kCAFillModeForwards;
    groups.delegate = self;
    [self.cLy addAnimation:groups forKey:@"group"];
    
    self.block = completion;
}
#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (anim == [self.cLy animationForKey:@"group"]) {
        [self.cLy removeFromSuperlayer];
        self.cLy = nil;
        if (self.block) {
            self.block();
        }
    }
}


static void *strKey = &strKey;
static void *blockKey = &blockKey;
-(void)setCLy:(CALayer *)cLy {
    objc_setAssociatedObject(self, &strKey, cLy, OBJC_ASSOCIATION_RETAIN);
}
-(CALayer *)cLy {
    return objc_getAssociatedObject(self, &strKey);
}

-(void)setBlock:(animationFinisnBlock)block {
    objc_setAssociatedObject(self, &blockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(animationFinisnBlock)block {
    return objc_getAssociatedObject(self, &blockKey);
}

-(void)addGestureRecognizerBlock:(void (^)(id _Nonnull))block{
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        if (block) {
            block(sender);
        }
    }]];
}

@end
