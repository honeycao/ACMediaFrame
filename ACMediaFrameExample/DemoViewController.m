//
//  DemoViewController.m
//  ACMediaFrameExample
//
//  Created by caoyq on 2018/12/11.
//  Copyright © 2018 ArthurCao. All rights reserved.
//

#import "DemoViewController.h"
#import "ACMediaPickerManager.h"

@interface DemoViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
///记录已选中的媒体资源
@property (nonatomic, strong) NSArray *selectedArray;
///需要先定义一个属性，防止临时变量被释放
@property (nonatomic, strong) ACMediaPickerManager *mgr;

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

- (IBAction)didClickButtonAction:(id)sender {
    
    self.mgr = [[ACMediaPickerManager alloc] init];
    //外观
    self.mgr.naviBgColor = [UIColor whiteColor];
    self.mgr.naviTitleColor = [UIColor blackColor];
    self.mgr.naviTitleFont = [UIFont boldSystemFontOfSize:18.0f];
    self.mgr.barItemTextColor = [UIColor blackColor];
    self.mgr.barItemTextFont = [UIFont systemFontOfSize:15.0f];
    self.mgr.statusBarStyle = UIStatusBarStyleDefault;
    
    self.mgr.allowPickingImage = YES;
    self.mgr.allowPickingGif = YES;
    self.mgr.maxImageSelected = 2;
    if (self.selectedArray.count > 0) {
        self.mgr.seletedMediaArray = self.selectedArray;
    }
    __weak typeof(self) weakSelf = self;
    self.mgr.didFinishPickingBlock = ^(NSArray<ACMediaModel *> * _Nonnull list) {
        weakSelf.selectedArray = list;
        ACMediaModel *model = list.firstObject;
        weakSelf.imageView.image = model.image;
    };
    [self.mgr picker];
    
    //使用系统相册功能
    //    [self.mgr openSystemAlbum];
}

@end
