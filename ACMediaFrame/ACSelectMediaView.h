//
//  ACSelectMediaView.h
//
//  Created by caoyq on 17/04/12.
//  Copyright © 2016年 ArthurCao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACMediaModel.h"

/** 媒体资源的类型 */
typedef NS_ENUM(NSInteger, ACMediaType) {
    /** 本地图片和相机 */
    ACMediaTypePhotoAndCamera = 0,
    /** 本地图片 */
    ACMediaTypePhoto,
    /** 相机拍摄 */
    ACMediaTypeCamera,
    /** 录像 */
    ACMediaTypeVideotape,
    /** 视频 */
    ACMediaTypeVideo,
    /** 所有媒体资源 */
    ACMediaTypeAll
};

typedef void(^ACMediaHeightBlock)(CGFloat mediaHeight);

typedef void(^ACSelectMediaBackBlock)(NSArray<ACMediaModel *> *list);

/** 选择媒体 并 排列展示 的页面 */
@interface ACSelectMediaView : UIView

#pragma mark - properties

/** 
 * 需要展示的媒体的资源类型：如仅显示图片等，默认是 ACMediaTypePhotoAndCamera
 */
@property (nonatomic, assign) ACMediaType type;

/** 
 * 预先展示的媒体数组。如果一开始有需要显示媒体资源，可以先传入进行显示，没有的话可以不赋值。
 * 传入的如果是图片类型，则可以是：UIImage，NSString，至于其他的都可以传入 ACMediaModel类型
 * 当前只支持图片和视频
 */
@property (nonatomic, strong) NSArray *preShowMedias;

/**
 * 最大图片选择张数. default is 9
 */
@property (nonatomic, assign) NSInteger maxImageSelected;

/**
 * 是否显示删除按钮. Defaults is YES
 */
@property (nonatomic, assign) BOOL showDelete;

/**
 * 是否需要显示添加按钮. Defaults is YES
 */
@property (nonatomic, assign) BOOL showAddButton;

/** 
 * 是否允许 在选择图片的同时可以选择视频文件. default is NO
 */
@property (nonatomic, assign) BOOL allowPickingVideo;

/** 
 * 是否允许 同个图片或视频进行多次选择. default is YES 
 */
@property (nonatomic, assign) BOOL allowMultipleSelection;

/** 
 * 底部collectionView的 backgroundColor
 */
@property (nonatomic, strong) UIColor *backgroundColor;

#pragma mark - methods

/** 
 * 监控view的高度变化，如果不和其他控件一起使用，则可以不用监控高度变化
 */
- (void)observeViewHeight: (ACMediaHeightBlock)value;

/** 
 * 随时监控当前选择到的媒体文件 
 */
- (void)observeSelectedMediaArray: (ACSelectMediaBackBlock)backBlock;

/**
 * 视图一开始默认高度
 */
+ (CGFloat)defaultViewHeight;

/**
 * 刷新
 */
- (void)reload;

@end
