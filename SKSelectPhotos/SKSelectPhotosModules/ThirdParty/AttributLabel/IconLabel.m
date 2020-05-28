//
//  IconLabel.m
//
//  Created by Nemo on 2019/11/24.
//  Copyright © 2019 mac. All rights reserved.
//

#import "IconLabel.h"

@interface IconLabel()
@property (nonatomic, weak) UILabel *textLb;
@property (nonatomic, weak) UIImageView *imageView;
@end

@implementation IconLabel

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setup];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}
-(void)setup {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    self.imageView = imageView;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.mas_height);
        make.left.mas_equalTo(2);
        make.centerY.equalTo(self);
    }];
    
    UILabel *textLb = [[UILabel alloc] init];
    textLb.font = FONTSIZE(12);
    textLb.textColor = [UIColor whiteColor];
    [self addSubview:textLb];
    self.textLb = textLb;
    [textLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right);
        make.centerY.equalTo(self);
    }];
    
    [self makeRoundedCorner:8];
}

-(void)setIcon:(NSString *)icon {
    _icon = icon;
    self.imageView.image = [UIImage imageNamed:icon];
}
-(void)setText:(NSString *)text {
    _text = text;
    self.textLb.text = text;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.textLb.mas_right).offset(6);
    }];
}

@end
