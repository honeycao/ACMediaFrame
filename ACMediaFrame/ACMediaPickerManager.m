//
//  ACMediaPickerManager.m
//
//  Created by caoyq on 2018/11/9.
//  Copyright © 2018 AllenCao. All rights reserved.
//

#import "ACMediaPickerManager.h"
#import "TZImagePickerController.h"

static NSString *const str_openAlbum  = @"打开本地相册";
static NSString *const str_openCamera = @"打开相机";
static NSString *const str_cancel     = @"取消";
static NSString *const str_openCamera_error = @"设备不能打开相机";

@interface ACMediaPickerManager()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, TZImagePickerControllerDelegate>

/** 当前的控制器 */
@property (nonatomic, strong) UIViewController *currentViewController;

@end

@implementation ACMediaPickerManager

#pragma mark - init

+ (instancetype)manager
{
    static ACMediaPickerManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.currentViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    return self;
}

#pragma mark - public

- (void)picker
{
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

- (void)openCustomAlbum
{
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

- (void)openSystemCamera
{
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

- (void)openSystemAlbum
{
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

- (void)configureCameraPicker: (UIImagePickerController *)picker
{
    if (self.cameraType == ACMediaCameraTypePhoto) {
        picker.allowsEditing = YES;
    }else {
        NSArray * mediaTypes =[UIImagePickerController  availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        picker.mediaTypes = mediaTypes;
        picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    }
}

- (void)configureTZImagePicker: (TZImagePickerController *)imagePicker
{
    imagePicker.allowTakePicture = NO;
    imagePicker.allowTakeVideo = NO;
    imagePicker.allowPickingOriginalPhoto = self.allowPickingOriginalPhoto;
    
    BOOL pickingImage = YES;
    BOOL pickingVideo = YES;
    switch (self.albumType) {
        case ACMediaAlbumTypePhoto:
            pickingVideo = NO;
            break;
        case ACMediaAlbumTypeVideo:
            pickingImage = NO;
            break;
        default:
            break;
    }
    imagePicker.allowPickingImage = pickingImage;
    imagePicker.allowPickingVideo = pickingVideo;
    // gif as image.
    imagePicker.allowPickingGif = pickingImage;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    ACMediaModel *model = [ACMediaModel mediaInfoWithDict:info];
    if (self.didFinishPickingBlock) {
        self.didFinishPickingBlock(@[model]);
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TZImagePickerControllerDelegate

- (void)imagePickerController:(TZImagePickerController *)picker
       didFinishPickingPhotos:(NSArray<UIImage *> *)photos
                 sourceAssets:(NSArray *)assets
        isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
{
    NSMutableArray *list = [NSMutableArray array];
    for (NSInteger idx = 0; idx < photos.count; idx++) {
        ACMediaModel *model = [ACMediaModel imageInfoWithAsset:assets[idx] image:photos[idx]];
        [list addObject:model];
    }
    if (self.didFinishPickingBlock) {
        self.didFinishPickingBlock(list);
    }
}

- (void)imagePickerController:(TZImagePickerController *)picker
        didFinishPickingVideo:(UIImage *)coverImage
                 sourceAssets:(id)asset
{
    [ACMediaModel videoInfoWithAsset:asset coverImage:coverImage completion:^(ACMediaModel * _Nonnull model) {
        if (self.didFinishPickingBlock) {
            self.didFinishPickingBlock(@[model]);
        }
    }];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(PHAsset *)asset
{
    ACMediaModel *model = [ACMediaModel imageInfoWithAsset:asset image:animatedImage];
    if (self.didFinishPickingBlock) {
        self.didFinishPickingBlock(@[model]);
    }
}

@end
