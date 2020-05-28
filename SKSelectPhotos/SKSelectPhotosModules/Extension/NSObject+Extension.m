//
//  NSObject+Extension.m
//  xiangwan
//
//  Created by mac on 2019/8/5.
//  Copyright © 2019 mac. All rights reserved.
//

#import "NSObject+Extension.h"

@implementation NSObject (Extension)

- (void)performSelector:(SEL)selectors afterTime:(CGFloat)time{
    [self performSelector:selectors afterDelay:time object:nil];
}
- (void)performSelector:(SEL)selectors afterDelay:(CGFloat)time object:(nullable id)object{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:selectors object:object];
    [self performSelector:selectors withObject:object afterDelay:time];
}

//+ (instancetype)setKeyValue:(NSDictionary *)value {
//    return [[[self alloc] init] mj_setKeyValues:value];
//}

@end
