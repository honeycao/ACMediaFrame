//
//  MainViewController.m
//  ACMediaFrame
//
//  Created by caoyq on 16/12/24.
//  Copyright © 2016年 ArthurCao. All rights reserved.
//

#import "MainViewController.h"
#import "ACMediaFrame.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ACMediaFrame";
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0x3d/255.0 green:0x52/255.0 blue:0xb4/255.0 alpha:1];
    self.view.backgroundColor = [UIColor colorWithRed:0xf2/255.0 green:0xf4/255.0 blue:0xf9/255.0 alpha:1];
    [self _setupViews];
}

- (void)_setupViews {
    //1、得到默认布局高度（唯一获取高度方法）
    CGFloat height = [ACSelectMediaView defaultViewHeight];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, height)];
    
    //2、初始化
    ACSelectMediaView *mediaView = [[ACSelectMediaView alloc] initWithFrame:CGRectMake(0, 0, bgView.frame.size.width, bgView.frame.size.height)];
    
    //3、选择媒体类型：ACMediaType
    mediaView.type = ACMediaTypeAll;
    
    mediaView.allowPickingVideo = YES;
    
    //4、是否有需要提前显示的图片等媒体资源（以下是3种初始化的方式）
    NSArray *ary = @[[UIImage imageNamed:@"poem"], [UIImage imageNamed:@"poem"], [UIImage imageNamed:@"poem"], [UIImage imageNamed:@"poem"]];
    
    //NSArray *ary = @[@"poem"];
    
    //ACMediaModel *model = [ACMediaModel new];
    //model.image = [UIImage imageNamed:@"poem"];
    //NSArray *ary = @[model];
    
    mediaView.mediaArray = (NSMutableArray *)ary;
    
    //是否需要显示图片上的删除按钮
    //mediaView.showDelete = NO;
    //是否显示添加图片按钮
//    mediaView.showAddButton = NO;
    
    //图片最大选择张数
//    mediaView.maxImageSelected = 5;
    
    //5、随时获取新的布局高度
    [mediaView observeViewHeight:^(CGFloat value) {
        bgView.height = value;
    }];
    
    //6、随时获取已经选择的媒体文件
    [mediaView observeSelectedMediaArray:^(NSArray<ACMediaModel *> *list) {
        for (ACMediaModel *model in list) {
            NSLog(@"%@",model);
        }
    }];
    
    [bgView addSubview:mediaView];
    [self.view addSubview:bgView];
}

@end
