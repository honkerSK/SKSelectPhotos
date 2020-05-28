//
//  CustomCameraViewController.h
//  xiangwan
//
//  Created by mac on 2020/1/4.
//  Copyright © 2020 mac. All rights reserved.
//
// 拍照 和 录像
#import <UIKit/UIKit.h>
#import "ZLDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomCameraViewController : UIViewController


//是否允许拍照 默认YES
@property (nonatomic, assign) BOOL allowTakePhoto;
//是否允许录制视频 默认YES
@property (nonatomic, assign) BOOL allowRecordVideo;

//最大录制时长 默认15s
@property (nonatomic, assign) NSInteger maxRecordDuration;

//视频分辨率 默认 ZLCaptureSessionPreset1280x720
@property (nonatomic, assign) ZLCaptureSessionPreset sessionPreset;

//视频格式 默认 ZLExportVideoTypeMp4
@property (nonatomic, assign) ZLExportVideoType videoType;

//录制视频时候进度条颜色 默认 rgb(80, 169, 56)
@property (nonatomic, strong) UIColor *circleProgressColor;

/**
 确定回调，如果拍照则videoUrl为nil，如果视频则image为nil
 */
@property (nonatomic, copy) void (^doneBlock)(UIImage *image, NSURL *videoUrl);
@end

NS_ASSUME_NONNULL_END
