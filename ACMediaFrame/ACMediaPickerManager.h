//
//  ACMediaPickerManager.h
//
//  Created by caoyq on 2018/11/9.
//  Copyright © 2018 AllenCao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACMediaModel.h"

NS_ASSUME_NONNULL_BEGIN

///来源
typedef NS_ENUM(NSInteger, ACMediaPickerSource) {
    ACMediaPickerSourceFromAll = 0,   /**< 选择相册或相机 */
    ACMediaPickerSourceFromAlbum,     /**< 打开相册 */
    ACMediaPickerSourceFromCamera     /**< 打开相机 */
};

///相册可供选择的资源类型
typedef NS_ENUM(NSInteger, ACMediaAlbumType) {
    ACMediaAlbumTypeAll,     /**< 可选择图片与视频 */
    ACMediaAlbumTypePhoto,   /**< 只选择图片 */
    ACMediaAlbumTypeVideo    /**< 只选择视频 */
};

///相机可供自拍摄的资源类型
typedef NS_ENUM(NSInteger, ACMediaCameraType) {
    ACMediaCameraTypePhoto = 0,   /**< 拍照 */
    ACMediaCameraTypeVideo,       /**< 录制视频 */
};

/**
 * 调用相机或相册，并统一处理选中的图片、gif、视频 功能的封装.
 *
 * 1. 初始化 ACMediaPickerManager 的时候，在 @interface 下定义该属性的话就可以直接 init方法 初始化，不定义属性就采用 manager单例初始化，避免delegate失效。
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

/**
 * 打开相册后，可选择的媒体文件类型. 默认是能选择图片与视频.
 */
@property (nonatomic, assign) ACMediaAlbumType albumType;

/** 打开相机后，自定义的操作. 默认是拍照. */
@property (nonatomic, assign) ACMediaCameraType cameraType;

/**
 * 可选择的最大个数(视频与图片). default is 9.
 */
@property (nonatomic, assign) NSInteger maxImageSelected;

/**
 * 是否允许 在相册中出现拍照按钮. default is NO.
 */
@property (nonatomic, assign) BOOL allowTakePicture;

/**
 * 是否允许 相册中出现选择原图按钮. default is NO.
 */
@property (nonatomic, assign) BOOL allowPickingOriginalPhoto;

/**
 * 已选择的图片、视频数组。
 *
 * 如果下一次选择不需要记录上一次的结果，可以不用传值；
 * 反之就需要进行传值。
 *
 * 数组的值在 didFinishPickingBlock 返回的list范围内。
 */
@property (nonatomic, strong) NSArray<ACMediaModel *> *seletedMediaArray;

/**
 * 选择文件结束后的回调。调用方可以进行保存，方便下次给 seletedMediaArray 赋值。
 */
@property (nonatomic, copy) void(^didFinishPickingBlock)(NSArray<ACMediaModel *> *list);

#pragma mark - methods

+ (instancetype)manager;

///调用选择控制器。相册默认调用openCustomAlbum，相机默认调用openSystemCamera
- (void)picker;

/**
 * 自定义相册，支持多选。包含相册权限判定。
 */
- (void)openCustomAlbum;
///系统相册，只能单选
- (void)openSystemAlbum;
- (void)openSystemCamera;

@end

NS_ASSUME_NONNULL_END
