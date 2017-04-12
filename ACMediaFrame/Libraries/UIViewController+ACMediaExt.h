//
//  UIViewController+ACMediaExt.h
//
//  Created by caoyq on 16/12/24.
//  Copyright © 2016年 ArthurCao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ACMediaExt)

+ (void)showAlertWithTitle: (NSString *)title message: (NSString *)message actionTitles: (NSArray<NSString *> *)actions cancelTitle: (NSString *)cancelTitle style: (UIAlertControllerStyle)style completion: (void(^)(NSInteger index))completion;

@end
