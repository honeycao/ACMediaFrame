//
//  UIViewController+ACMediaExt.h
//
//  Version: 2.0.4
//  Created by ArthurCao<https://github.com/honeycao> on 16/12/24.
//  Update: 2017/12/27.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ACMediaExt)

+ (void)showAlertWithTitle: (NSString *)title message: (NSString *)message actionTitles: (NSArray<NSString *> *)actions cancelTitle: (NSString *)cancelTitle style: (UIAlertControllerStyle)style completion: (void(^)(NSInteger index))completion;

@end
