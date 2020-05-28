//
//  UIButton+Extension.m
//  CelestiaClient
//
//  Created by mac on 2019/5/25.
//  Copyright © 2019 sunke. All rights reserved.
//

#import "UIButton+Extension.h"
#import <objc/runtime.h>

static NSString * const expandEdgeInsets = @"kExpandEdgeInsetsKey";


@implementation UIButton (Extension)


-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event{
    
    if(UIEdgeInsetsEqualToEdgeInsets(self.expandEdge, UIEdgeInsetsZero) || !self.enabled || self.hidden) {
        return [super pointInside:point withEvent:event];
    }
    
    //扩大原热区，设置需要扩大的半径。
    CGFloat widthDelta = self.expandEdge.left + self.expandEdge.right;
    CGFloat heightDelta = self.expandEdge.top + self.expandEdge.bottom;
    /// 通过取反  扩大点击区域
    CGRect bounds = CGRectInset(self.bounds, - widthDelta, - heightDelta);
    return CGRectContainsPoint(bounds, point);
    
}


- (void)setExpandEdge:(UIEdgeInsets)expandEdge {
    objc_setAssociatedObject(self, &expandEdgeInsets, [NSValue valueWithUIEdgeInsets:expandEdge], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


-(UIEdgeInsets)expandEdge {
    NSValue *value = objc_getAssociatedObject(self, &expandEdgeInsets);
    if(value) {
        return [value UIEdgeInsetsValue];
    } else {
        return UIEdgeInsetsZero;
    }
}
@end
