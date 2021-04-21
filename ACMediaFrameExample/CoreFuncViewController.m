//
//  CoreFuncViewController.m
//  ACMediaFrameExample
//
//  Created by caoyq on 2021/4/20.
//  Copyright © 2021 ArthurCao. All rights reserved.
//

#import "CoreFuncViewController.h"
#import "ACMediaPickerManager.h"

@interface CoreFuncViewController ()

///需要先定义一个属性，防止临时变量被释放
@property (nonatomic, strong) ACMediaPickerManager *mgr;

@property (weak, nonatomic) IBOutlet UIImageView *displayImageView;

@end

@implementation CoreFuncViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // add observer
    __weak typeof(self) weakSelf = self;
    self.mgr.didFinishPickingBlock = ^(NSArray<ACMediaModel *> * _Nonnull list) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.displayImageView.image = list.firstObject.image;
        });
    };
}

- (IBAction)onClickCoreButtonAction:(UIButton *)sender {
    [self.mgr picker];
}

- (ACMediaPickerManager *)mgr {
    if (!_mgr) {
        _mgr = [[ACMediaPickerManager alloc] init];
        // 定制外观
        _mgr.naviBgColor = [UIColor whiteColor];
        _mgr.naviTitleColor = [UIColor blackColor];
        _mgr.naviTitleFont = [UIFont boldSystemFontOfSize:18.0f];
        _mgr.barItemTextColor = [UIColor blackColor];
        _mgr.barItemTextFont = [UIFont systemFontOfSize:15.0f];
        _mgr.statusBarStyle = UIStatusBarStyleDefault;
        
        _mgr.allowPickingImage = YES;
        _mgr.allowPickingGif = YES;
        _mgr.maxImageSelected = 1;
    }
    return _mgr;
}

@end
