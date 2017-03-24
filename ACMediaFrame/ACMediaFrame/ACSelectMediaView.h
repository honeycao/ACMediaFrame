//
//  ACSelectMediaView.h
//
//  Created by caoyq on 16/12/22.
//  Copyright © 2016年 ArthurCao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACMediaFrameConst.h"
#import "ACMediaModel.h"

typedef NS_ENUM(NSInteger, ACMediaType) {
    /** 本地图片媒体资源 */
    ACMediaTypePhoto = 0,
    /** 本地图片和拍摄图片媒体资源 */
    ACMediaTypePhotoAndCamera,
    /** 所有媒体资源 */
    ACMediaTypeAll
};

typedef void(^ACMediaHeightBlock)(CGFloat mediaHeight);

typedef void(^ACSelectMediaBackBlock)(NSArray<ACMediaModel *> *list);

/** 选择媒体 并 排列展示 的页面 */
@interface ACSelectMediaView : UIView

#pragma mark - properties

/** 
 * 需要展示的媒体的资源类型：如仅显示图片等，默认是 ACMediaTypeAll 
 */
@property (nonatomic, assign) ACMediaType type;

/** 
 * 媒体数据，用于存储选择的媒体资源，如果一开始有需要显示媒体资源，可以先传入进行显示。
 * 传入的如果是图片类型，则可以是：UIImage，NSString，至于其他的都可以传入 ACMediaModel
 */
@property (nonatomic, strong) NSMutableArray *mediaArray;

/**
 * 是否显示删除按钮. Defaults is YES
 */
@property (nonatomic, assign) BOOL showDelete;

/**
 * 是否需要显示添加按钮. Defaults is YES
 */
@property (nonatomic, assign) BOOL showAddButton;

/** 
 * 是否允许选择视频文件. default is NO 
 */
@property (nonatomic, assign) BOOL allowPickingVideo;


/**
 * 最大图片选择张数. default is 9
 */
@property (nonatomic, assign) NSInteger maxImageSelected;

/** 
 * 底部collectionView的 backgroundColor
 */
@property (nonatomic, strong) UIColor *backgroundColor;

#pragma mark - methods

/** 
 * 监控view的高度变化
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

@end


