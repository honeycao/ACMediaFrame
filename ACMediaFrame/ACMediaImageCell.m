//
//  ACMediaImageCell.m
//
//  Version: 2.0.4.
//  Created by ArthurCao<https://github.com/honeycao> on 2016/12/2.
//  Update: 2017/12/27.
//

#import "ACMediaImageCell.h"
#import "UIImageView+ACMediaExt.h"
#import "UIImage+ACGif.h"
#import "ACMediaFrameConst.h"

@interface ACMediaImageCell ()

///图片
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

    _deleteButton = [[UIButton alloc] init];
    [_deleteButton setBackgroundImage:[UIImage imageForResourcePath:@"ACMediaFrame.bundle/deleteButton" ofType:@"png" inBundle:[NSBundle bundleForClass:[self class]]] forState:UIControlStateNormal];
    [_deleteButton addTarget:self action:@selector(clickDeleteButton) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_deleteButton];
    
    _videoImageView = [[UIImageView alloc] initWithImage:[UIImage imageForResourcePath:@"ACMediaFrame.bundle/ShowVideo" ofType:@"png" inBundle:[NSBundle bundleForClass:[self class]]]];
    [self.contentView addSubview:_videoImageView];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _icon.frame = self.bounds;
    _deleteButton.frame = CGRectMake(self.bounds.size.width - ACMediaDeleteButtonWidth, 0, ACMediaDeleteButtonWidth, ACMediaDeleteButtonWidth);
    _videoImageView.frame = CGRectMake(self.bounds.size.width/4, self.bounds.size.width/4, self.bounds.size.width/2, self.bounds.size.width/2);
}

#pragma mark - public methods

- (void)showAddWithImage: (UIImage *)addImage
{
    if (addImage) {
        self.icon.image = addImage;
    }else {
        self.icon.image = [UIImage imageForResourcePath:@"ACMediaFrame.bundle/AddMedia" ofType:@"png" inBundle:[NSBundle bundleForClass:[self class]]];
    }
    self.deleteButton.hidden = YES;
    self.videoImageView.hidden = YES;
}

- (void)showIconWithUrlString: (NSString *)urlString image: (UIImage *)image
{
    if (urlString){
        [self.icon ac_setImageWithUrlString:urlString placeholderImage:nil];
    }else if (image){
        self.icon.image = image;
    }
}

- (void)deleteButtonWithImage: (UIImage *)deleteImage show: (BOOL)show
{
    if (deleteImage) {
        [self.deleteButton setBackgroundImage:deleteImage forState:UIControlStateNormal];
    }
    self.deleteButton.hidden = !show;
}

- (void)videoImage: (UIImage *)videoImage show: (BOOL)show
{
    if (videoImage) {
        self.videoImageView.image = videoImage;
    }
    self.videoImageView.hidden = !show;
}

- (void)clickDeleteButton {
    !_ACMediaClickDeleteButton ?  : _ACMediaClickDeleteButton();
}

@end
