//
//  AddTableViewController.m
//  ACMediaFrameExample
//
//  Created by caoyq on 2017/3/26.
//  Copyright © 2017年 ArthurCao. All rights reserved.
//

#import "AddTableViewController.h"
#import "ACMediaFrame.h"
#import "UIView+ACMediaExt.h"

@interface AddTableViewController ()

@end

@implementation AddTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor lightGrayColor];
    
    UIView *descView = [[UIView alloc] init];
    descView.backgroundColor = [UIColor yellowColor];
    [bgView addSubview:descView];
    
    ACSelectMediaView *mediaView = [[ACSelectMediaView alloc] initWithFrame:CGRectMake(0, 150, [[UIScreen mainScreen] bounds].size.width, 1)];
    mediaView.type = ACMediaTypePhoto;
    mediaView.maxImageSelected = 6;
    mediaView.naviBarBgColor = [UIColor redColor];
    mediaView.rowImageCount = 3;
    mediaView.lineSpacing = 20;
    mediaView.interitemSpacing = 20;
    mediaView.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    [mediaView observeViewHeight:^(CGFloat mediaHeight) {
        descView.frame = CGRectMake(0, CGRectGetMaxY(mediaView.frame) + 20, CGRectGetWidth(mediaView.frame), 200);
        bgView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, CGRectGetMaxY(descView.frame) + 40);
        //注意：在里面更新，避免滚动不到底
        self.tableView.tableFooterView = bgView;
    }];
    // observeViewHeight 存在时可以不写
//    [mediaView reload];
    [bgView addSubview:mediaView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

@end
