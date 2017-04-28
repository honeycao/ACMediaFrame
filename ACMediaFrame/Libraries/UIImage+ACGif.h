//
//  UIImage+ACGif.h
//  ACMediaFrameExample
//
//  Created by caoyq on 2017/4/26.
//  Copyright © 2017年 ArthurCao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ACGif)

/** 根据gif的name 设置image */
+ (UIImage *)ac_setGifWithName: (NSString *)name;

/** 根据gif的data 设置image */
+ (UIImage *)ac_setGifWithData: (NSData *)data;

@end
