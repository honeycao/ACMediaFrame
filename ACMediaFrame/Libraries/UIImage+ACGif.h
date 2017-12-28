//
//  UIImage+ACGif.h
//
//  Version: 2.0.4.
//  Created by ArthurCao<https://github.com/honeycao> on 2017/4/26.
//  Update: 2017/12/27.
//

#import <UIKit/UIKit.h>

@interface UIImage (ACGif)

/** 根据gif的name 设置image */
+ (UIImage *)ac_setGifWithName: (NSString *)name;

/** 根据gif的data 设置image */
+ (UIImage *)ac_setGifWithData: (NSData *)data;

/**
 给 UIImage 设置bundle图片
 */
+ (UIImage *)imageForResourcePath:(NSString *)path ofType:(NSString *)type inBundle:(NSBundle *)bundle;

@end
