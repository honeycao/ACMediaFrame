//
//  ACMediaPickerManager.h
//
//  Created by caoyq on 2018/11/9.
//  Copyright © 2018 AllenCao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACMediaModel.h"

///来源
typedef NS_ENUM(NSInteger, ACMediaPickerSource) {
    ACMediaPickerSourceFromAll = 0,   /**< 选择相册或相机 */
    ACMediaPickerSourceFromAlbum,     /**< 打开相册 */
    ACMediaPickerSourceFromCamera     /**< 打开相机 */
};

/**
 * 调用相机或相册，并统一处理选中的图片、gif、视频 功能的封装。根据属性自定义功能。
 *
 * 1. 先在 @interface 下定义该属性，再用 init 初始化，避免 delegate 失效。
 *
 * 2. 设置 pickerSource 为 ACMediaPickerSourceFromAll，调用 picker 方法会弹出 UIAlertController 进行选择，如果想自定义弹框样式，那么可以不调用 picker 方法，而是手动选择 openCustomAlbum/openSystemAlbum 等方法。
 *
 * 3. 已自动对图片方向不是 UIImageOrientationUp 的进行了修正。 
 */
@interface ACMediaPickerManager : NSObject

/**
 * 媒体文件的来源.
 *
 * 默认为 ACMediaPickerSourceAll，会弹出一个UIAlertController进行选择；如果为其他两种则不会弹框，直接打开相册或相机。
 */
@property (nonatomic, assign) ACMediaPickerSource pickerSource;
/** 可选择的最大个数(视频与图片). default is 9. */
@property (nonatomic, assign) NSInteger maxImageSelected;
///是否允许选择图片，default is YES.
@property (nonatomic, assign) BOOL allowPickingImage;
///是否允许选择gif，gif是伴随图片一起出现的，default is NO.
@property (nonatomic, assign) BOOL allowPickingGif;
///是否允许选择视频，default is NO.
@property (nonatomic, assign) BOOL allowPickingVideo;

/**
 * 打开相册时：是否允许在图片列表中出现拍照按钮. default is NO.
 *
 * 打开相机时：是否是拍照模式。
 */
@property (nonatomic, assign) BOOL allowTakePicture;
/** 是否允许 相册中出现选择原图按钮. default is NO. */
@property (nonatomic, assign) BOOL allowPickingOriginalPhoto;
///是否允许多选视频/gif，也受maxImageSelected限制，default is NO.
@property (nonatomic, assign) BOOL allowPickingMultipleVideo;

/**
 * 打开相册时：是否允许在视频列表中出现拍摄视频的按钮. defalut is NO。
 *
 * 打开相机时：是否是录像模式。
 */
@property (nonatomic, assign) BOOL allowTakeVideo;
///录像最长时间，默认60s
@property (nonatomic, assign) CGFloat videoMaximumDuration;

/**
 * 已选择的图片、视频数组。
 *
 * 如果下一次选择不需要记录上一次的结果，可以不用传值，反之就需要进行传值。
 *
 * 数组的值在 didFinishPickingBlock 返回的list范围内。
 */
@property (nonatomic, strong) NSArray<ACMediaModel *> *seletedMediaArray;
/** 选择文件结束后的回调。调用方可以进行保存，方便下次给 seletedMediaArray 赋值。*/
@property (nonatomic, copy) void(^didFinishPickingBlock)(NSArray<ACMediaModel *> *list);

/******* 外观属性 *******/

///默认是 UIStatusBarStyleLightContent
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
@property (nonatomic, strong) UIColor *naviBgColor;
@property (nonatomic, strong) UIColor *naviTitleColor;
@property (nonatomic, strong) UIFont *naviTitleFont;
@property (nonatomic, strong) UIColor *barItemTextColor;
@property (nonatomic, strong) UIFont *barItemTextFont;

#pragma mark - Methods

///调用选择控制器。相册默认调用openCustomAlbum，相机默认调用openSystemCamera
- (void)picker;

/// 自定义相册，支持多选，包含相册权限判定。
- (void)openCustomAlbum;
///系统相册，只能单选
- (void)openSystemAlbum;

/**
 * 打开系统相机。默认拍照。
 *
 * 属性 allowTakePicture 为 YES，表示拍照，优先级最高。
 * 属性 allowTakeVideo 为 YES，表示录像。
 */
- (void)openSystemCamera;

@end
