//
//  UIView+Extension.h
//  DiscountBeWorthBuy
//
//  Created by Nemo on 15/7/1.
//  Copyright (c) 2015年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^animationFinisnBlock)(void);

@interface UIView (Extension)

- (void)addGestureRecognizerBlock:(void(^_Nullable)(id  _Nonnull sender))block;

- (void)playAnimationForEndPoint:(CGPoint)point completion:(animationFinisnBlock _Nullable )completion;

@end
