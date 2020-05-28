//
//  NMAlertView.m
//  wallet
//
//  Created by MacBookPro on 2018/8/13.
//  Copyright © 2018年 Linkpulse Guangdong Network Technology Co., Ltd. All rights reserved.
//

#import "NMAlertView.h"
#import "NSString+Size.h"

///alertView  宽
#define AlertW (nScreenWidth()-52*2)
///各个栏目之间的距离
static const CGFloat NMSpace = 8.0;

///圆角
static const CGFloat NMRadius = 20.0;

///button高度
static const NSInteger NMButton = 48;

CG_INLINE CGRect NMSCREEN() {
    return [UIScreen mainScreen].bounds;
}

@interface NMAlertView()
//弹窗
@property (nonatomic,retain) UIView *alertView;
//title
@property (nonatomic,retain) UILabel *titleLbl;
//内容
@property (nonatomic,retain) UILabel *msgLbl;
//确认按钮
@property (nonatomic,retain) UIButton *sureBtn;
//取消按钮
@property (nonatomic,retain) UIButton *cancleBtn;
//横线线
@property (nonatomic,retain) UIView *lineView;
//竖线
@property (nonatomic,retain) UIView *verLineView;

/// 返回
@property (copy, nonatomic) NMAlertViewCompletionBlock resultBlock;

@property (nonatomic, assign) BOOL isClose;

@end

@implementation NMAlertView

+(instancetype)showWithTitle:(NSString *)title
                     message:(NSString *)message
           cancelButtonTitle:(NSString *)cancelButtonTitle
           otherButtonTitles:(NSArray *)otherButtonTitles
             completionBlock:(NMAlertViewCompletionBlock)completionBlock{
    
    NSString *firstObject = otherButtonTitles.count ? otherButtonTitles[0] : nil;
    
    NMAlertView *alert = [[NMAlertView alloc] initWithTitle:title message:message sureBtn:firstObject cancleBtn:cancelButtonTitle];
    
    if (completionBlock) {
        alert.resultBlock = completionBlock;
    }
    
    [alert showAlertView];
    
    return alert;
}

+(instancetype)showWithTitle:(NSString *)title
                     message:(NSString *)message
                       image:(NSString *)image
           cancelButtonTitle:(NSString *)cancelButtonTitle
           otherButtonTitles:(NSArray *)otherButtonTitles
             completionBlock:(NMAlertViewCompletionBlock)completionBlock{
    
    NMAlertView *alert = [[NMAlertView alloc] initWithTitle:title message:message image:image otherButtonTitles:otherButtonTitles cancleBtn:cancelButtonTitle];
    
    if (completionBlock) {
        alert.resultBlock = completionBlock;
    }
    
    [alert showAlertView];
    
    return alert;
}
+(instancetype)showWithView:(UIView *)view
                      title:(NSString *)title
                    message:(NSString *)message
          cancelButtonTitle:(NSString *)cancelButtonTitle
          otherButtonTitles:(NSArray *)otherButtonTitles
            completionBlock:(NMAlertViewCompletionBlock)completionBlock {
    
    NSString *firstObject = otherButtonTitles.count ? otherButtonTitles[0] : nil;
    
    NMAlertView *alert = [[NMAlertView alloc] initWithView:view title:title message:message sureBtn:firstObject cancleBtn:cancelButtonTitle];
    
    if (completionBlock) {
        alert.resultBlock = completionBlock;
    }
    
    [alert showAlertView];
    
    return alert;
}

+(instancetype)showUpdateWithTitle:(NSString *)title
                           message:(NSString *)message
                 cancelButtonTitle:(NSString *)cancelButtonTitle
                 otherButtonTitles:(NSArray *)otherButtonTitles
                   completionBlock:(NMAlertViewCompletionBlock)completionBlock {
    
    NSString *firstObject = otherButtonTitles.count ? otherButtonTitles[0] : nil;
    
    NMAlertView *alert = [[NMAlertView alloc] initWithTitle:title message:message close:(firstObject != nil) sureBtn:firstObject cancleBtn:cancelButtonTitle];
    
    if (completionBlock) {
        alert.resultBlock = completionBlock;
    }
    
    [alert showAlertView];
    
    return alert;
    
    return alert;
}
- (instancetype)init
{
    if (self == [super init]) {
        self.frame = NMSCREEN();
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7f];
        self.alertView = [[UIView alloc] init];
        self.alertView.backgroundColor = COLORFFFFFF();
        self.alertView.layer.cornerRadius = NMRadius;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message image:(NSString *)image otherButtonTitles:(NSArray *)otherButtonTitles cancleBtn:(NSString *)cancleTitle{
    if ([self init]) {
        UIImage *img = [UIImage imageNamed:image];
        
        NSAssert(img.size.height > 0 && img.size.width > 0, @"image can't nil! ! !");
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *close = [UIImage imageNamed:@"icon_close"];
        [btn setImage:close forState:UIControlStateNormal];
        btn.frame = CGRectMake(AlertW-close.size.width, 0, close.size.width, close.size.height);
        [btn addTarget:self action:@selector(closeWindows) forControlEvents:UIControlEventTouchUpInside];
        [self.alertView addSubview:btn];
        
        CGFloat alertH = 30 + img.size.height;
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake((AlertW-img.size.width)/2, 30, img.size.width, img.size.height)];
        imageV.image = img;
        [self.alertView addSubview:imageV];
        
        if (title && title.length > 0) {
            alertH += 8;
            UIFont *font = [UIFont  systemFontOfSize:14];
            CGFloat titleH = [title heightForFont:font width:AlertW-10];
            UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(5, alertH, AlertW-10, titleH)];
            titleLb.textColor = MAINCOLOR();
            titleLb.text = title;
            titleLb.font = font;
            titleLb.textAlignment = NSTextAlignmentCenter;
            [self.alertView addSubview:titleLb];
            alertH += titleH;
        }
        
        if (message && message.length > 0) {

            alertH += 8;
            
            CGFloat msgW = AlertW-2*NMSpace;
            CGFloat msgH = [message heightForMaxWidth:msgW font:FONTSIZE(14)];
            UILabel *msgLbl = [self GetAdaptiveLable:CGRectMake(NMSpace, alertH, msgW, msgH) AndText:message andIsTitle:NO];
            msgLbl.textAlignment = NSTextAlignmentCenter;
            msgLbl.textColor = COLOR888888();
            [self.alertView addSubview:msgLbl];
            
            alertH += msgH;
        }
        
        alertH += 16;
        [self drawLineRect:CGRectMake(0, alertH, AlertW, .5f)];
        
        NSArray *colors = @[[UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1],[UIColor colorWithRed:0 green:212/255.0 blue:231/255.0 alpha:1]];
        
        if (otherButtonTitles.count == 0 ||
            (otherButtonTitles.count == 1 && cancleTitle == nil)) {
            colors = @[[UIColor colorWithRed:0 green:212/255.0 blue:231/255.0 alpha:1]];
        }
        [self createButton:otherButtonTitles cancleTitle:cancleTitle buttonColors:colors action:@selector(buttonEvent:) y:alertH];
        
        alertH += NMButton;
        alertH += 1;
        self.alertView.frame = CGRectMake(0, 0, AlertW, alertH);
        self.alertView.layer.position = self.center;
        [self addSubview:self.alertView];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message sureBtn:(NSString *)sureTitle cancleBtn:(NSString *)cancleTitle
{
    if ([self init]) {
        
        CGFloat alertH = 2*NMSpace;
        
        if (title && title.length > 0) {
            alertH += NMSpace;
            CGFloat width = AlertW-4*NMSpace;
            CGFloat titleH = [title heightForFont:[UIFont boldSystemFontOfSize:16] width:width];
            UILabel *titleLbl = [self GetAdaptiveLable:CGRectMake(2*NMSpace, alertH, width, titleH) AndText:title andIsTitle:YES];
            titleLbl.textAlignment = NSTextAlignmentCenter;
            
            [self.alertView addSubview:titleLbl];
            alertH += titleH;
        }
        if (message && message.length > 0) {
            alertH += 8;
            CGFloat msgW = AlertW-2*NMSpace;
            CGFloat msgH = [message heightForMaxWidth:msgW font:FONTSIZE(14)];
            UILabel *msgLbl = [self GetAdaptiveLable:CGRectMake(NMSpace, alertH, msgW, msgH) AndText:message andIsTitle:NO];
            msgLbl.textAlignment = NSTextAlignmentCenter;
            
            [self.alertView addSubview:msgLbl];
            
            alertH += msgH;
        }
        
        alertH += 2*NMSpace;
        [self drawLineRect:CGRectMake(0, alertH, AlertW, .5f)];
        
        NSArray *others = sureTitle?@[sureTitle]:nil;
        NSArray *colors = @[[UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1],[UIColor colorWithRed:0 green:212/255.0 blue:231/255.0 alpha:1]];
        if (others.count == 0 ||
                (others.count == 1 && cancleTitle == nil)) {
            colors = @[[UIColor colorWithRed:0 green:212/255.0 blue:231/255.0 alpha:1]];
        }
        [self createButton:others cancleTitle:cancleTitle buttonColors:colors action:@selector(buttonEvent:) y:alertH];
        
        alertH += NMButton;
        alertH += 1;
        
        self.alertView.frame = CGRectMake(0, 0, AlertW, alertH);
        self.alertView.layer.position = self.center;
        
        [self addSubview:self.alertView];
    }
    
    return self;
}

- (instancetype)initWithView:(UIView *)view title:(NSString *)title message:(NSString *)message sureBtn:(NSString *)sureTitle cancleBtn:(NSString *)cancleTitle
{
    if ([self init]) {
        
        CGFloat alertH = 0;
        
        if (view) {
            [self.alertView addSubview:view];
            alertH += (view.origin.y+view.size.height);
        }
        
        if (title && title.length > 0) {
            alertH += NMSpace;
            CGFloat width = AlertW-4*NMSpace;
            CGFloat titleH = [title heightForMaxWidth:width font:FONTSIZE(16)];
            UILabel *titleLbl = [self GetAdaptiveLable:CGRectMake(2*NMSpace, alertH, width, titleH) AndText:title andIsTitle:YES];
            titleLbl.textAlignment = NSTextAlignmentCenter;
            
            [self.alertView addSubview:titleLbl];
            alertH += titleH;
        }
        if (message && message.length > 0) {
            alertH += NMSpace;
            CGFloat msgW = AlertW-2*16;
            CGFloat msgH = [message heightForMaxWidth:msgW font:FONTSIZE(14)];
            UILabel *msgLbl = [self GetAdaptiveLable:CGRectMake(16, alertH, msgW, msgH) AndText:message andIsTitle:NO];
            msgLbl.textAlignment = NSTextAlignmentCenter;
            msgLbl.textColor = COLOR888888();
            [self.alertView addSubview:msgLbl];
            
            alertH += msgH;
        }
        
        alertH += 2*NMSpace;
        [self drawLineRect:CGRectMake(0, alertH, AlertW, .5f)];
        
        NSArray *others = sureTitle?@[sureTitle]:nil;
        NSArray *colors = @[[UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1],[UIColor colorWithRed:0 green:212/255.0 blue:231/255.0 alpha:1]];
        if (others.count == 0 ||
            (others.count == 1 && cancleTitle == nil)) {
            colors = @[[UIColor colorWithRed:0 green:212/255.0 blue:231/255.0 alpha:1]];
        }
        [self createButton:others cancleTitle:cancleTitle buttonColors:colors action:@selector(buttonEvent:) y:alertH];
        
        alertH += NMButton;
        alertH += 1;
        
        self.alertView.frame = CGRectMake(0, 0, AlertW, alertH);
        self.alertView.layer.position = self.center;
        
        [self addSubview:self.alertView];
    }
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message close:(BOOL)showClose sureBtn:(NSString *)sureTitle cancleBtn:(NSString *)cancleTitle{
    
    if ([self init]) {
        CGFloat alertH = 60;
        
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"public_update_window_bg"]];
        iv.frame = CGRectMake(0, 0, AlertW, alertH);
        [self.alertView addSubview:iv];
        self.isClose = !showClose;
        if (showClose) {
            UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [closeBtn setImage:[UIImage imageNamed:@"public_page_close"] forState:UIControlStateNormal];
            closeBtn.frame = CGRectMake(AlertW-30, NMSpace, 24, 24);
            [closeBtn addTarget:self action:@selector(closeWindows) forControlEvents:UIControlEventTouchUpInside];
            [self.alertView addSubview:closeBtn];
        }
        
        if (title && title.length > 0) {
            CGFloat width = AlertW-4*NMSpace;
            CGFloat titleH = [title heightForFont:[UIFont boldSystemFontOfSize:16] width:width];
            UILabel *titleLbl = [self GetAdaptiveLable:CGRectMake(2*NMSpace, 21, width, titleH) AndText:title andIsTitle:YES];
            titleLbl.textColor = COLORC7A468();
            titleLbl.textAlignment = NSTextAlignmentLeft;
            [self.alertView addSubview:titleLbl];
        }
        if (message && message.length > 0) {
            alertH += 16;
            CGFloat msgW = AlertW-2*NMSpace;
            CGFloat msgH = [message heightForMaxWidth:msgW font:FONTSIZE(14)];
            UILabel *msgLbl = [self GetAdaptiveLable:CGRectMake(2*NMSpace, alertH, msgW, msgH) AndText:message andIsTitle:NO];
            msgLbl.textAlignment = NSTextAlignmentLeft;
            
            [self.alertView addSubview:msgLbl];
            
            alertH += msgH;
        }
        
        alertH += 2*NMSpace;
        [self drawLineRect:CGRectMake(0, alertH, AlertW, .5f)];
        
        NSArray *others = sureTitle?@[sureTitle]:nil;
        NSArray *colors = @[[UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1],[UIColor colorWithRed:0 green:212/255.0 blue:231/255.0 alpha:1]];
        if (others.count == 0 ||
            (others.count == 1 && cancleTitle == nil)) {
            colors = @[[UIColor colorWithRed:0 green:212/255.0 blue:231/255.0 alpha:1]];
        }
        [self createButton:others cancleTitle:cancleTitle buttonColors:colors action:@selector(buttonEvent:) y:alertH];
        
        alertH += NMButton;
        alertH += 1;
        
        self.alertView.frame = CGRectMake(0, 0, AlertW, alertH);
        self.alertView.layer.position = self.center;
        
        [self addSubview:self.alertView];
    }
    return self;
}
#pragma mark - 弹出
- (void)showAlertView
{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    [self creatShowAnimation];
}

- (void)creatShowAnimation
{
    self.alertView.layer.position = self.center;
    self.alertView.transform = CGAffineTransformMakeScale(0.90, 0.90);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.alertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
}

- (void)createButton:(NSArray *)otherButtonTitles
         cancleTitle:(NSString *)cancleTitle
         buttonColors:(NSArray <UIColor *>*)colors
              action:(SEL)action
                   y:(CGFloat)y{
    if(otherButtonTitles.count > 0 || cancleTitle.length > 0){
        NSMutableArray *titles = [NSMutableArray arrayWithArray:otherButtonTitles];
        if (cancleTitle && cancleTitle.length > 0) {
            [titles insertObject:cancleTitle atIndex:0];
        }
        NSInteger count = titles.count;
        CGFloat w = (AlertW-count*1)/count;
        for (int i = 0 ; i < count; i ++) {
            NSString *tle = titles[i];
            CGFloat x = i*(w+1);
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            btn.frame = CGRectMake(x, y+1, w, NMButton);
            [btn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.2]] forState:UIControlStateNormal];
            [btn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.2]] forState:UIControlStateSelected];
            [btn setTitle:tle forState:UIControlStateNormal];
            if (colors.count - 1 >= i) {
                [btn setTitleColor:colors[i] forState:UIControlStateNormal];
            }else{
                [btn setTitleColor:[UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1] forState:UIControlStateNormal];
            }
            if (action) {
                [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
            }
            btn.tag = i;
            if (count % 2 == 0 && i > 0) {
                CALayer *linelr = [CALayer layer];
                linelr.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1].CGColor;
                linelr.frame = CGRectMake(x-1, y, .5f, NMButton+1);
                [self.alertView.layer addSublayer:linelr];
            }
            if ((i == 0) ||
                (i == count - 1)) {
                UIRectCorner corner = UIRectCornerBottomLeft;
                if (count == 1) {
                    corner = (UIRectCornerBottomLeft | UIRectCornerBottomRight);
                }else if (i == count - 1) {
                    corner = UIRectCornerBottomRight;
                }
                UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:btn.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(NMRadius, NMRadius)];
                CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                maskLayer.frame = btn.bounds;
                maskLayer.path = maskPath.CGPath;
                btn.layer.mask = maskLayer;
            }
            [self.alertView addSubview:btn];
        }
    }
}

#pragma mark - 回调 -设置只有2  -- > 确定才回调
- (void)buttonEvent:(UIButton *)sender {
    NMAlertViewCompletionBlock block = self.resultBlock;
    if (block) {
        block(sender.tag);
    }
    if (!self.isClose) {
        [self closeWindows];
    }
}
- (void)closeWindows {
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.alertView.transform = CGAffineTransformMakeScale(0.90, 0.90);
    } completion:^(BOOL finished) {
        [self removeView];
    }];
}
- (void)removeView {
    /// 主线程主队列
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
        // do something in main thread
        [self removeFromSuperview];
    } else {
        // do something in other thread
        kDISPATCH_MAIN_THREAD(^{
            [self removeFromSuperview];
        });
    }
}
-(UILabel *)GetAdaptiveLable:(CGRect)rect AndText:(NSString *)contentStr andIsTitle:(BOOL)isTitle {
    UILabel *contentLbl = [[UILabel alloc] initWithFrame:rect];
    contentLbl.textColor = MAINCOLOR();
    contentLbl.numberOfLines = 0;
    contentLbl.text = contentStr;
    contentLbl.textAlignment = NSTextAlignmentCenter;
    if (isTitle) {
        contentLbl.font = FONTSIZE(16);
    }else{
        contentLbl.font = FONTSIZE(14);
    }
    /**
    NSMutableAttributedString *mAttrStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
    NSMutableParagraphStyle *mParaStyle = [[NSMutableParagraphStyle alloc] init];
    mParaStyle.lineBreakMode = NSLineBreakByCharWrapping;
    [mParaStyle setLineSpacing:3.0];
    [mAttrStr addAttribute:NSParagraphStyleAttributeName value:mParaStyle range:NSMakeRange(0,[contentStr length])];
    [contentLbl setAttributedText:mAttrStr];
    [contentLbl sizeToFit];
     */
    
    return contentLbl;
}

-(UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


#pragma mark - 画线
-(void)drawLineRect:(CGRect)rect{
    CALayer *linelr = [CALayer layer];
    linelr.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1].CGColor;
    linelr.frame = rect;
    [self.alertView.layer addSublayer:linelr];
}


@end
