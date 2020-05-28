//
//  NSObject+Extension.h
//  xiangwan
//
//  Created by mac on 2019/8/5.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Extension)
/// time延时（单位：秒）
- (void)performSelector:(SEL)selectors afterTime:(CGFloat)time;
- (void)performSelector:(SEL)selectors afterDelay:(CGFloat)time object:(nullable id)object;
//+ (instancetype)setKeyValue:(NSDictionary *)value;
@end

NS_ASSUME_NONNULL_END
