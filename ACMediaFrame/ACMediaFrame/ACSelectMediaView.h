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

/** 需要展示的媒体的资源类型：如仅显示图片等，默认是所有资源 */
@property (nonatomic, assign) ACMediaType type;

/** 监控view的高度变化 */
- (void)observeViewHeight: (ACMediaHeightBlock)value;

/** 随时监控当前选择到的媒体文件 */
- (void)observeSelectedMediaArray: (ACSelectMediaBackBlock)backBlock;

/**
 视图一开始默认高度
 */
+ (CGFloat)defaultViewHeight;

@end


