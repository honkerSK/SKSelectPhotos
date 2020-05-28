//
//  PreviewViewController.m
//  xiangwan
//
//  Created by mac on 2019/8/17.
//  Copyright © 2019 mac. All rights reserved.
//

#import "PreviewViewController.h"
//#import "PublishActivitySceneModel.h"
#import "NavView.h"
#import "PreviewCell.h"
#import "MainButton.h"

@interface PreviewViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, weak) UIView *bottomView;
@property (nonatomic, weak) NavView *navView;
@property (nonatomic, weak) UILabel *pageLb;
@property (nonatomic, weak) MainButton *finishBtn;

@end

@implementation PreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self initData];

    [self setup];
    
}
- (void)initData {
    
    self.dataSource = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < self.datas.count; i ++) {
        ZLPhotoModel *obj = self.datas[i];
        if (obj.url) {
            obj.type = ZLAssetMediaTypeNetImage;
        }
        [self.dataSource addObject:obj];
    }
}
- (void)setup {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(nScreenWidth(), nScreenHeight());
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.pagingEnabled = YES;
    collectionView.decelerationRate = 0.8;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:collectionView];
    
    [PreviewCell registerClassForCollectionView:collectionView];
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    if (self.idx > 0) {
        [UIView animateWithDuration:0.01 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            NSIndexPath *path = [NSIndexPath indexPathForRow:self.idx inSection:0];
            [collectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        }];
    }
    
    NavView *navView = [[NavView alloc] initWithFrame:CGRectMake(0, 0, nScreenWidth(), kStatusBarAndNavigationBarHeight)];
    navView.backgroundColor = COLORFFFFFF();
    navView.leftIcon = @"public_back";
    if (self.type == PreviewViewTypeEdit) {
        ZLPhotoModel *obj = self.datas[self.idx];
        navView.rightIcon = obj.isSelected ?@"public_media_select_s":@"public_media_select";
    }
    navView.title = @"预览";
    navView.titleColor = MAINCOLOR();
    [self.view addSubview:navView];
    self.navView = navView;
    WeakSelf
    navView.leftAction = ^{
        [weakSelf leftBackAction];
    };
    if (self.type == PreviewViewTypeEdit) {
        navView.rightAction = ^{
            [weakSelf rightBackAction];
        };
    }
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = COLORFFFFFF();
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.mas_equalTo(66+kSafeAreaBottomHeight);
    }];
    
    [bottomView makeTopShadow];
    self.bottomView = bottomView;
    
    UILabel *pageLb = [[UILabel alloc] init];
    pageLb.textColor = MAINCOLOR();
    pageLb.font = FONTBOLDSIZE(16);
    pageLb.text = [NSString stringWithFormat:@"%ld/%ld",self.idx+1,self.datas.count];
    [bottomView addSubview:pageLb];
    self.pageLb = pageLb;
    [pageLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.inset(16);
        make.top.inset(22);
    }];
    
    MainButton *finishBtn = [MainButton mainButton];
    finishBtn.text = @"完成";
    [bottomView addSubview:finishBtn];
    self.finishBtn = finishBtn;
    finishBtn.clickBlock = ^{
        [weakSelf finishAction];
    };
    [finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.inset(16);
        make.size.mas_equalTo(CGSizeMake(105, 48));
        make.top.mas_equalTo(9);
    }];
}

- (void)finishAction {
    [self clearData];
    !self.reloadAction ?: self.reloadAction(self.datas);
    NSMutableArray *marr = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in marr) {
        if ([vc isKindOfClass:self.class]) {
            [marr removeObject:vc];
            break;
        }
    }
    self.navigationController.viewControllers = marr;
    /**
    if ([self verifyController:PublishActivitySceneViewController.className]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    PublishActivitySceneViewController *vc = [[PublishActivitySceneViewController alloc] init];
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];*/
}
- (void)rightBackAction{
    ZLPhotoModel *model = self.dataSource[self.idx];
    model.selected = !model.isSelected;
    if (self.type == PreviewViewTypeEdit) {
        self.navView.rightIcon = model.isSelected ?@"public_media_select_s":@"public_media_select";
    }
    if (model.selected) {
        if (![self.datas containsObject:model]) {
            [self.datas addObject:model];
        }
    }else{
        [self.datas removeObject:model];
    }
    self.pageLb.text = [NSString stringWithFormat:@"%ld/%ld",self.idx+1,self.datas.count];
    self.finishBtn.enabled = (self.datas.count > 0);
    !self.cancelAction ?: self.cancelAction(model);
}
- (void)clearData {
    [self.datas enumerateObjectsUsingBlock:^(ZLPhotoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.selected) {
            [self.datas removeObject:obj];
        }
    }];
}
- (void)leftBackAction {
    [self clearData];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma --mark conllectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[PreviewCell identifier] forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    WeakSelf
    cell.cellTap = ^{
        [weakSelf showOrHiddenAnimation];
    };
    NSLog(@"%ld",indexPath.row);
    return cell;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.idx = scrollView.contentOffset.x/nScreenWidth();
    self.pageLb.text = [NSString stringWithFormat:@"%ld/%ld",self.idx+1,self.datas.count];
    ZLPhotoModel *model = self.dataSource[self.idx];
    if (self.type == PreviewViewTypeEdit) {
        self.navView.rightIcon = model.selected ?@"public_media_select_s":@"public_media_select";
    }
}
- (void)showOrHiddenAnimation {
    CGFloat alpha = (self.bottomView.alpha == 0)?1:0;
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomView.alpha = alpha;
        self.navView.alpha = alpha;
    }];
}


@end
