//
//  PhotoEditViewController.m
//  xiangwan
//
//  Created by mac on 2019/10/29.
//  Copyright © 2019 mac. All rights reserved.
//

#import "PhotoEditViewController.h"
#import <ZLPhotoModel.h>
#import <ZLDefine.h>
#import <ZLPhotoManager.h>
#import <ZLPhotoConfiguration.h>
#import <ZLImageEditTool.h>



@interface PhotoEditViewController ()
{
    UIActivityIndicatorView *_indicator;
    
    ZLImageEditTool *_editTool;
}
@end

@implementation PhotoEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _editTool.frame = self.view.bounds;
}

- (void)setupUI
{
    self.view.backgroundColor = MAINCOLOR();
    
    [self loadEditTool];
    [self loadImage];
}

- (void)loadImage
{
    _indicator = [[UIActivityIndicatorView alloc] init];
    _indicator.center = self.view.center;
    _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    _indicator.hidesWhenStopped = YES;
    [self.view addSubview:_indicator];
    
    CGFloat scale = 3;
    CGFloat width = MIN(kViewWidth, kMaxImageWidth);
    CGSize size = CGSizeMake(width*scale, width*scale*self.model.asset.pixelHeight/self.model.asset.pixelWidth);
    
    [_indicator startAnimating];
    @zl_weakify(self);
    [ZLPhotoManager requestImageForAsset:self.model.asset size:size progressHandler:nil completion:^(UIImage *image, NSDictionary *info) {
        if (![[info objectForKey:PHImageResultIsDegradedKey] boolValue]) {
            @zl_strongify(self);
            [self->_indicator stopAnimating];
            self->_editTool.editImage = image;
        }
    }];
}

- (void)loadEditTool
{
    ZLPhotoConfiguration *configuration = [ZLPhotoConfiguration defaultPhotoConfiguration];
    configuration.saveNewImageAfterEdit = NO;
    configuration.clipRatios = self.clipRatios;
    if (self.clipRatios.count == 1) {
        configuration.hideClipRatiosToolBar = YES;
    }
    _editTool = [[ZLImageEditTool alloc] initWithEditType:ZLImageEditTypeClip image:_oriImage configuration:configuration];
    @zl_weakify(self);
    _editTool.cancelEditBlock = ^{
        @zl_strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    };
    _editTool.doneEditBlock = ^(UIImage *image) {
        @zl_strongify(self);
        [self saveImage:image];
    };
    [self.view addSubview:_editTool];
}

- (void)saveImage:(UIImage *)image {

    WeakSelf
    if (self.saveNewImageAfterEdit) {
        //确定裁剪，返回
        [self popHintView];
        [ZLPhotoManager saveImageToAblum:image completion:^(BOOL suc, PHAsset *asset) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf hideHintView];
                if (suc) {
                    if (weakSelf.callSelectClipImageBlock) {
                        [weakSelf removeViewController];
                        weakSelf.callSelectClipImageBlock(image, asset);
                    }
                } else {
                    [weakSelf showFailToast:GetLocalLanguageTextValue(ZLPhotoBrowserSaveImageErrorText)];
                }
            });
        }];
    } else {
        if (image) {
            if (self.callSelectClipImageBlock) {
                [self removeViewController];
                self.callSelectClipImageBlock(image, self.model.asset);
            }
        } else {
            [weakSelf showFailToast:GetLocalLanguageTextValue(ZLPhotoBrowserSaveImageErrorText)];
        }
    }
}

- (void)removeViewController {
    NSMutableArray *marr = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in marr) {
        if ([vc isKindOfClass:self.class]) {
            [marr removeObject:vc];
            break;
        }
    }
    self.navigationController.viewControllers = marr;
}


- (void)popHintView {
    [NMHudView showHUD];
}

- (void)hideHintView {
    [NMHudView hideHUD];
}

- (void)showToast:(NSString *)text {
    [NMToast showSuccessTipMessage:text];
}
- (void)showFailToast:(NSString *)text {
    [NMToast showFailTipMessage:text];
}

@end
