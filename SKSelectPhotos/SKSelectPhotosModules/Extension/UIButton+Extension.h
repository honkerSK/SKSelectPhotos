//
//  UIButton+Extension.h
//  CQ_App
//
//  Created by mac on 2019/5/13.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Extension)

/// 扩大区域（以按钮的UIButton为中心向 top, left, bottom, right 点击区域扩大）
@property (nonatomic, assign) UIEdgeInsets expandEdge;


@end

NS_ASSUME_NONNULL_END
