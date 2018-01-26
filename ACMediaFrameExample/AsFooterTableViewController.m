//
//  AsFooterTableViewController.m
//  ACMediaFrameExample
//
//  Created by caoyq on 2018/1/26.
//  Copyright © 2018年 ArthurCao. All rights reserved.
//

#import "AsFooterTableViewController.h"
#import "ACMediaFrame.h"
#import "UIView+ACMediaExt.h"

@interface AsFooterTableViewController ()
{
    CGFloat _mediaH;
    ACSelectMediaView *_mediaView;
}

@end

@implementation AsFooterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"我是%ld栋 %ld楼",indexPath.section,indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section == 1 ? MAX(_mediaH, 0.1) : 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0 || section == 2) {
        return nil;
    }
    if (!_mediaView) {
        ACSelectMediaView *mediaView = [[ACSelectMediaView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 1)];
        mediaView.type = ACMediaTypeAll;
        mediaView.maxImageSelected = 12;
        mediaView.naviBarBgColor = [UIColor redColor];
        mediaView.rowImageCount = 3;
        mediaView.lineSpacing = 20;
        mediaView.interitemSpacing = 20;
        mediaView.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
        [mediaView observeViewHeight:^(CGFloat mediaHeight) {
            _mediaH = mediaHeight;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        }];
        _mediaView = mediaView;
    }

    return _mediaView;
}

@end
