//
//  UIView+ACMediaExt.h
//
//  Version: 2.0.4
//  Created by ArthurCao<https://github.com/honeycao> on 16/12/24.
//  Update: 2017/12/27.
//

#import <UIKit/UIKit.h>

@interface UIView (ACMediaExt)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;

/**
 寻找当前view所在的主视图控制器
 
 @return 返回当前主视图控制器
 */
- (UIViewController *)viewController;

@end
