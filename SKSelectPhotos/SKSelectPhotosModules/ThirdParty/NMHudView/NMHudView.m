//
//  NMHudView.m
//  xiangwan
//
//  Created by mac on 2020/1/10.
//  Copyright © 2020 mac. All rights reserved.
//

#import "NMHudView.h"
#import "UIView+Animation.h"

@interface NMHudView()
@property (nonatomic, weak) UIView *loadView;
@end

@implementation NMHudView

+ (instancetype)showHUD{
    [self hideHUD];
    UIWindow *lastWindow = kGetLastWindow();
    NMHudView *hud = [[NMHudView alloc] initWithFrame:lastWindow.bounds];
    [lastWindow addSubview:hud];
    return hud;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    CGFloat wh = 80;
    UIView *loadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wh, wh)];
    loadView.backgroundColor = COLORFFFFFF();
    [self addSubview:loadView];
    loadView.center = self.center;
    [loadView makeRoundedCorner:14];

    UIImage *image = [UIImage imageNamed:@"public_loading"];
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake((wh-image.size.width)/2, (wh-image.size.height)/2, image.size.width, image.size.height)];
    iconView.image = image;
    [loadView addSubview:iconView];
    
    [iconView counterclockwiseRotationAnimationForBool:NO];

}

+ (BOOL)hideHUD{
    NMHudView *hud = [self HUDForView:kGetLastWindow()];
    if (hud != nil) {
        [UIView animateWithDuration:0.12 animations:^{
            hud.alpha = 0;
        } completion:^(BOOL finished) {
            [hud removeFromSuperview];
        }];
        return YES;
    }
    return NO;
}

+ (NMHudView *)HUDForView:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            return (NMHudView *)subview;
        }
    }
    return nil;
}

@end
