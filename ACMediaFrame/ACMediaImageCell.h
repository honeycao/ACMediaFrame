//
//  ACMediaImageCell.h
//
//  Version: 2.0.4.
//  Created by ArthurCao<https://github.com/honeycao> on 2016/12/2.
//  Update: 2017/12/27.
//

#import <UIKit/UIKit.h>

/** 用于展示的 媒体图片cell */
@interface ACMediaImageCell : UICollectionViewCell

- (void)showAddWithImage: (UIImage *)addImage;

- (void)showIconWithUrlString: (NSString *)urlString image: (UIImage *)image;

- (void)deleteButtonWithImage: (UIImage *)deleteImage show: (BOOL)show;

- (void)videoImage: (UIImage *)videoImage show: (BOOL)show;

/** 点击删除按钮的回调block */
@property (nonatomic, copy) void(^ACMediaClickDeleteButton)();

@end
