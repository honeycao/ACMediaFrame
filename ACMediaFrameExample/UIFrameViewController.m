//
//  UIFrameViewController.m
//  ACMediaFrameExample
//
//  Created by caoyq on 2021/4/20.
//  Copyright © 2021 ArthurCao. All rights reserved.
//

#import "UIFrameViewController.h"
//
#import "ACMediaDisplayView.h"

@interface UIFrameViewController ()

@end

@implementation UIFrameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *bgView = [UIView new];
    bgView.frame = CGRectMake(10, 100, CGRectGetWidth(self.view.frame) - 20, 0);
    bgView.backgroundColor = [UIColor greenColor];
    bgView.layer.cornerRadius = 5.0;
    bgView.layer.masksToBounds = YES;
    [self.view addSubview:bgView];
    
    ACMediaDisplayConfig *config = [[ACMediaDisplayConfig alloc] init];
    config.containerBgColor = [UIColor lightGrayColor];
    
    ACMediaDisplayView *displayView = [[ACMediaDisplayView alloc] initWithFrame:bgView.bounds config:config];
    displayView.observeContainerHeightChangeBlock = ^(CGFloat viewHeight) {
        NSLog(@"高度变化 = %f",viewHeight);
        // 改变外部视图高度
        CGRect fm = bgView.frame;
        fm.size.height = viewHeight;
        bgView.frame = fm;
    };
    [bgView addSubview:displayView];
    
    // 设置正确的 frame
    CGRect bgRect = bgView.frame;
    bgRect.size.height = displayView.viewHeight;
    bgView.frame = bgRect;
    displayView.frame = bgView.bounds;
}

@end
