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
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    
    ACSelectMediaView *mediaView = [[ACSelectMediaView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 1)];
    mediaView.type = ACMediaTypePhoto;
    mediaView.maxImageSelected = 6;
//    mediaView.allowMultipleSelection = NO;
    mediaView.naviBarBgColor = [UIColor redColor];
    mediaView.rowImageCount = 3;
    mediaView.lineSpacing = 20;
    mediaView.interitemSpacing = 20;
    mediaView.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    [mediaView reload];
    self.tableView.tableHeaderView = mediaView;
}

@end
