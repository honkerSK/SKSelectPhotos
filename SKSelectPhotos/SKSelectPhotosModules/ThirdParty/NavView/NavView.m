//
//  NavView.m
//  CQ_App
//
//  Created by mac on 2019/4/3.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "NavView.h"
#import "UIButton+Extension.h"

@interface NavView()
@property (nonatomic, weak) UILabel  *titleLb;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UILabel *leftLb;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UILabel *rightLb;
@property (nonatomic, strong) UIButton *moreBtn;
@end

@implementation NavView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    //设置标题
    UILabel *titleLb = [[UILabel alloc] init];
    [titleLb sizeToFit];
    titleLb.font = FONTSIZE(18);
    // 开始的时候看不见，所以alpha值为0
    titleLb.textColor = self.titleColor?:RGBACOLOR(34, 34, 34, 0);
    [self addSubview:titleLb];
    self.titleLb = titleLb;

    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.inset(10);
        make.height.mas_equalTo(24);
        make.width.mas_lessThanOrEqualTo(nScreenWidth()-112);
    }];
}

#pragma --mark action
- (void)leftBtnAction {
    !self.leftAction ?: self.leftAction();
}

- (void)rightBtnAction {
    !self.rightAction ?: self.rightAction();
}

- (void)moreBtnAction {
    if (self.moreIcon.length > 0) {
        !self.moreAction ?: self.moreAction();
    }
}

#pragma --mark set

-(void)setTitleView:(UIView *)titleView {
    _titleView = titleView;
    [self.titleLb addSubview:titleView];
    
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.titleLb);
        make.size.mas_equalTo(40);
    }];
}

- (void)setLeftIcon:(NSString *)leftIcon {
    _leftIcon = leftIcon;
    [self.leftBtn setImage:[UIImage imageNamed:leftIcon] forState:UIControlStateNormal];
    [self.leftBtn setImage:[UIImage imageNamed:leftIcon] forState:UIControlStateHighlighted];
}
-(void)setMoreIcon:(NSString *)moreIcon {
    _moreIcon = moreIcon;
    [self.moreBtn setImage:[UIImage imageNamed:moreIcon] forState:UIControlStateNormal];
    [self.moreBtn setImage:[UIImage imageNamed:moreIcon] forState:UIControlStateHighlighted];
}
- (void)setRightIcon:(NSString *)rightIcon {
    _rightIcon = rightIcon;
    [self.rightBtn setImage:[UIImage imageNamed:rightIcon] forState:UIControlStateNormal];
    [self.rightBtn setImage:[UIImage imageNamed:rightIcon] forState:UIControlStateHighlighted];
}
- (void)setRightTitle:(NSString *)rightTitle{
    _rightTitle = rightTitle;
    self.rightLb.text = rightTitle;
}
-(void)setRightTitleColor:(UIColor *)rightTitleColor {
    _rightTitleColor = rightTitleColor;
    self.rightLb.textColor = rightTitleColor;
}
- (void)setLeftTitle:(NSString *)leftTitle{
    _leftTitle = leftTitle;
    self.leftLb.text = leftTitle;
}
-(void)setLeftTitleColor:(UIColor *)leftTitleColor {
    _leftTitleColor = leftTitleColor;
    self.leftLb.textColor = leftTitleColor;

}
- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.titleLb.textColor = titleColor;
}
-(void)setTitle:(NSString *)title {
    _title = title;
    self.titleLb.text = title;
}

- (void)setBackgroundAlpha:(CGFloat)alpha {
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:alpha];
    self.titleLb.alpha = alpha;
}
- (void)layoutSubviews {
    [super layoutSubviews];

    
    if (_moreBtn) {
        CGFloat difference = 112 + 40;
        [_titleLb mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_lessThanOrEqualTo(nScreenWidth()-difference);
        }];
    }
    
    
}

-(UIButton *)moreBtn {
    if (_moreBtn == nil) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn addTarget:self action:@selector(moreBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_moreBtn];
        [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.inset(56);
            make.bottom.inset(10);
        }];
        [_moreBtn setExpandEdge:UIEdgeInsetsMake(5, 5, 5, 5)];
    }
    return _moreBtn;
}
-(UIButton *)leftBtn {
    if (_leftBtn == nil) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_leftBtn];
        [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.bottom.inset(10);
        }];
        [_leftBtn setExpandEdge:UIEdgeInsetsMake(5, 5, 5, 5)];
    }
    return _leftBtn;
}
-(UILabel *)leftLb {
    if (_leftLb == nil) {
        _leftLb = [[UILabel alloc] init];
        _leftLb.font = FONTSIZE(16);
        [self addSubview:_leftLb];
        [_leftLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.inset(16);
            make.height.mas_equalTo(24);
            make.bottom.inset(10);
        }];
    }
    return _rightLb;
}
-(UIButton *)rightBtn {
    if (_rightBtn == nil) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightBtn];
        [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.inset(16);
            make.bottom.inset(10);
        }];
        [_rightBtn setExpandEdge:UIEdgeInsetsMake(5, 5, 5, 5)];
    }
    return _rightBtn;
}
-(UILabel *)rightLb {
    if (_rightLb == nil) {
        _rightLb = [[UILabel alloc] init];
        _rightLb.font = FONTSIZE(16);
        [self addSubview:_rightLb];
        [_rightLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.inset(16);
            make.height.mas_equalTo(24);
            make.bottom.inset(10);
        }];
    }
    return _rightLb;
}
@end
