//
//  ViewController.m
//  SKSelectPhotos
//
//  Created by sunke on 2020/4/21.
//  Copyright © 2020 KentSun. All rights reserved.
//

#import "ViewController.h"
#import "SKSelectPhotosViewController.h"


@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}


- (IBAction)btnClick:(id)sender {
    
    
    SKSelectPhotosViewController *vc = [[SKSelectPhotosViewController alloc] init];
//    if (!self.model) {
//        self.model = [[PublishActivitySceneModel alloc] init];
//        self.model.datas = [[NSMutableArray alloc] init];
//        self.model.activityId = model.activityId;
//        self.model.activityTitle = model.title;
//        self.model.activityTypePic = model.categoryPic;
//        self.model.activityDate = [NSDateFormatter stringFromTimeStamp:model.date fromString:@"yyyy.MM.dd"];
//    }
    
//    vc.datas = self.model.datas;
    vc.maxVideoSelectCount = 1;
    vc.maxImageSelectCount = 9;
    vc.maxRecordDuration = 180;
    vc.onlyImage = YES;
    //WeakSelf
    vc.selectFinishBlock = ^(NSMutableArray * _Nonnull datas,SelectType type) {
//        weakSelf.model.datas = datas;
//        weakSelf.model.type = (type == SelectTypeOnlyImage)?PublishActivitySceneModelTypeImage:PublishActivitySceneModelTypeVideo;
//        [weakSelf skipPreviewViewController];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
    
}


@end
