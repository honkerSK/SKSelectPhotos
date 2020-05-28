//
//  PreviewCell.m
//  xiangwan
//
//  Created by mac on 2019/8/17.
//  Copyright © 2019 mac. All rights reserved.
//

#import "PreviewCell.h"
#import <ZLBigImageCell.h>
@interface PreviewCell()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) ZLPreviewView *previewView;
@end

@implementation PreviewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    [self.contentView addSubview:self.previewView];
    
    WeakSelf
    self.previewView.singleTapCallBack = ^{
        [weakSelf tapAction];
    };
}
- (void)tapAction {
    !self.cellTap ?: self.cellTap();
}
- (ZLPreviewView *)previewView
{
    if (!_previewView) {
        _previewView = [[ZLPreviewView alloc] initWithFrame:self.bounds];
        _previewView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _previewView.showGif = YES;
        _previewView.showLivePhoto = NO;
    }
    return _previewView;
}
-(void)setModel:(ZLPhotoModel *)model {
    _model = model;
    self.previewView.model = model;
}

@end
