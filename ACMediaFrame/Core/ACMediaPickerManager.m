//
//  ACMediaPickerManager.m
//
//  Created by caoyq on 2018/11/9.
//  Copyright © 2018 AllenCao. All rights reserved.
//

#import "ACMediaPickerManager.h"
#import "TZImagePickerController.h"
#import "ACMediaTool.h"

static NSString *const str_openAlbum  = @"打开本地相册";
static NSString *const str_openCamera = @"打开相机";
static NSString *const str_cancel     = @"取消";
static NSString *const str_openCamera_error = @"设备不能打开相机";

@interface ACMediaPickerManager()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, TZImagePickerControllerDelegate>

@end

@implementation ACMediaPickerManager

#pragma mark - init

- (instancetype)init {
    self = [super init];
    if (self) {
        self.currentViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        self.statusBarStyle = UIStatusBarStyleLightContent;
        self.maxImageSelected = 9;
        self.videoMaximumDuration = 60.0;
        self.allowPickingImage = YES;
        self.currentViewController = [ACMediaTool topNavigationController];
    }
    return self;
}

#pragma mark - public

- (void)picker {
    switch (self.pickerSource) {
        case ACMediaPickerSourceFromAlbum:
            [self openCustomAlbum];
            break;
        case ACMediaPickerSourceFromCamera:
            [self openSystemCamera];
            break;
        default:
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *album = [UIAlertAction actionWithTitle:str_openAlbum style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self openCustomAlbum];
            }];
            UIAlertAction *camera = [UIAlertAction actionWithTitle:str_openCamera style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self openSystemCamera];
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:str_cancel style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:album];
            [alert addAction:camera];
            [alert addAction:cancel];
            [self.currentViewController presentViewController:alert animated:YES completion:nil];
        }
            break;
    }
}

- (void)openCustomAlbum {
    //组装所有已选的asset
    NSMutableArray *seletedAssets = [NSMutableArray array];
    for (ACMediaModel *model in self.seletedMediaArray) {
        if (model.asset) {
            [seletedAssets addObject:model.asset];
        }
    }
    
    TZImagePickerController *imagePickController = [[TZImagePickerController alloc] initWithMaxImagesCount:self.maxImageSelected delegate:self];
    imagePickController.selectedAssets = seletedAssets;
    [self configureTZImagePicker:imagePickController];
    [self.currentViewController presentViewController:imagePickController animated:YES completion:nil];
}

- (void)openSystemCamera {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if ([UIImagePickerController isSourceTypeAvailable: sourceType]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = sourceType;
        [self configureCameraPicker:picker];
        [self.currentViewController presentViewController:picker animated:YES completion:nil];
    }else{
        NSLog(str_openCamera_error);
    }
}

- (void)openSystemAlbum {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self.currentViewController presentViewController:picker animated:YES completion:nil];
    }
}

#pragma mark - private

- (void)configureCameraPicker: (UIImagePickerController *)picker {
    if (self.allowTakeVideo && !self.allowTakePicture) { //录像
        NSArray * mediaTypes =[UIImagePickerController  availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        picker.mediaTypes = mediaTypes;
        picker.videoMaximumDuration = self.videoMaximumDuration;
        picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    }else { //拍照
        picker.allowsEditing = YES;
    }
}

- (void)configureTZImagePicker: (TZImagePickerController *)imagePicker {
    imagePicker.allowPickingImage = self.allowPickingImage;
    imagePicker.allowPickingVideo = self.allowPickingVideo;
    imagePicker.allowPickingGif = self.allowPickingGif;
    
    imagePicker.allowTakePicture = self.allowTakePicture;
    imagePicker.allowTakeVideo = self.allowTakeVideo;
    imagePicker.allowPickingOriginalPhoto = self.allowPickingOriginalPhoto;
    imagePicker.allowPickingMultipleVideo = self.allowPickingMultipleVideo;
    imagePicker.videoMaximumDuration = self.videoMaximumDuration;
    
    //外观
    if (self.naviBgColor) imagePicker.naviBgColor = self.naviBgColor;
    if (self.naviTitleColor) imagePicker.naviTitleColor = self.naviTitleColor;
    if (self.naviTitleFont) imagePicker.naviTitleFont = self.naviTitleFont;
    if (self.barItemTextColor) imagePicker.barItemTextColor = self.barItemTextColor;
    if (self.barItemTextFont) imagePicker.barItemTextFont = self.barItemTextFont;
    imagePicker.statusBarStyle = self.statusBarStyle;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    ACMediaModel *model = [ACMediaTool mediaInfoWithDict:info];
    if (self.didFinishPickingBlock) {
        self.didFinishPickingBlock(@[model]);
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TZImagePickerControllerDelegate

// 单个/多个图片、多个gif、多个视频、三者混合选取的回调
- (void)imagePickerController:(TZImagePickerController *)picker
       didFinishPickingPhotos:(NSArray<UIImage *> *)photos
                 sourceAssets:(NSArray *)assets
        isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    NSMutableArray *list = [NSMutableArray array];
    for (NSInteger idx = 0; idx < photos.count; idx++) {
        ACMediaModel *model = [ACMediaTool imageInfoWithAsset:assets[idx] image:photos[idx]];
        [list addObject:model];
    }
    if (self.didFinishPickingBlock) {
        self.didFinishPickingBlock(list);
    }
}

// 单个视频选取回调
- (void)imagePickerController:(TZImagePickerController *)picker
        didFinishPickingVideo:(UIImage *)coverImage
                 sourceAssets:(id)asset {
    [ACMediaTool videoInfoWithAsset:asset coverImage:coverImage completion:^(ACMediaModel * _Nonnull model) {
        if (self.didFinishPickingBlock) {
            self.didFinishPickingBlock(@[model]);
        }
    }];
}

// 单个gif选取回调
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(PHAsset *)asset {
    ACMediaModel *model = [ACMediaTool imageInfoWithAsset:asset image:animatedImage];
    if (self.didFinishPickingBlock) {
        self.didFinishPickingBlock(@[model]);
    }
}

@end
