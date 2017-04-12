//
//  ACAlertController.h
//
//  Created by caoyq on 2017/3/9.
//  Copyright © 2017年 ArthurCao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickActionBlock)(NSInteger index);

@interface ACAlertController : UIView

#pragma mark - properties

/** cancel button text color */
@property (nonatomic, strong) UIColor * cancelButtonTextColor;

/** cancel button text font */
@property (nonatomic, strong) UIFont *cancelButtonTextFont;

/** all action buttons text color */
@property (nonatomic, strong)  UIColor *actionButtonsTextColor;

/** all action buttons text font */
@property (nonatomic, strong)  UIFont *actionButtonsTextFont;

#pragma mark - methods

/**
 *  Init
 */
- (instancetype)initWithActionSheetTitles: ( NSArray<NSString *> *)titles cancelTitle: (NSString *)cancelTitle;

/**
 *  display
 */
- (void)show;

/**
 * 选中actionButton之后的一个回调block，返回选中下标，index start from 0.
 */
- (void)clickActionButton: (ClickActionBlock)clickBlock;

/**
 set action button text color with index.
 
 @param color  color
 @param index  the index of the action button you set.
 */
- (void)configureActionButtonTextColor: (UIColor *)color index: (NSInteger)index;

/**
 set action button text font with index.

 @param font   font
 @param index  the index of the action button you set.
 */
- (void)configureActionButtonTextFont:(UIFont *)font index:(NSInteger)index;

@end
