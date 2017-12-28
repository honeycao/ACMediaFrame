//
//  UIImage+ACGif.m
//
//  Version: 2.0.4.
//  Created by ArthurCao<https://github.com/honeycao> on 2017/4/26.
//  Update: 2017/12/27.
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
