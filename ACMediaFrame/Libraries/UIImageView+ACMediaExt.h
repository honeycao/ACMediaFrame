//
//  UIImageView+ACMediaExt.h
//  ACMediaFrameExample
//
//  Created by caoyq on 2017/3/27.
//  Copyright © 2017年 ArthurCao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (ACMediaExt)

- (void)ac_setImageWithUrlString: (NSString *)urlString placeholderImage: (UIImage *)placeholderImage;

@end
