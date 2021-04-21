//
//  ACMediaDisplayConfig.h
//
//  Created by caoyq on 2021/4/20.
//  Copyright © 2021 ArthurCao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * UI 配置项
 */
@interface ACMediaDisplayConfig : NSObject

/// 容器背景色
@property (nonatomic, strong) UIColor *containerBgColor;

/** 一行显示图片个数. default is 4. */
@property (nonatomic, assign) NSInteger rowImageCount;
/** item行间距. default is 10. */
@property (nonatomic, assign) CGFloat lineSpacing;
/** item列间距. default is 10. */
@property (nonatomic, assign) CGFloat interitemSpacing;
/** section边距. default is (10, 10, 10, 10). */
@property (nonatomic, assign) UIEdgeInsets sectionInset;

/******* 图片资源为可选，可手动传入进行自定义 *******/

/** 添加按钮的图片. 不想使用自带的图片可以自定义传入. */
@property (nonatomic, strong) UIImage *addImage;
/** 删除按钮的图片. 不想使用自带的图片可以自定义传入. */
@property (nonatomic, strong) UIImage *deleteImage;
/** 视频标签图片. 不想使用自带的图片可以自定义传入. */
@property (nonatomic, strong) UIImage *videoTagImage;

@end

NS_ASSUME_NONNULL_END
