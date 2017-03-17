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

@end
