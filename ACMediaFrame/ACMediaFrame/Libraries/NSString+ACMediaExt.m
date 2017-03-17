//
//  NSString+ACMediaExt.m
//  ACMediaFrame
//
//  Created by caoyq on 2017/3/16.
//  Copyright © 2017年 ArthurCao. All rights reserved.
//

#import "NSString+ACMediaExt.h"

@implementation NSString (ACMediaExt)

- (BOOL)isValidUrl {
    NSString *regex =@"[a-zA-z]+://[^\\s]*";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlTest evaluateWithObject:self];
}

@end
