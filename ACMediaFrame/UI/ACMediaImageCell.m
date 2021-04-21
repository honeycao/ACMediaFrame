//
//  ACMediaImageCell.m
//
//  Created by caoyq on 2021/4/20.
//  Copyright © 2021 ArthurCao. All rights reserved.
//

#import "ACMediaImageCell.h"

static inline CGFloat deleteButtonWidth() {
    return 20 * [UIScreen mainScreen].bounds.size.width / 375.0;
}

@interface ACMediaImageCell ()

/// 图片
@property (nonatomic, strong) UIImageView *icon;
/** 删除按钮 */
@property (nonatomic, strong) UIButton *deleteButton;
/** 视频标志 */
@property (nonatomic, strong) UIImageView *videoImageView;

@end

@implementation ACMediaImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _setupViews];
    }
    return self;
}

- (void)_setupViews {
    _icon = [[UIImageView alloc] init];
    _icon.clipsToBounds = YES;
    _icon.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_icon];

    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteButton addTarget:self action:@selector(clickDeleteButton) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_deleteButton];
    
    _videoImageView = [UIImageView new];
    [self.contentView addSubview:_videoImageView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _icon.frame = self.bounds;
    CGFloat btnWidth = deleteButtonWidth();
    _deleteButton.frame = CGRectMake(self.bounds.size.width - btnWidth, 0, btnWidth, btnWidth);
    _videoImageView.frame = CGRectMake(self.bounds.size.width/4, self.bounds.size.width/4, self.bounds.size.width/2, self.bounds.size.width/2);
}

#pragma mark - setter

- (void)setShowImage:(UIImage *)showImage {
    self.icon.image = showImage;
}

- (void)setDeleteButtonImage:(UIImage *)deleteButtonImage {
    [self.deleteButton setImage:deleteButtonImage forState:UIControlStateNormal];
}

- (void)setVideoTagImage:(UIImage *)videoTagImage {
    self.videoImageView.image = videoTagImage;
}

#pragma mark - Action

- (void)clickDeleteButton {
    !_ACMediaClickDeleteButton ?  : _ACMediaClickDeleteButton();
}

@end
