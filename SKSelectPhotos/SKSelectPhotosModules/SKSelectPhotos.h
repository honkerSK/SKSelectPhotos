//
//  SKSelectPhotos.h
//  SKSelectPhotos
//
//  Created by sunke on 2020/4/22.
//  Copyright © 2020 KentSun. All rights reserved.
//

#ifndef SKSelectPhotos_h
#define SKSelectPhotos_h


#import <Masonry.h>
#import <YYCategories.h>
#import "UIView+Corners.h"
#import "UITableViewCell+Extension.h"
#import "UICollectionViewCell+Extension.h"

#import "NMToast.h"
#import "NMHudView.h"

#import "SKSelectPhotosViewController.h"

//#import <SDWebImage/UIImageView+WebCache.h>
//#import <SDWebImage/SDImageCache.h>
//#import <SDWebImage/SDWebImageManager.h>


#define WeakSelf __weak typeof(self) weakSelf = self;


//数据验证
#define StrValid(f) (f!=nil && [f isKindOfClass:[NSString class]] && ![f isEqualToString:@""])
#define SafeStr(f) (StrValid(f) ? f:@"")
#define HasString(str,key) ([str rangeOfString:key].location!=NSNotFound)

#define ValidStr(f) StrValid(f)
#define ValidDict(f) (f!=nil && [f isKindOfClass:[NSDictionary class]] && [f count]>0)
#define ValidArray(f) (f!=nil && [f isKindOfClass:[NSArray class]] && [f count]>0)
#define ValidNum(f) (f!=nil && [f isKindOfClass:[NSNumber class]])
#define ValidClass(f,cls) (f!=nil && [f isKindOfClass:[cls class]])
#define ValidData(f) (f!=nil && [f isKindOfClass:[NSData class]])

#define kStatusBarAndNavigationBarHeight (nScreenHeight() >= 812.0 ? 88.f : 64.f)
#define kSafeAreaBottomHeight (nScreenHeight() >= 812.0 ? 34.0f : 0.0)
#define kTabbarHeight (nScreenHeight() >= 812.0 ? 83.f : 49.f)

//CG_INLINE CGFloat nScreenWidth() {
//    return [[UIScreen mainScreen] bounds].size.width;
//}
//CG_INLINE CGFloat nScreenHeight() {
//    return [[UIScreen mainScreen] bounds].size.height;
//}

CG_INLINE CGFloat nScreenWidth() {
    return YYScreenSize().width;
}
CG_INLINE CGFloat nScreenHeight() {
    return YYScreenSize().height;
}

CG_INLINE CGFloat kSafeAreaTopHeight() {
    return [[UIApplication sharedApplication] statusBarFrame].size.height;
}


#pragma mark ————— 多线程内联函数 —————
//GCD - 一次性执行
CG_INLINE void kDISPATCH_ONCE_BLOCK(dispatch_block_t onceBlock) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, onceBlock);
}

//GCD - 在Main线程上运行
CG_INLINE void kDISPATCH_MAIN_THREAD(dispatch_block_t block) {
    dispatch_async(dispatch_get_main_queue(), block);
}
//GCD - 开启异步线程
CG_INLINE void kDISPATCH_GLOBAL_QUEUE_DEFAULT(dispatch_block_t block) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}
//GCD - 延时
CG_INLINE void kDISPATCH_AFTER(CGFloat seconds,dispatch_block_t block) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

#pragma mark ————— 获取系统对象内联方法 —————

CG_INLINE UIWindow *kGetLastWindow() {
    UIWindow *lastWindow = [UIApplication sharedApplication].keyWindow;
    if (!lastWindow) {
        lastWindow = [UIApplication sharedApplication].windows.lastObject;
    }
    return lastWindow;
}


#pragma mark - ——————— 字体相关 ————————

CG_INLINE UIFont *FONTSIZE(CGFloat a) {
    return [UIFont fontWithName:@"PingFangSC-Regular" size:a];
}
CG_INLINE UIFont *FONTBOLDSIZE(CGFloat a) {
    return [UIFont fontWithName:@"PingFangSC-Semibold" size:a];
}


#pragma mark ————— UICOLOR内联方法 —————
/**
 *  输入RGBA值获取颜色
 *
 *  @param r RED值
 *  @param g GREEN值
 *  @param b BLUE值
 *  @param a 透明度
 *
 *  @return UIColor
 */

CG_INLINE UIColor * RGBACOLOR(CGFloat r,CGFloat g,CGFloat b,CGFloat a) {
    return [UIColor colorWithRed:(r) / 255.0f green:(g) / 255.0f blue:(b) / 255.0f  alpha:(a)];
}

/**
 输入RGB值获取颜色
 
 @param r RED值
 @param g GREEN值
 @param b BLUE值
 @return UIColor
 */
CG_INLINE UIColor * RGBCOLOR(CGFloat r,CGFloat g,CGFloat b) {
    return [UIColor colorWithRed:(r) / 255.0f green:(g) / 255.0f blue:(b) / 255.0f  alpha:1];
}
/**
 *  输入16进制值获取颜色
 *
 *  @param rgbValue 16进制值
 *
 *  @return UIColor
 */
CG_INLINE UIColor * HEXCOLOR(NSUInteger rgbValue) {
    return [UIColor colorWithRed:(((float)((rgbValue & 0xFF0000) >> 16))) / 255.0f green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0f blue:((float)(rgbValue & 0xFF)) / 255.0f  alpha:1];
}
/**
 随机颜色
 
 @return 随机颜色
 */
CG_INLINE UIColor * RandomColor() {
    return [UIColor colorWithRed:arc4random_uniform(256) / 255.0f green:arc4random_uniform(256) / 255.0f blue:arc4random_uniform(256) / 255.0f  alpha:1];
}

//品牌色
CG_INLINE UIColor *BRANDCOLOR() {
    return RGBACOLOR(0, 212, 231, 1.0);
}
//辅助色
CG_INLINE UIColor *AUXILIARYCOLOR() {
    return RGBACOLOR(199, 164, 104, 1.0);
}
//辅助色2
CG_INLINE UIColor *AUXILIARYCOLOR2() {
    return RGBACOLOR(250, 244, 235, 1.0);
}
//成功色
CG_INLINE UIColor *SUCCESSCOLOR() {
    return HEXCOLOR(0x4CD964);
}
//警告色
CG_INLINE UIColor *WARNINGCOLOR() {
    return RGBACOLOR(230, 47, 92, 1.0);
}

//灰色2 (和GRAYCOLOR 重复)
CG_INLINE UIColor * COLOR888888() {
    return RGBACOLOR(136, 136, 136, 1.0);
}
// 灰色3
CG_INLINE UIColor *COLORCCCCCC() {
    return RGBACOLOR(204, 204, 204, 1.0);
}

//灰色4 分割线颜色
CG_INLINE UIColor *COLOREDEDED() {
    return RGBACOLOR(237, 237, 237, 1.0);
}
//灰色5
CG_INLINE UIColor *COLORF9F9F9() {
    return RGBACOLOR(249, 249, 249, 1.0);
}
// 黑色 COLOR222222(透明度)
CG_INLINE UIColor *MAINCOLORA(CGFloat alpha) {
    return RGBACOLOR(34, 34, 34, alpha);
}
// 黑色 COLOR222222
CG_INLINE UIColor *MAINCOLOR() {
    return MAINCOLORA(1.0);
}
// 白色
CG_INLINE UIColor *COLORFFFFFF() {
    return [UIColor whiteColor];
}
CG_INLINE UIColor *SHADOWCOLOR() {
    return RGBACOLOR(0, 26, 37, 0.2);
}


/// 活力圈创建时间颜色 #C7A468
CG_INLINE UIColor *COLORC7A468() {
    return RGBACOLOR(199, 164, 104, 1.0);
}



#ifdef DEBUG
#define NSLog(format, ...) printf("[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define NSLog(format, ...)
#endif

#endif /* SKSelectPhotos_h */
