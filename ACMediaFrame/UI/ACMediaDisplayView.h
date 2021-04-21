//
//  ACMediaDisplayView.h
//
//  Created by caoyq on 2021/4/20.
//  Copyright © 2021 ArthurCao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACMediaDisplayConfig.h"
#import "ACMediaPickerManager.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * UI 展示层 + 核心功能
 */
@interface ACMediaDisplayView : UIView
 
/// 对外提供已选中的媒体资源列表.
@property (nonatomic, strong, readonly) NSArray *selectedMediaList;
/// 对外提供容器实时的高度
@property (nonatomic, assign, readonly) CGFloat viewHeight;

- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithConfig: (ACMediaDisplayConfig *)config;
- (instancetype)initWithFrame:(CGRect)frame config: (ACMediaDisplayConfig *)config;

/// 可选：外部支持半定义 pickerManager
@property (nonatomic, copy) void (^customizePickerManagerBlock)(ACMediaPickerManager *pickerMgr);
/// 可选：定制图片/视频的预览功能，默认有简单预览的功能.
@property (nonatomic, copy) void (^customizeMediaPreviewBlock)(NSArray<ACMediaModel *> *list, NSInteger currentIndex);

/// 监听容器高度的改变
@property (nonatomic, copy) void (^observeContainerHeightChangeBlock)(CGFloat viewHeight);

@end

NS_ASSUME_NONNULL_END
