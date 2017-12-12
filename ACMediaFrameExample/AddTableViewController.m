//
//  AddTableViewController.m
//  ACMediaFrameExample
//
//  Created by caoyq on 2017/3/26.
//  Copyright © 2017年 ArthurCao. All rights reserved.
//

#import "AddTableViewController.h"
#import "ACMediaFrame.h"
#import "UIImage+ACGif.h"

@interface AddTableViewController ()

@end

@implementation AddTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    
    CGFloat height = [ACSelectMediaView defaultViewHeight];
    ACSelectMediaView *mediaView = [[ACSelectMediaView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, height)];
    mediaView.type = ACMediaTypePhoto;
    mediaView.maxImageSelected = 4;
    mediaView.allowMultipleSelection = NO;
    mediaView.naviBarBgColor = [UIColor redColor];
    self.tableView.tableHeaderView = mediaView;
}

@end
