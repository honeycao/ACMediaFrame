//
//  UIImage+ACGif.m
//  ACMediaFrameExample
//
//  Created by caoyq on 2017/4/26.
//  Copyright © 2017年 ArthurCao. All rights reserved.
//

#import "UIImage+ACGif.h"
#import "UIImage+GIF.h"

@implementation UIImage (ACGif)

+ (UIImage *)ac_setGifWithName: (NSString *)name {
    return [self sd_animatedGIFNamed:name];
}

+ (UIImage *)ac_setGifWithData: (NSData *)data {
    return [self sd_animatedGIFWithData:data];
}

+ (UIImage *)imageForResourcePath:(NSString *)path ofType:(NSString *)type inBundle:(NSBundle *)bundle {
    return [UIImage imageWithContentsOfFile:[bundle pathForResource:path ofType:type]];
}

@end
