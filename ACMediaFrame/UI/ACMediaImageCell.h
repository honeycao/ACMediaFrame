//
//  ACMediaImageCell.h
//
//  Created by caoyq on 2021/4/20.
//  Copyright © 2021 ArthurCao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ACMediaImageCell : UICollectionViewCell

/// 展示的图片
@property (nonatomic, strong) UIImage *_Nullable showImage;
/// video 播放标签
@property (nonatomic, strong) UIImage *_Nullable videoTagImage;
/// 删除按钮图片
@property (nonatomic, strong) UIImage *_Nullable deleteButtonImage;

/** 点击删除按钮的回调block */
@property (nonatomic, copy) void(^ACMediaClickDeleteButton)();

@end

NS_ASSUME_NONNULL_END
