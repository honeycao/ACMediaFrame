//
//  DisplayTableViewController.m
//  ACMediaFrameExample
//
//  Created by caoyq on 2017/3/26.
//  Copyright © 2017年 ArthurCao. All rights reserved.
//

#import "DisplayTableViewController.h"
#import "ACMediaFrame.h"

@interface DisplayTableViewController ()

@end

@implementation DisplayTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    
    CGFloat height = [ACSelectMediaView defaultViewHeight];
    ACSelectMediaView *mediaView = [[ACSelectMediaView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, height)];
    mediaView.showDelete = NO;
    mediaView.showAddButton = NO;
    mediaView.preShowMedias = @[@"bg_1", @"bg_2", @"bg_3"];
    self.tableView.tableHeaderView = mediaView;

}

@end
