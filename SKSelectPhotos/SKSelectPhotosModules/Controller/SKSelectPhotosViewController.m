//
//  SKSelectPhotosViewController.m
//  SKSelectPhotos
//
//  Created by sunke on 2020/4/21.
//  Copyright © 2020 KentSun. All rights reserved.
//

#import "SKSelectPhotosViewController.h"

#import <ZLPhotoManager.h>

#import "PreviewViewController.h"
#import "CustomCameraViewController.h"
#import "PhotoEditViewController.h"

#import "ImageVideoCell.h"
#import "NMIcnTleButton.h"
#import "MainButton.h"
#import "NMAlertView.h"

//#import "PublishActivitySceneModel.h"

typedef NS_ENUM(NSInteger, PublishActivitySceneModelType){
    PublishActivitySceneModelTypeNormal = 0,
    PublishActivitySceneModelTypeImage,
    PublishActivitySceneModelTypeVideo,
};


#pragma mark - SelectCell  选择相册集视图cell
@interface SelectCell : UITableViewCell
///相册列表模型
@property (nonatomic, strong) ZLAlbumListModel *model;

@property (nonatomic, assign) BOOL isSelect;
@end

@interface SelectCell()
@property (nonatomic, strong) UIImageView *iv;
@end

@implementation SelectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}
- (void)setupUI {
    CALayer *line = [[CALayer alloc] init];
    line.backgroundColor = COLOREDEDED().CGColor;
    line.frame = CGRectMake(0, 47.5, nScreenWidth(), 0.5);
    [self.contentView.layer addSublayer:line];
}

-(void)setModel:(ZLAlbumListModel *)model {
    _model = model;
    self.textLabel.text = [NSString stringWithFormat:@"%@(%ld)",model.title,model.count];
}

-(void)setIsSelect:(BOOL)isSelect {
    _isSelect = isSelect;
    self.accessoryView = isSelect ? self.iv:nil;
}


-(UIImageView *)iv {
    if (_iv == nil) {
        _iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"public_checkbox_s"]];
    }
    return _iv;
}

@end


#pragma mark - SelectPhotoDirectoryView  选择相册集视图
@interface SelectPhotoDirectoryView : UIView
@property (nonatomic, weak) NSArray *arrayDataSources;
///选中一个相册集回调
@property (nonatomic, copy) void(^clickAction)(NSInteger idx);

+ (instancetype)selectPhotoAddView:(UIView *)view;
///显示popView
- (void)showPopupView;
///隐藏popView
- (void)hiddenPopupView;

@end


@interface SelectPhotoDirectoryView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) UIView *popupView;
@property (nonatomic, weak) UIView *supView;
@property (nonatomic, weak) UITableView *tableView;
///记录选中行数
@property (nonatomic, assign) NSInteger selectIdx;
@property (nonatomic, assign) CGFloat maxH;
@end

@implementation SelectPhotoDirectoryView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

+ (instancetype)selectPhotoAddView:(UIView *)addView {
    
    SelectPhotoDirectoryView *view = [[SelectPhotoDirectoryView alloc] initWithFrame:addView.bounds];
    view.supView = addView;
    return view;
}

- (void)setup {
    
    self.backgroundColor = MAINCOLORA(0.3);
    self.selectIdx = 0;
    self.maxH = nScreenHeight() - kStatusBarAndNavigationBarHeight - 100;
    CALayer *line = [[CALayer alloc] init];
    line.frame = CGRectMake(0, 0, self.width, 0.5);
    line.backgroundColor = COLOREDEDED().CGColor;
    [self.layer addSublayer:line];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, .5, self.width, 0) style:UITableViewStylePlain];
    tableView.rowHeight = 48;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [UIView new];
    [self addSubview:tableView];
    self.tableView = tableView;
    [SelectCell registerClassForTableView:tableView];
    
}


#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayDataSources.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectCell *cell = [tableView dequeueReusableCellWithIdentifier:[SelectCell identifier]];
    cell.model = self.arrayDataSources[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self hiddenPopupViewForRow:indexPath.row];
    
    SelectCell *oldCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectIdx inSection:0]];
    oldCell.isSelect = NO;
    self.selectIdx = indexPath.row;
    SelectCell *newCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectIdx inSection:0]];
    newCell.isSelect = YES;
}

#pragma mark function
- (void)showPopupView {
    if (!self.hidden) {
        [self.supView addSubview:self];
    }
    self.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat height = self.arrayDataSources.count * 48;
        if (self.maxH < height) { height = self.maxH; }
        self.tableView.height = height;
    } completion:^(BOOL finished) {
        
    }];
}
- (void)hiddenPopupView {
    [self hiddenPopupViewForRow:-1];
}

- (void)hiddenPopupViewForRow:(NSInteger)row {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.height = 0;
    } completion:^(BOOL finished) {
        kDISPATCH_AFTER(0.1, ^{
            self.hidden = YES;
        });
        !self.clickAction ?: self.clickAction(row);
    }];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hiddenPopupView];
}
@end

#pragma mark - SKSelectPhotosViewController
@interface SKSelectPhotosViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *originalDataSource;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSArray *arrayDataSources;
@property (nonatomic, assign) ImageVideoCellType curType;
@property (nonatomic, assign) BOOL isFolding;
@property (nonatomic, weak) ZLPhotoModel  *oldModel;

@property (nonatomic, strong) SelectPhotoDirectoryView *foldView;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) UIView *titleView;
@property (nonatomic, weak) NMIcnTleButton *titleBtn;
@property (nonatomic, weak) MainButton *clearBtn;
@property (nonatomic, weak) MainButton *finishBtn;
@property (nonatomic, weak) MainButton *previewBtn;


@end

@implementation SKSelectPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //self.title = self.onlyImage?@"请选择照片":@"请选择照片或视频";
    
    if ([self havePhotoLibraryAuthority]) { return; }
    
    [self createUIOrData];
}

- (void)createUIOrData {
    
    [self setup];
    
    [self initData];
}

#pragma mark setupUI
- (void)setup {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    CGFloat wh = (nScreenWidth()-2)/3;
    layout.itemSize = CGSizeMake(wh, wh);
    //layout.sectionInset = UIEdgeInsetsMake(0, 1, 0, 1);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsVerticalScrollIndicator = NO;
    [ImageVideoCell registerClassForCollectionView:collectionView];
    [TakePhotoCell registerClassForCollectionView:collectionView];
    
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    BOOL showBottomView = (self.onlyImage && self.maxImageSelectCount == 1 && self.isCrop);
    CGFloat bottom = showBottomView?0:(66+kSafeAreaBottomHeight);
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.mas_equalTo(-bottom);
    }];
    
    UIView *titleView = [[UIView alloc] init];
    titleView.frame = CGRectMake((nScreenWidth()-166)/2, 0, 166, 44);
    [self.navigationController.navigationBar addSubview:titleView];
    self.titleView = titleView;
    
    NMIcnTleButton *titleBtn = [NMIcnTleButton iconInRight];
    titleBtn.selectedImage = @"public_s_dropdown";
    NSString *title = self.onlyImage?@"请选择照片":@"请选择照片或视频";
    CGFloat width = [title widthForFont:FONTSIZE(18)]+23;
    titleBtn.title = title;
    titleBtn.titleColor = MAINCOLOR();
    titleBtn.titleFont = FONTSIZE(18);
    titleBtn.selectedTitleFont = FONTSIZE(18);
    titleBtn.selected = YES;
    titleBtn.frame = CGRectMake((166-width)/2, 0, width, 44);
    [titleView addSubview:titleBtn];
    self.titleBtn = titleBtn;
    
    WeakSelf
    titleBtn.touchAction = ^{
        if (!weakSelf.titleBtn.selected) {
            weakSelf.titleBtn.selected = YES;
            weakSelf.isFolding = NO;
        }else{
            [weakSelf.titleBtn halfPiDegreeRotation:weakSelf.isFolding];
            [weakSelf showFoldView];
        }
        weakSelf.isFolding = !weakSelf.isFolding;
    };
    
    if (showBottomView) {
        return;
    }
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = COLORFFFFFF();
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.mas_equalTo(bottom);
    }];
    
    [bottomView makeTopShadow];
    
    MainButton *clearBtn = [MainButton mainButton];
    clearBtn.text = @"清空";
    clearBtn.normalTextColor = MAINCOLOR();
    clearBtn.normalBgColor = COLORFFFFFF();
    clearBtn.normalBorderColor = COLOREDEDED();
    clearBtn.enabled = NO;
    [bottomView addSubview:clearBtn];
    
    clearBtn.clickBlock = ^{
        [weakSelf clearAction];
    };
    self.clearBtn = clearBtn;
    [clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.inset(16);
        make.size.mas_equalTo(CGSizeMake(80, 48));
        make.top.mas_equalTo(9);
    }];
    
    MainButton *finishBtn = [MainButton mainButton];
    finishBtn.text = @"完成";
    finishBtn.enabled = NO;
    [bottomView addSubview:finishBtn];
    finishBtn.clickBlock = ^{
        [weakSelf finishAction];
    };
    self.finishBtn = finishBtn;
    [finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.inset(16);
        make.size.mas_equalTo(CGSizeMake(105, 48));
        make.top.mas_equalTo(9);
    }];
    
    MainButton *previewBtn = [MainButton mainButton];
    previewBtn.text = @"预览";
    previewBtn.normalTextColor = MAINCOLOR();
    previewBtn.normalBgColor = COLORFFFFFF();
    previewBtn.normalBorderColor = COLOREDEDED();
    previewBtn.enabled = NO;
    [bottomView addSubview:previewBtn];
    previewBtn.clickBlock = ^{
        [weakSelf skipPreviewViewController:0];
    };
    self.previewBtn = previewBtn;
    [previewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(finishBtn.mas_left).inset(8);
        make.size.mas_equalTo(CGSizeMake(80, 48));
        make.top.mas_equalTo(9);
    }];
    
}

- (void)showFoldView {
    if (_foldView == nil) {
        _foldView = [SelectPhotoDirectoryView selectPhotoAddView:self.view];
        _foldView.arrayDataSources = self.arrayDataSources;
        [_foldView showPopupView];
        WeakSelf
        _foldView.clickAction = ^(NSInteger idx) {
            weakSelf.isFolding = YES;
            [weakSelf.titleBtn halfPiDegreeRotation:NO];
            if (idx == -1) {
                return;
            }
            [weakSelf handleDataForIdx:idx];
        };
    }
    if (self.isFolding) {
        [_foldView showPopupView];
    }else{
        [_foldView hiddenPopupView];
    }
}

- (void)handleDataForIdx:(NSInteger)idx {
    ZLAlbumListModel *listModel = self.arrayDataSources[idx];
    
    if ([listModel.title isEqualToString:self.titleBtn.title]) {
        return;
    }
    
    CGFloat width = [listModel.title widthForFont:FONTSIZE(18)]+23;
    self.titleBtn.frame = CGRectMake((166-width)/2.0, 0, width, 44);
    self.titleBtn.title = listModel.title;
    BOOL isLoad = (listModel.models.count > 200);
    if (isLoad) {
        [self popHintView];
    }
    WeakSelf
    kDISPATCH_GLOBAL_QUEUE_DEFAULT(^{
        if (!listModel.models){
            NSArray *ary = [ZLPhotoManager getPhotoInResult:listModel.result allowSelectVideo:YES allowSelectImage:YES allowSelectGif:YES allowSelectLivePhoto:YES];
            ZLPhotoModel *model = [[ZLPhotoModel alloc] init];
            model.type = ZLAssetMediaTypeUnknown;
            model.selected = NO;
            NSMutableArray *list = [[NSMutableArray alloc] initWithArray:ary];
            [list insertObject:model atIndex:0];
            listModel.models = [list copy];
        }
        for (ZLPhotoModel *obj in listModel.models) {
            BOOL b = [weakSelf.originalDataSource filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.asset.localIdentifier = %@",obj.asset.localIdentifier]].count > 0;
            obj.selected = b;
        }
        weakSelf.dataSource = [[NSMutableArray alloc] initWithArray:listModel.models];
        
        kDISPATCH_MAIN_THREAD(^{
            if (isLoad) {
                [weakSelf hideHintView];
            }
            [weakSelf.collectionView reloadData];
        });
    });
    
}

//- (void)emptyViewForText:(NSString *)text {
//    [self scrollView:self.collectionView detailStr:text];
//}

///验证相册是否授权
- (BOOL)havePhotoLibraryAuthority {
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status != PHAuthorizationStatusAuthorized) {
        if (status == PHAuthorizationStatusNotDetermined) {
            WeakSelf
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                kDISPATCH_MAIN_THREAD(^{
                    if (status != PHAuthorizationStatusAuthorized) {
                        [weakSelf showFailToast:@"相册访问权限受限"];
                        //[weakSelf emptyViewForText:@"相册访问权限受限"];
                    }else{ //已授权
                        [weakSelf createUIOrData];
                    }
                });
            }];
            return YES;
        }else{
            [self showAlert:@"请打开相册访问权限。请到设置->隐私->照片中开启相册访问权限"];
        }
        return YES;
    }
    
    return NO;
}

///验证麦克风是否授权
- (BOOL)haveAudioAuthority {
    
    NSLog(@"===== haveAudioAuthority");
    
    AVAuthorizationStatus audioAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    
    if (audioAuthStatus != AVAuthorizationStatusAuthorized) {
        if (audioAuthStatus == AVAuthorizationStatusNotDetermined) {
            WeakSelf
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                kDISPATCH_MAIN_THREAD(^{
                    if (!granted) {
                        //[weakSelf emptyViewForText:@"麦克风访问权限受限"];
                        [weakSelf showFailToast:@"麦克风访问权限受限"];
                    }
                });
            }];
            return YES;
        }else{
            [self showAlert:@"请打开麦克风访问权限。请到设置->隐私->麦克风中开启麦克风访问权限"];
        }
        return YES;
    }
    return YES;
}

///验证相机是否授权
- (BOOL)haveAuthority {
    AVAuthorizationStatus aStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (aStatus != AVAuthorizationStatusAuthorized) {
        if (aStatus == AVAuthorizationStatusNotDetermined) {
            WeakSelf
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                NSLog(@"===== haveAuthority %d",granted);
                kDISPATCH_MAIN_THREAD(^{
                    if (!granted) {
                        [weakSelf showFailToast:@"相机访问权限受限"];
                        //[weakSelf emptyViewForText:@"相机访问权限受限"];
                    }else{
                        [weakSelf takePhoto];
                    }
                });
            }];
            return YES;
        }else{
            [self showAlert:@"请打开相机访问权限。请到设置->隐私->相机中开启相机访问权限"];
        }
        //[self emptyViewForText:@"相机访问权限受限"];
        return YES;
    }
    return NO;
}


- (void)showAlert:(NSString *)message {
    
    WeakSelf
    [NMAlertView showWithTitle:nil message:message cancelButtonTitle:@"取消" otherButtonTitles:@[@"去设置"] completionBlock:^(NSInteger index) {
        if (index == 1) {
            CGFloat systemVersion = [[UIDevice currentDevice].systemVersion floatValue];
            if (systemVersion >= 8.0 && systemVersion < 10.0) {  // iOS8.0 和 iOS9.0
                NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }else if (systemVersion >= 10.0) {  // iOS10.0及以后
                NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    if (@available(iOS 10.0, *)) {
                        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                        }];
                    }
                }
            }
        }else{
            [weakSelf leftBarButtonClickViewController];
        }
    }];
}

#pragma mark initData
- (void)initData {
    
    self.isFolding = YES;
    
    BOOL b = NO;
    if (self.datas.count == 0) {
        self.datas = [[NSMutableArray alloc] init];
    }else{
        NSInteger tag = self.type;
        self.curType = tag;
        b = YES;
        for (ZLPhotoModel *p in self.datas) {
            ZLPhotoModel *model = [ZLPhotoModel modelWithAsset:p.asset type:p.type duration:p.duration];
            model.url = p.url;
            model.image = p.image;
            model.selected = YES;
            [self.originalDataSource addObject:model];
        }
    }
    
    [self popHintView];
    WeakSelf
    kDISPATCH_GLOBAL_QUEUE_DEFAULT( ^{
        [ZLPhotoManager getCameraRollAlbumList:YES allowSelectImage:YES complete:^(ZLAlbumListModel *album) {
            ZLPhotoModel *model = [[ZLPhotoModel alloc] init];
            model.type = ZLAssetMediaTypeUnknown;
            model.selected = NO;
            [weakSelf.dataSource addObject:model];
            for (ZLPhotoModel *m in album.models) {
                if (b) {
                    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF.asset.localIdentifier = %@",m.asset.localIdentifier];
                    ZLPhotoModel *p = [weakSelf.originalDataSource filteredArrayUsingPredicate:pre].firstObject;
                    m.selected = (p != nil);
                    if (m.selected && p) {
                        weakSelf.oldModel = p;
                        [weakSelf.dataSource addObject:p];
                        continue;
                    }
                }
                if (weakSelf.onlyImage) {
                    if (m.type == ZLAssetMediaTypeImage) {
                        [weakSelf.dataSource addObject:m];
                    }
                    continue;
                }
                [weakSelf.dataSource addObject:m];
            }
            kDISPATCH_MAIN_THREAD(^{
                [weakSelf reloadData];
                [weakSelf hideHintView];
            });
        }];
        [ZLPhotoManager getPhotoAblumList:YES allowSelectImage:YES complete:^(NSArray<ZLAlbumListModel *> *albums) {
            ZLAlbumListModel *listModel = albums.firstObject;
            listModel.models = [weakSelf.dataSource copy];
            NSMutableArray *result = [[NSMutableArray alloc] init];
            if (weakSelf.onlyImage) {
                NSArray *ary = [albums filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.headImageAsset.mediaType = 1"]];
                [result addObjectsFromArray:ary];
            }else{
                [result addObjectsFromArray:albums];
            }
            weakSelf.arrayDataSources = result;
        }];
    });
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithImage:[[UIImage imageNamed:@"public_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                             style:UIBarButtonItemStylePlain
                                             target:self  action:@selector(leftBarButtonClickViewController)];
}
- (void)leftBarButtonClickViewController {
    [self.titleView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WeakSelf
    if (indexPath.row == 0) {
        TakePhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[TakePhotoCell identifier] forIndexPath:indexPath];
        cell.takePhotoAction = ^{
            [weakSelf takePhoto];
        };
        return cell;
    }
    ImageVideoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ImageVideoCell identifier] forIndexPath:indexPath];
    cell.moreOne = (self.originalDataSource.count > 0);
    cell.type = self.curType;
    cell.model = self.dataSource[indexPath.row];
    cell.selectAction = ^{
        [weakSelf cellClickForIndexPath:indexPath];
    };
    cell.showAction = ^{
        if (weakSelf.onlyImage &&
            weakSelf.maxImageSelectCount == 1 &&
            weakSelf.isCrop) {
            [weakSelf cellClickForIndexPath:indexPath];
        }else{
            [weakSelf showCellForIndexPath:indexPath];
        }
    };
    return cell;
}

- (void)showCellForIndexPath:(NSIndexPath *)indexPath {
    ZLPhotoModel *model = self.dataSource[indexPath.row];
    NSInteger idx = 0;
    
    if ([self.originalDataSource containsObject:model]) {
        idx = [self.originalDataSource indexOfObject:model];
        if (idx > self.originalDataSource.count-1) {
            idx = self.originalDataSource.count - 1;
        }
    }else{
        [self.originalDataSource insertObject:model atIndex:0];
    }
    
    [self skipPreviewViewController:idx];
}

- (void)cellClickForIndexPath:(NSIndexPath *)indexPath {
    
    ZLPhotoModel *model = self.dataSource[indexPath.row];
    
    if (self.onlyImage && self.maxImageSelectCount == 1 && self.isCrop) {
        PhotoEditViewController *vc = [[PhotoEditViewController alloc] init];
        vc.model = model;
        if (self.clipRatios.count == 0) {
            self.clipRatios = @[GetClipRatio(1, 1)];
        }
        vc.clipRatios = self.clipRatios;
        WeakSelf
        vc.callSelectClipImageBlock = ^(UIImage * _Nonnull image, PHAsset * _Nonnull asset) {
            !weakSelf.selectImageBlock ?: weakSelf.selectImageBlock(@[image],@[asset]);
            [weakSelf leftBarButtonClickViewController];
        };
        [self.navigationController pushViewController:vc animated:NO];
        return;
    }
    
    
    if (self.oldModel.type == ZLAssetMediaTypeVideo && model != self.oldModel) {
        self.oldModel.selected = NO;
        [self.originalDataSource removeAllObjects];
    }
    
    
    BOOL isSelect = model.isSelected;
    NSInteger total = (self.curType == ImageVideoCellTypeImage)?self.maxImageSelectCount:self.maxImageSelectCount;
    if (self.originalDataSource.count > (total-1) && !isSelect) {
        [self showFailToast:@"已经达到最大选择数"];
        return;
    }
    
    if (isSelect) {
        ZLPhotoModel *obj = [self.originalDataSource filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.asset.localIdentifier = %@",model.asset.localIdentifier]].firstObject;
        if (obj) {
            [self.originalDataSource removeObject:obj];
        }
    }else{
        [self.originalDataSource addObject:model];
    }
    model.selected = !isSelect;
    self.curType = (model.type == ZLAssetMediaTypeVideo || model.type == ZLAssetMediaTypeNetVideo) ?ImageVideoCellTypeVideo:ImageVideoCellTypeImage;
    [self reloadData];
    
    self.oldModel = model;
}
- (void)reloadData {
    if (self.originalDataSource.count == 0) {
        self.curType = ImageVideoCellTypeDef;
        self.curType = PublishActivitySceneModelTypeNormal;
    }
    NSString *text = @"完成";
    switch (self.curType) {
        case ImageVideoCellTypeImage: {
            NSInteger count = [self.originalDataSource filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.selected = 1"]].count;
            text = [NSString stringWithFormat:@"%ld/%ld完成",count,self.maxImageSelectCount];
            self.curType = PublishActivitySceneModelTypeImage;
        }
            break;
        case ImageVideoCellTypeVideo: {
            text = [NSString stringWithFormat:@"%ld/1完成",self.originalDataSource.count];
            self.curType = PublishActivitySceneModelTypeVideo;
        }
            break;
        default:
            break;
    }
    self.finishBtn.text = text;
    BOOL enabled = (self.originalDataSource.count > 0);
    self.finishBtn.enabled = enabled;
    self.previewBtn.enabled = enabled;
    self.clearBtn.enabled = enabled;
    [self.collectionView reloadData];
}

#pragma mark 底部按钮响应
///清空按钮响应
- (void)clearAction {
    
    for (ZLPhotoModel *model in self.originalDataSource) {
        model.selected = NO;
    }
    [self.originalDataSource removeAllObjects];
    [self reloadData];
}

/// 预览按钮响应
- (void)skipPreviewViewController:(NSInteger)idx {
    self.datas = self.originalDataSource;
    PreviewViewController *vc = [[PreviewViewController alloc] init];
    vc.datas = self.originalDataSource;
    vc.type = PreviewViewTypeEdit;
    vc.idx = idx;
    WeakSelf
    vc.reloadAction = ^(NSMutableArray<ZLPhotoModel *> * _Nonnull data) {
        [weakSelf finishAction];
    };
    vc.cancelAction = ^(ZLPhotoModel * _Nonnull obj) {
        //NSLog(@"%d",obj.selected);
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF.asset.localIdentifier = %@",obj.asset.localIdentifier];
        ZLPhotoModel *p = [weakSelf.dataSource filteredArrayUsingPredicate:pre].firstObject;
        p.selected = obj.selected;
        [weakSelf reloadData];
    };
//    [vc cyl_setHideNavigationBarSeparator:YES];
//    [vc cyl_setNavigationBarHidden:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

///完成按钮响应
- (void)finishAction {
    self.datas = self.originalDataSource;
    
    if (self.type == SelectTypeAll ||
        self.onlyImage) {
        if (self.selectImageBlock) {
            WeakSelf
            [self requestBigImage:^(NSArray<UIImage *> * _Nullable images, NSArray<PHAsset *> *assets) {
                weakSelf.selectImageBlock(images,assets);
                [weakSelf selectFinishAciotn:NO];
                [weakSelf leftBarButtonClickViewController];
            }];
        }else{
            [self selectFinishAciotn:NO];
            [self leftBarButtonClickViewController];
        }
        return;
    }
    
    [self selectFinishAciotn:YES];
    
}

- (void)clearViewControllerAction {
    
    NSMutableArray *marr = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in marr) {
        if ([vc isKindOfClass:self.class]) {
            [marr removeObject:vc];
            break;
        }
    }
    self.navigationController.viewControllers = marr;
}

- (void)selectFinishAciotn:(BOOL)b {
    SelectType type = self.curType== PublishActivitySceneModelTypeVideo?SelectTypeOnlyVideo:SelectTypeOnlyImage;
    WeakSelf
    [self requestBigImage:^(NSArray<UIImage *> * _Nullable images, NSArray<PHAsset *> *assets) {
        !weakSelf.selectFinishBlock ?: weakSelf.selectFinishBlock(weakSelf.originalDataSource,type);
        if (b) {
            [weakSelf clearViewControllerAction];
        }
    }];
}

- (void)requestBigImage:(void(^)(NSArray<UIImage *> *_Nullable images, NSArray<PHAsset *> *assets))block {
    if (self.originalDataSource.count == 0) {  return; }
    [self popHintView];
    NSMutableArray *images = [[NSMutableArray alloc] init];
    NSMutableArray *assets = [[NSMutableArray alloc] init];
    CGFloat scale = 2;
    CGFloat width = MIN(kViewWidth, 400);
    WeakSelf
    for (int i = 0 ; i < self.originalDataSource.count; i ++) {
        ZLPhotoModel *model = self.originalDataSource[i];
        CGSize size = CGSizeMake(width*scale, width*scale*model.asset.pixelHeight/model.asset.pixelWidth);
        [assets addObject:model.asset];
        [ZLPhotoManager requestImageForAsset:model.asset size:size progressHandler:nil completion:^(UIImage *image, NSDictionary *info) {
            if ([[info objectForKey:PHImageResultIsDegradedKey] boolValue]) return;
            [images addObject:image];
            model.image = image;
            if (images.count == weakSelf.originalDataSource.count) {
                [weakSelf hideHintView];
                block(images,assets);
            }
        }];
    }
}

- (void)takePhoto{
    
    if (![ZLPhotoManager haveMicrophoneAuthority]) {
        NSString *message = [NSString stringWithFormat:GetLocalLanguageTextValue(ZLPhotoBrowserNoMicrophoneAuthorityText), kAPPName];
        [self showFailToast:message];
        return;
    }
    
    if ([self haveAuthority]) { return; }
    
    CustomCameraViewController *camera = [[CustomCameraViewController alloc] init];
    camera.allowTakePhoto = YES;
    camera.sessionPreset = ZLCaptureSessionPreset1280x720;
    camera.videoType = ZLExportVideoTypeMp4;
    camera.circleProgressColor = BRANDCOLOR();
    camera.maxRecordDuration = self.maxRecordDuration?: 180;
    camera.allowRecordVideo = !self.onlyImage;
    @zl_weakify(self);
    camera.doneBlock = ^(UIImage *image, NSURL *videoUrl) {
        @zl_strongify(self);
        [self saveImage:image videoUrl:videoUrl];
    };
    if(@available(iOS 13.0, *)) {
        camera.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    [self showDetailViewController:camera sender:nil];
}
- (void)saveImage:(UIImage *)image videoUrl:(NSURL *)videoUrl
{
    [self popHintView];
    @zl_weakify(self);
    if (image) {
        [ZLPhotoManager saveImageToAblum:image completion:^(BOOL suc, PHAsset *asset) {
            @zl_strongify(self);
            kDISPATCH_MAIN_THREAD( ^{
                if (suc) {
                    ZLPhotoModel *model = [ZLPhotoModel modelWithAsset:asset type:ZLAssetMediaTypeImage duration:nil];
                    [self handleDataArray:model];
                } else {
                    NSLog(@"%@",GetLocalLanguageTextValue(ZLPhotoBrowserSaveImageErrorText))
                }
                [self hideHintView];
            });
        }];
    } else if (videoUrl) {
        [ZLPhotoManager saveVideoToAblum:videoUrl completion:^(BOOL suc, PHAsset *asset) {
            @zl_strongify(self);
            kDISPATCH_MAIN_THREAD( ^{
                if (suc) {
                    ZLPhotoModel *model = [ZLPhotoModel modelWithAsset:asset type:ZLAssetMediaTypeVideo duration:nil];
                    model.duration = [ZLPhotoManager getDuration:asset];
                    [self handleDataArray:model];
                } else {
                    NSLog(@"%@",GetLocalLanguageTextValue(ZLPhotoBrowserSaveVideoFailed));
                }
                [self hideHintView];
            });
        }];
    }else{
        [self hideHintView];
        [self showFailToast:@"选择出错！"];
    }
}
- (void)handleDataArray:(ZLPhotoModel *)model{
    
    [self.dataSource insertObject:model atIndex:1];
    [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]]];
}

#pragma mark lazy load
-(NSMutableArray *)originalDataSource {
    if (_originalDataSource == nil) {
        _originalDataSource = [[NSMutableArray alloc] init];
    }
    return _originalDataSource;
}
-(NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}


#pragma mark pop View methord
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
