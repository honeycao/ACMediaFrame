//
//  NSString+ACMediaExt.h
//  ACMediaFrame
//
//  Created by caoyq on 2017/3/16.
//  Copyright © 2017年 ArthurCao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ACMediaExt)

/**
 判断该字符串是不是一个有效的URL

 @return YES：是一个有效的URL or NO
 */
- (BOOL)isValidUrl;

/** 根据图片名 判断是否是gif图 */
- (BOOL)isGifImage;

/** 根据图片data 判断是否是gif图 */
+ (BOOL)isGifWithImageData: (NSData *)data;

/**
 根据image的data 判断图片类型

 @param data 图片data
 @return 图片类型(png、jpg...)
 */
+ (NSString *)contentTypeWithImageData: (NSData *)data;

@end
