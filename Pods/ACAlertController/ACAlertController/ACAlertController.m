//
//  ACAlertController.m
//
//  Created by caoyq on 2017/3/9.
//  Copyright © 2017年 ArthurCao. All rights reserved.
//

#import "ACAlertController.h"

#define ACScreenWidth [UIScreen mainScreen].bounds.size.width

#define ACScreenHeight [UIScreen mainScreen].bounds.size.height

#define kRadio   ACScreenWidth / 375.0

#define kTextFont  16 * kRadio  //字体大小

#define ButtonHeight 45 //每个按钮的高度

#define CancleMargin 8 //取消按钮上面的间隔

#define ACColor(r, g, b) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0]

#define BgColor ACColor(237,240,242) //背景色

#define SeparatorColor ACColor(226, 226, 226) //分割线颜色

#define normalImage [self imageWithColor:ACColor(255,255,255)] //按钮普通状态下的图片

#define highImage [self imageWithColor:ACColor(242,242,242)] //按钮高亮状态下的图片

@interface ACAlertController ()

/** 底部遮罩层 */
@property (nonatomic, strong) ACAlertController *shadeView;

/** 展示层 */
@property (nonatomic, strong) UIView *sheetView;

/** block */
@property (nonatomic, copy) ClickActionBlock block;

/** all action button */
@property (nonatomic, strong) NSMutableArray *allActionButton;

/** cancel button */
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation ACAlertController

- (instancetype)initWithActionSheetTitles: (NSArray<NSString *> *)titles cancelTitle: (NSString *)cancelTitle {
    
    if (titles.count == 0 || cancelTitle.length == 0) {
        return nil;
    }
    
    // self 为底部遮罩层
    ACAlertController *shadeView = [self init];
    shadeView.frame = [UIScreen mainScreen].bounds;
    shadeView.backgroundColor = [UIColor blackColor];
    shadeView.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:shadeView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadeViewClick)];
    [shadeView addGestureRecognizer:tap];
    self.shadeView = shadeView;
    
    CGFloat sheetHeight = (titles.count + 1) * ButtonHeight + CancleMargin;
    UIView *sheetView = [[UIView alloc] initWithFrame:CGRectMake(0, ACScreenHeight, ACScreenWidth, sheetHeight)];
    sheetView.backgroundColor = BgColor;
    sheetView.alpha = 0.9;
    [[UIApplication sharedApplication].keyWindow addSubview:sheetView];
    self.sheetView = sheetView;
    
    [self setupButtonsWithTitles:titles];
    [self setupCancelButtonWithTitle:cancelTitle];
    
    return shadeView;
}

#pragma mark - public methods

- (void)show {
    CGRect rect = self.sheetView.frame;
    rect.origin.y = ACScreenHeight - self.sheetView.frame.size.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.sheetView.frame = rect;
        self.shadeView.alpha = 0.3;
    }];
}

- (void)clickActionButton:(ClickActionBlock)clickBlock {
    self.block = clickBlock;
}

- (void)configureActionButtonTextColor:(UIColor *)color index:(NSInteger)index {
    UIButton *btn = _allActionButton[index];
    [btn setTitleColor:color forState:UIControlStateNormal];
}

- (void)configureActionButtonTextFont:(UIFont *)font index:(NSInteger)index {
    UIButton *btn = _allActionButton[index];
    [btn.titleLabel setFont:font];
}

#pragma mark - setter

- (void)setCancelButtonTextColor:(UIColor *)cancelButtonTextColor {
    _cancelButtonTextColor = cancelButtonTextColor;
    [self.cancelButton setTitleColor:_cancelButtonTextColor forState:UIControlStateNormal];
}

- (void)setCancelButtonTextFont:(UIFont *)cancelButtonTextFont {
    _cancelButtonTextFont = cancelButtonTextFont;
    [self.cancelButton.titleLabel setFont:_cancelButtonTextFont];
}

- (void)setActionButtonsTextColor:(UIColor *)actionButtonsTextColor {
    _actionButtonsTextColor = actionButtonsTextColor;
    for (UIButton *btn in _allActionButton) {
        [btn.titleLabel setTextColor:actionButtonsTextColor];
    }
}

- (void)setActionButtonsTextFont:(UIFont *)actionButtonsTextFont {
    _actionButtonsTextFont = actionButtonsTextFont;
    for (UIButton *btn in _allActionButton) {
        [btn.titleLabel setFont:actionButtonsTextFont];
    }
}

#pragma mark - actions

/** dismiss */
- (void)hide {
    
    CGRect rect = self.sheetView.frame;
    rect.origin.y = ACScreenHeight;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.sheetView.frame = rect;
        self.shadeView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.shadeView removeFromSuperview];
        [self.sheetView removeFromSuperview];
    }];
}

/** click shade view */
- (void)shadeViewClick {
    [self hide];
}

- (void)actionButtonClick: (UIButton *)btn {
    
    //tag start with 100
    NSInteger tag = btn.tag - 100;
    
    if (tag != 0) {
        if (self.block) {
            self.block(tag - 1);
        }
    }
    [self hide];
}

#pragma mark - private

/** setup action buttons */
- (void)setupButtonsWithTitles: (NSArray *)titles {
    _allActionButton = [NSMutableArray array];
    for (NSInteger idx = 0; idx < titles.count; idx ++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, ButtonHeight * idx , ACScreenWidth, ButtonHeight)];
        [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
        [btn setBackgroundImage:highImage forState:UIControlStateHighlighted];
        [btn setTitle:titles[idx] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:kTextFont];
        btn.tag = 101 + idx;
        [btn addTarget:self action:@selector(actionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.sheetView addSubview:btn];
        
        // top separator line
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ACScreenWidth, 0.5)];
        line.backgroundColor = SeparatorColor;
        [btn addSubview:line];
        [_allActionButton addObject:btn];
    }
}

/** setup cancel button */
- (void)setupCancelButtonWithTitle: (NSString *)title {
    
    CGFloat btnY = self.sheetView.frame.size.height - ButtonHeight;
    UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, btnY, ACScreenWidth, ButtonHeight)];
    [cancel setBackgroundImage:normalImage forState:UIControlStateNormal];
    [cancel setBackgroundImage:highImage forState:UIControlStateHighlighted];
    [cancel setTitle:title forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont systemFontOfSize:kTextFont];
    cancel.tag = 100;
    [cancel addTarget:self action:@selector(actionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.sheetView addSubview:cancel];
    self.cancelButton = cancel;
}

/**
 根据颜色生成图片
 @param color 颜色
 @return 图片
 */
- (UIImage*)imageWithColor:(UIColor*)color {
    
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
