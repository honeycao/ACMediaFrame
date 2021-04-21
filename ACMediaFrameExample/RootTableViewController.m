//
//  RootTableViewController.m
//  ACMediaFrameExample
//
//  Created by caoyq on 2021/4/20.
//  Copyright © 2021 ArthurCao. All rights reserved.
//

#import "RootTableViewController.h"

@interface RootTableViewController ()
 
@property (nonatomic, strong) NSArray *vcs;
@property (nonatomic, strong) NSArray *titles;

@end

@implementation RootTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"功能列表";
    
    self.vcs = @[@"CoreFuncViewController", @"UIFrameViewController"];
    self.titles = @[@"核心功能演示", @"九宫格UI-frame演示"];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *vcName = self.vcs[indexPath.row];
    Class cls = NSClassFromString(vcName);
    UIViewController *vc = [[cls alloc] init];
    vc.title = self.titles[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
