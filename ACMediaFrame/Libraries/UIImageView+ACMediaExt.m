//
//  UIImageView+ACMediaExt.m
//  ACMediaFrameExample
//
//  Created by caoyq on 2017/3/27.
//  Copyright © 2017年 ArthurCao. All rights reserved.
//

#import "UIImageView+ACMediaExt.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (ACMediaExt)

- (void)ac_setImageWithUrlString: (NSString *)urlString placeholderImage: (UIImage *)placeholderImage {
    [self sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:placeholderImage];
}

@end
