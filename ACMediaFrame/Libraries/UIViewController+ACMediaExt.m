//
//  UIViewController+ACMediaExt.m
//
//  Version: 2.0.4
//  Created by ArthurCao<https://github.com/honeycao> on 16/12/24.
//  Update: 2017/12/27.
//

#import "UIViewController+ACMediaExt.h"

@implementation UIViewController (ACMediaExt)

/**
 快速创建AlertController：包括Alert 和 ActionSheet
 
 @param title       标题文字
 @param message     消息体文字
 @param actions     可选择点击的按钮（不包括取消）
 @param cancelTitle 取消按钮（可自定义按钮文字）
 @param style       类型：Alert 或者 ActionSheet
 @param completion  完成点击按钮之后的回调（不包括取消）
 */
+ (void)showAlertWithTitle: (NSString *)title message: (NSString *)message actionTitles: (NSArray<NSString *> *)actions cancelTitle: (NSString *)cancelTitle style: (UIAlertControllerStyle)style completion: (void(^)(NSInteger index))completion {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    for (NSInteger index = 0; index < actions.count; index++) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:actions[index] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            !completion ?  : completion(index);
        }];
        [alert addAction:action];
    }
    if (cancelTitle.length) {
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
    }
    UIViewController *vc = [[UIApplication sharedApplication] keyWindow].rootViewController;
    [vc presentViewController:alert animated:YES completion:nil];
}

@end
