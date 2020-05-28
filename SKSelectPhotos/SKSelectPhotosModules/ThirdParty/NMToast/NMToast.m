//
//  NMToast.m
//  CQ_App
//
//  Created by mac on 2019/4/8.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "NMToast.h"
//#import "AppDelegate+AppService.h"

@implementation NMToast

+ (void)showSuccessTipMessage:(NSString *)msg {
    [self showTopTipMessage:msg color:SUCCESSCOLOR()];
}
+ (void)showWarningTipMessage:(NSString *)msg {
    [self showTopTipMessage:msg color:AUXILIARYCOLOR2()];
}
+ (void)showFailTipMessage:(NSString *)msg {
    [self showTopTipMessage:msg color:WARNINGCOLOR()];
}
+ (void)showTopTipMessage:(NSString *)msg color:(UIColor *)color{
    UIFont *font = FONTSIZE(16);
    CGFloat w = [msg widthForFont:font];
    if ((w + 48) >= nScreenWidth()) {
        w = (nScreenWidth() - 48);
    }
    CGFloat x = (nScreenWidth()-w)/2;
    CGFloat h = [msg heightForFont:font width:w];
    CGFloat tipH = h+32;
    CGFloat y = kSafeAreaTopHeight();
    if (tipH <= kStatusBarAndNavigationBarHeight) {
        tipH = kStatusBarAndNavigationBarHeight;
    }
    
    UIView *tipView = [[UIView alloc] initWithFrame:CGRectMake(0, -40, nScreenWidth(), tipH)];
    tipView.backgroundColor = color;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
    label.text = msg;
    label.numberOfLines = 0;
    label.font = font;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = MAINCOLOR();
    [tipView addSubview:label];

    tipView.bottom = 0;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:tipView];
    
    [UIView animateWithDuration:0.3 animations:^{
        tipView.top = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 delay:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            tipView.bottom = 0;
        } completion:^(BOOL finished) {
            [tipView removeFromSuperview];
        }];
    }];
    
    
}

@end
