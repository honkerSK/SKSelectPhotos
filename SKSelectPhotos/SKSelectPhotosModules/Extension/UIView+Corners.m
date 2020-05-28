//
//  UIView+Corners.m
//  CQ_App
//
//  Created by mac on 2019/4/8.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "UIView+Corners.h"

@implementation UIView (Corners)
/**
 *  设置圆角
 *
 *  @param cornerRadius 圆角半径
 */
- (void)makeRoundedCorner:(CGFloat)cornerRadius {
    CALayer *roundedlayer = [self layer];
    [roundedlayer setMasksToBounds:YES];
    [roundedlayer setCornerRadius:cornerRadius];
}

/**
 *  画Top阴影
 */
-(void)makeTopShadow {
    [self makeShadowOffset:CGSizeMake(0, 0) shadowOpacity:1];
}

/**
 *  画Top阴影
 *  shadowOpacity
 */
-(void)makeTopShadowShadowOpacity:(CGFloat)shadowOpacity {
    [self makeShadowOffset:CGSizeMake(0, -3) shadowOpacity:shadowOpacity];
}

/**
 *  画半角
 */
-(void)makeCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii {
    
    [self layoutIfNeeded];
    
    UIBezierPath *stateLbPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *stateLayer = [[CAShapeLayer alloc] init];
    stateLayer.frame = self.bounds;
    stateLayer.path = stateLbPath.CGPath;
    self.layer.mask = stateLayer;
}
-(void)makeCorners:(UIRectCorner)corners
     cornerRadius:(CGFloat)cornerRadius
     shadowOpacity:(CGFloat)shadowOpacity
      shadowOffset:(CGSize)shadowOffset
       shadowColor:(UIColor *)shadowColor
       cornerRadii:(CGSize)cornerRadii {
    UIBezierPath *stateLbPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *stateLayer = [[CAShapeLayer alloc] init];
    stateLayer.shadowOpacity = shadowOpacity;
    stateLayer.frame = self.bounds;
    stateLayer.path = stateLbPath.CGPath;
    self.layer.mask = stateLayer;
}

/**
 *  画阴影
 */
-(void)makeShadowOffset:(CGSize)offset shadowOpacity:(CGFloat)shadowOpacity {

    self.layer.shadowOpacity = shadowOpacity;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = 2;
    self.layer.shadowColor = SHADOWCOLOR().CGColor;
}

-(void)blurEffect{
    [self blurEffectWithStyle:UIBlurEffectStyleLight Alpha:0.9];
}

-(void)blurEffectWithStyle:(UIBlurEffectStyle)style Alpha:(CGFloat)alpha{
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:style];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.frame = CGRectMake(0, 0, self.bounds.size.width,self.bounds.size.height);
    effectview.alpha = alpha;
    [self addSubview:effectview];
}



///画顶部线
- (void)drawTopLine{
    CALayer *topLine = [[CALayer alloc] init];
    topLine.frame = CGRectMake(0, 0, nScreenWidth(), 0.5);
    topLine.backgroundColor = COLOREDEDED().CGColor;
    [self.layer addSublayer:topLine];
}
- (void)drawTopLineWithLeft:(CGFloat)left right:(CGFloat)right{
    CALayer *topLine = [[CALayer alloc] init];
    topLine.frame = CGRectMake(left, 0, nScreenWidth()-right, 0.5);
    topLine.backgroundColor = COLOREDEDED().CGColor;
    [self.layer addSublayer:topLine];
}

///画底部线
- (void)drawBottomLineWithViewHeight:(CGFloat)viewHeight{
    CALayer *bottomLine = [[CALayer alloc] init];
    bottomLine.frame = CGRectMake(0, viewHeight-0.5, nScreenWidth(), 0.5);
    bottomLine.backgroundColor = COLOREDEDED().CGColor;
    [self.layer addSublayer:bottomLine];
}

///画底部线 , 父视图底部固定后调用
- (void)drawBottomLineWithLeft:(CGFloat)left right:(CGFloat)right{
    UIView *bottomLine = [[UIView alloc] init];
    [self addSubview:bottomLine];
    bottomLine.backgroundColor = COLOREDEDED();
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(left);
        make.right.mas_equalTo(right);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}

@end
