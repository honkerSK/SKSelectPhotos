//
//  MainButton.m
//  xiangwan
//
//  Created by mac on 2019/8/6.
//  Copyright © 2019 mac. All rights reserved.
//

#import "MainButton.h"
#import "UIView+Extension.h"

@interface MainButton()
@property (nonatomic, weak) UILabel *textLb;
@end

@implementation MainButton

+ (instancetype)mainButton {
    MainButton *btn = [[MainButton alloc] init];
    return btn;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = BRANDCOLOR();
    UILabel *textLb = [[UILabel alloc] init];
    textLb.font = FONTBOLDSIZE(16);
    textLb.textColor = MAINCOLOR();
    [self addSubview:textLb];
    self.textLb = textLb;
    [textLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    self.layer.borderWidth = 2;
    WeakSelf
    [self addGestureRecognizerBlock:^(id  _Nonnull sender) {
        [weakSelf tapAction];
    }];
    [self makeRoundedCorner:20];
}
- (void)tapAction {
    !self.clickBlock ?: self.clickBlock();
}
-(void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    [self setColor:enabled];
    self.userInteractionEnabled = enabled;
}
-(void)setFont:(UIFont *)font {
    _font = font;
    self.textLb.font = font;
}
-(void)setSelected:(BOOL)selected {
    _selected = selected;
    [self setColor:selected];
}
-(void)setNormalBgColor:(UIColor *)normalBgColor {
    _normalBgColor = normalBgColor;
    self.backgroundColor = normalBgColor;
}

-(void)setNormalBorderColor:(UIColor *)normalBorderColor {
    _normalBorderColor = normalBorderColor;
    self.layer.borderColor = normalBorderColor.CGColor;
}
-(void)setNormalTextColor:(UIColor *)normalTextColor {
    _normalTextColor = normalTextColor;
    self.textLb.textColor = normalTextColor;
}
- (void)setColor:(BOOL)b {
    
    UIColor *textColor = self.normalTextColor?:MAINCOLOR();
    UIColor *sTextColor = self.selectedTextColor?:COLORCCCCCC();
    self.textLb.textColor = b?textColor:sTextColor;
    
    CGColorRef borderColor = self.normalBorderColor.CGColor?:MAINCOLOR().CGColor;
    CGColorRef sBorderColor = self.selectedBorderColor.CGColor?:COLOREDEDED().CGColor;
    self.layer.borderColor = b?borderColor:sBorderColor;
    
    UIColor *bgColor = self.normalBgColor?:BRANDCOLOR();
    UIColor *sBgColor = self.selectedBgColor?:COLORFFFFFF();
    self.backgroundColor = b?bgColor:sBgColor;
}
-(void)setText:(NSString *)text {
    _text = text;
    self.textLb.text = text;
}
-(void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    [self makeRoundedCorner:cornerRadius];
}


@end
