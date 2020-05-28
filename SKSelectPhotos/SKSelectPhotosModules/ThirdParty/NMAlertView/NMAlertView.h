//
//  NMAlertView.h
//  wallet
//
//  Created by MacBookPro on 2018/8/13.
//  Copyright © 2018年 Linkpulse Guangdong Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NMAlertViewCompletionBlock)(NSInteger index);

@interface NMAlertView : UIView
/// 不带图片弹窗
+(instancetype)showWithTitle:(NSString *)title
                     message:(NSString *)message
           cancelButtonTitle:(NSString *)cancelButtonTitle
           otherButtonTitles:(NSArray *)otherButtonTitles
             completionBlock:(NMAlertViewCompletionBlock)completionBlock;
/// 自定义view弹窗
+(instancetype)showWithView:(UIView *)view
                      title:(NSString *)title
                     message:(NSString *)message
           cancelButtonTitle:(NSString *)cancelButtonTitle
           otherButtonTitles:(NSArray *)otherButtonTitles
             completionBlock:(NMAlertViewCompletionBlock)completionBlock;
/// 带图片弹窗
+(instancetype)showWithTitle:(NSString *)title
                     message:(NSString *)message
                       image:(NSString *)image
           cancelButtonTitle:(NSString *)cancelButtonTitle
           otherButtonTitles:(NSArray *)otherButtonTitles
             completionBlock:(NMAlertViewCompletionBlock)completionBlock;

/// 更新弹窗
+(instancetype)showUpdateWithTitle:(NSString *)title
                           message:(NSString *)message
                 cancelButtonTitle:(NSString *)cancelButtonTitle
                 otherButtonTitles:(NSArray *)otherButtonTitles
                   completionBlock:(NMAlertViewCompletionBlock)completionBlock;

@end
