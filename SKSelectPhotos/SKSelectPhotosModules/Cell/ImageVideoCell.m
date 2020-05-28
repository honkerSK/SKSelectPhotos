//
//  ImageVideoCell.m
//  xiangwan
//
//  Created by mac on 2019/8/15.
//  Copyright © 2019 mac. All rights reserved.
//

#import "ImageVideoCell.h"
#import <ZLPhotoManager.h>
#import "UIButton+Extension.h"
#import "NSObject+Extension.h"

@interface ImageVideoCell()
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UIImageView *selectIv;
@property (nonatomic, weak) UIImageView *videoIv;
@property (nonatomic, weak) UIView *bgMaskView;

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, assign) PHImageRequestID imageRequestID;

@end

@implementation ImageVideoCell


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)setup {
    self.contentView.backgroundColor = COLORFFFFFF();

    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = COLORF9F9F9();
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.userInteractionEnabled = YES;
    [self.contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    self.imageView = imageView;
    
    
    UIImageView *selectIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"public_media_select"]];
    [self.contentView addSubview:selectIv];
    [selectIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(24);
        make.top.right.inset(4);
    }];
    self.selectIv = selectIv;
    
    UIImageView *videoIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"public_media_tab1"]];
    videoIv.hidden = YES;
    [self.contentView addSubview:videoIv];
    [videoIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(24);
        make.left.bottom.inset(4);
    }];
    self.videoIv = videoIv;
    
    UIView *bgMaskView = [[UIView alloc] init];
    bgMaskView.backgroundColor = RGBACOLOR(34, 34, 34, 0.8);
    bgMaskView.hidden = YES;
    [self.contentView addSubview:bgMaskView];
    [bgMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    self.bgMaskView = bgMaskView;
    
}

-(void)setModel:(ZLPhotoModel *)model {
    _model = model;
    
    CGSize size = [self requestImageSize:model.asset];

    @zl_weakify(self);
    if (model.asset && self.imageRequestID >= PHInvalidImageRequestID) {
        [[PHCachingImageManager defaultManager] cancelImageRequest:self.imageRequestID];
    }
    self.imageView.image = nil;
    self.identifier = model.asset.localIdentifier;
    self.imageRequestID = [ZLPhotoManager requestImageForAsset:model.asset size:size progressHandler:nil completion:^(UIImage *image, NSDictionary *info) {
        @zl_strongify(self);
        if ([self.identifier isEqualToString:model.asset.localIdentifier]) {
            if (model.image.size.width < image.size.width) {
                model.image = image;
            }
            if (model.image) {
                self.imageView.image = model.image;
            }
        }
        if (![[info objectForKey:PHImageResultIsDegradedKey] boolValue]) {
            self.imageRequestID = -1;
        }
    }];
    
    
    if (self.type == ImageVideoCellTypeImage &&
        (model.type == ZLAssetMediaTypeVideo ||
         model.type == ZLAssetMediaTypeNetVideo) &&
        self.moreOne) {
        self.bgMaskView.hidden = NO;
        self.userInteractionEnabled = NO;
        self.selectIv.hidden = YES;
    }else if(self.type == ImageVideoCellTypeVideo &&
             (model.type == ZLAssetMediaTypeImage ||
              model.type == ZLAssetMediaTypeGif||
              model.type == ZLAssetMediaTypeLivePhoto ||
              model.type == ZLAssetMediaTypeNetImage) &&
             self.moreOne){
        self.bgMaskView.hidden = NO;
        self.userInteractionEnabled = NO;
        self.selectIv.hidden = YES;
    }else{
        self.bgMaskView.hidden = YES;
        self.userInteractionEnabled = YES;
        self.selectIv.hidden = NO;
    }
    
    NSString *image = model.isSelected ? @"public_media_select_s":@"public_media_select";
    self.selectIv.image = [UIImage imageNamed:image];
    self.videoIv.hidden = (model.type != ZLAssetMediaTypeVideo);
    
}

- (CGSize)requestImageSize:(PHAsset *)asset {    
    return CGSizeMake(self.width*2, self.height*2);
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:self];
    
    if (CGRectContainsPoint(CGRectMake(self.contentView.width-44, 0, 44,44), point)) {
        !self.selectAction ?: self.selectAction();
    }else{
        !self.showAction ?: self.showAction();
    }
    
}

@end

@implementation TakePhotoCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"login_upload_profile"];
    imageView.backgroundColor = COLORF9F9F9();
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.userInteractionEnabled = YES;
    [self.contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    !self.takePhotoAction ?: self.takePhotoAction();
}
@end
