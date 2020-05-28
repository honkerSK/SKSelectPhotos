//
//  NMIcnTleButton.m
//  xiangwan
//
//  Created by mac on 2019/11/14.
//  Copyright © 2019 mac. All rights reserved.
//

#import "NMIcnTleButton.h"
#import "AttributLabel.h"
#import "UIImageView+Extension.h"

@interface NMIcnTleButton()

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) AttributLabel *titleLb;
@property (nonatomic, assign) NMIcnTleButtonType type;
@end

@implementation NMIcnTleButton
+ (instancetype)iconInBottom {
    NMIcnTleButton *btn = [[NMIcnTleButton alloc] initType:NMIcnTleButtonTypeIconBottom];
    return btn;
}
+ (instancetype)iconInRight {
    NMIcnTleButton *btn = [[NMIcnTleButton alloc] initType:NMIcnTleButtonTypeIconRight];
    return btn;
}
+ (instancetype)iconInTop {
    NMIcnTleButton *btn = [[NMIcnTleButton alloc] initType:NMIcnTleButtonTypeIconTop];
    return btn;
}
- (instancetype)initType:(NMIcnTleButtonType)type {
    self = [super init];
    if (self) {
        self.type = type;
        [self setup];
    }
    return self;
}

- (void)setup {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    self.imageView = imageView;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        if ( self.type == NMIcnTleButtonTypeIconTop) {
            make.centerX.equalTo(self);
            make.width.height.lessThanOrEqualTo(self.mas_width);
            make.top.mas_equalTo(0);
        }else if (self.type == NMIcnTleButtonTypeIconBottom) {
            make.centerX.equalTo(self);
            make.bottom.mas_equalTo(0);
        }else if (self.type == NMIcnTleButtonTypeIconLeft) {
            make.centerY.equalTo(self);
            make.left.mas_equalTo(0);
        }else if (self.type == NMIcnTleButtonTypeIconRight) {
            make.centerY.equalTo(self);
            make.right.mas_equalTo(0);
        }
    }];
    
    AttributLabel *titleLb = [[AttributLabel alloc] init];
    [self addSubview:titleLb];
    self.titleLb = titleLb;
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        if ( self.type == NMIcnTleButtonTypeIconTop) {
            make.centerX.equalTo(self);
            make.bottom.mas_equalTo(0);
        }else if (self.type == NMIcnTleButtonTypeIconBottom) {
            make.centerX.equalTo(self);
            make.top.mas_equalTo(0);
        }else if (self.type == NMIcnTleButtonTypeIconLeft) {
            make.centerY.equalTo(self);
            make.right.mas_equalTo(0);
        }else if (self.type == NMIcnTleButtonTypeIconRight) {
            make.centerY.equalTo(self);
            make.left.mas_equalTo(0);
        }
    }];
}
-(void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    self.titleLb.font = titleFont;
}
-(void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.titleLb.textColor = titleColor;
}
- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLb.text = title;
}
-(void)setNormalImage:(NSString *)normalImage {
    _normalImage = normalImage;
    self.imageView.image = [UIImage imageNamed:normalImage];
}
-(void)setSelectedImage:(NSString *)selectedImage {
    _selectedImage = selectedImage;
    self.imageView.image = [UIImage imageNamed:selectedImage];
}
//-(void)setImageUrl:(NSString *)imageUrl {
//    _imageUrl = imageUrl;
//    [self.imageView xw_setImageWithURL:IMAGEURL(imageUrl)];
//}
- (void)makeImageRoundedCorner:(CGFloat)cornerRadius {
    [self.imageView makeRoundedCorner:cornerRadius];
}
-(void)setSelected:(BOOL)selected {
    _selected = selected;
    NSString *name = selected ? self.selectedImage : self.normalImage;
    BOOL b = ValidStr(name);
    if (b) {
        self.imageView.image = [UIImage imageNamed:name];
    }
    self.imageView.hidden = !b;
    
    UIFont *font = selected ? self.selectedTitleFont : self.titleFont;
    self.titleLb.font = font;

    UIColor *color = selected ? self.selectedTitleColor : self.titleColor;
    self.titleLb.textColor = color;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    !self.touchAction ?: self.touchAction();
}

-(void)halfPiDegreeRotation:(BOOL)b {    
    CGAffineTransform transform = b?CGAffineTransformMakeRotation(-M_PI):CGAffineTransformMakeRotation(0);
    
    [UIView animateWithDuration:0.2f animations:^{
        self.imageView.transform = transform;
    }];
}

-(void)layoutSubviews {
    [super layoutSubviews];
}

@end
