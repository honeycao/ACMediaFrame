//
//  UIImageView+ACMediaExt.m
//
//  Version: 2.0.4.
//  Created by ArthurCao<https://github.com/honeycao> on 2017/3/27.
//  Update: 2017/12/27.
//

#import "UIImageView+ACMediaExt.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (ACMediaExt)

- (void)ac_setImageWithUrlString: (NSString *)urlString placeholderImage: (UIImage *)placeholderImage {
    [self sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:placeholderImage];
}

@end
