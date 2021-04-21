//
//  ACMediaDisplayConfig.m
//
//  Created by caoyq on 2021/4/20.
//  Copyright © 2021 ArthurCao. All rights reserved.
//

#import "ACMediaDisplayConfig.h"

@implementation ACMediaDisplayConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.rowImageCount = 4;
        self.lineSpacing = 10.0;
        self.interitemSpacing = 10.0;
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        
        self.deleteImage = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"ACMediaFrame.bundle/deleteButton" ofType:@"png"]];
        self.addImage = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"ACMediaFrame.bundle/AddMedia" ofType:@"png"]];
        self.videoTagImage = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"ACMediaFrame.bundle/ShowVideo" ofType:@"png"]];
    }
    return self;
}

@end
