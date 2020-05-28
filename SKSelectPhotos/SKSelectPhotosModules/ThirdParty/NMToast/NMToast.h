//
//  NMToast.h
//  CQ_App
//
//  Created by mac on 2019/4/8.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NMToast : UIView

+ (void)showSuccessTipMessage:(NSString *)msg;
+ (void)showWarningTipMessage:(NSString *)msg;
+ (void)showFailTipMessage:(NSString *)msg;

@end

NS_ASSUME_NONNULL_END
