//
//  ACMediaImageCell.h
//
//  Created by caoyq on 16/12/2.
//  Copyright © 2016年 SnSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 用于展示的 媒体图片cell */
@interface ACMediaImageCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *icon;
/** 删除按钮 */
@property (nonatomic, strong) UIButton *deleteButton;

/** 视频标志 */
@property (nonatomic, strong) UIImageView *videoImageView;

/** 点击删除按钮的回调block */
@property (nonatomic, copy) void(^ACMediaClickDeleteButton)();

@end
