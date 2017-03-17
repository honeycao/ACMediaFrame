//
//  ACSelectMediaView.m
//
//  Created by caoyq on 16/12/22.
//  Copyright © 2016年 ArthurCao. All rights reserved.
//

#import "ACSelectMediaView.h"
#import "ACMediaImageCell.h"
#import "ACShowMediaTypeView.h"
#import "ACMediaManager.h"
#import "TZImagePickerController.h"
#import "MWPhotoBrowser.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ACSelectMediaView ()<UICollectionViewDelegate, UICollectionViewDataSource, TZImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MWPhotoBrowserDelegate>
{
    UIViewController *rootVC;
}

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, copy) ACMediaHeightBlock block;
@property (nonatomic, copy) ACSelectMediaBackBlock backBlock;

/** MWPhoto对象数组 */
@property (nonatomic, strong) NSMutableArray *photos;

@end

@implementation ACSelectMediaView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _mediaArray = [NSMutableArray array];
        _type = ACMediaTypeAll;
        _showDelete = YES;
        _showAddButton = YES;
        _backgroundColor = [UIColor whiteColor];
        rootVC = [[UIApplication sharedApplication] keyWindow].rootViewController;
        [self configureCollectionView];
    }
    return self;
}

- (void)configureCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(self.width/4, self.width/4);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
    [_collectionView registerClass:[ACMediaImageCell class] forCellWithReuseIdentifier:NSStringFromClass([ACMediaImageCell class])];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = _backgroundColor;
    [self addSubview:_collectionView];
}

#pragma mark - setter

- (void)setShowDelete:(BOOL)showDelete {
    _showDelete = showDelete;
}

- (void)setShowAddButton:(BOOL)showAddButton {
    _showAddButton = showAddButton;
}

- (void)setMediaArray:(NSMutableArray *)mediaArray {
    
    for (id object in mediaArray) {
        ACMediaModel *model = [ACMediaModel new];
        if ([object isKindOfClass:[UIImage class]]) {
            model.image = object;
        }else if ([object isKindOfClass:[NSString class]]) {
            if ([(NSString *)object containsString:@"http://"] || [(NSString *)object containsString:@"https://"]) {
                model.imageUrlString = object;
            }else {
                model.image = [UIImage imageNamed:object];
            }
        }else if ([object isKindOfClass:[ACMediaModel class]]) {
            model = object;
        }
        [_mediaArray addObject:model];
        [self.collectionView reloadData];
    }
}

- (void)setAllowPickingVideo:(BOOL)allowPickingVideo {
    _allowPickingVideo = allowPickingVideo;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    [_collectionView setBackgroundColor:backgroundColor];
}

#pragma mark - public method

- (void)observeViewHeight:(ACMediaHeightBlock)value {
    _block = value;
}

- (void)observeSelectedMediaArray: (ACSelectMediaBackBlock)backBlock {
    _backBlock = backBlock;
}

+ (CGFloat)defaultViewHeight {
    return ACMedia_ScreenWidth/4;
}

#pragma mark -  Collection View DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _mediaArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ACMediaImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ACMediaImageCell class]) forIndexPath:indexPath];
    if (indexPath.row == _mediaArray.count) {
        cell.icon.image = [UIImage imageNamed:@"ACMediaFrame.bundle/AddMedia"];
        cell.videoImageView.hidden = YES;
        cell.deleteButton.hidden = YES;
    }else{
        ACMediaModel *model = [[ACMediaModel alloc] init];
        model = _mediaArray[indexPath.row];
        if (!model.isVideo && model.imageUrlString) {
        [cell.icon sd_setImageWithURL:[NSURL URLWithString:model.imageUrlString]];
        }else {
            cell.icon.image = model.image;
        }
        
        cell.icon.image = model.image;
        cell.videoImageView.hidden = !model.isVideo;
        cell.deleteButton.hidden = !_showDelete;
        [cell setACMediaClickDeleteButton:^{
            [_mediaArray removeObjectAtIndex:indexPath.row];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self layoutCollection:@[]];
            });
        }];
    }
    return cell;
}

#pragma mark - collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _mediaArray.count && _mediaArray.count >= 9) {
        [UIAlertController showAlertWithTitle:@"最多只能选择9张" message:nil actionTitles:@[@"确定"] cancelTitle:nil style:UIAlertControllerStyleAlert completion:nil];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    //点击的是添加媒体的按钮
    if (indexPath.row == _mediaArray.count) {
        switch (_type) {
            case ACMediaTypePhoto:
                [self openAlbum];
                break;
            case ACMediaTypePhotoAndCamera:
            {
                [UIAlertController showAlertWithTitle:@"选择图片来源" message:nil actionTitles:@[@"相册", @"相机"] cancelTitle:@"取消" style:UIAlertControllerStyleActionSheet completion:^(NSInteger index) {
                    if (index == 0) {
                        [weakSelf openAlbum];
                    }else {
                        [weakSelf openCamera];
                    }
                }];
            }
                break;
            default:
            {
                ACShowMediaTypeView *fileView = [[ACShowMediaTypeView alloc] init];
                [fileView show];
                [fileView selectedIndexBlock:^(NSInteger itemIndex) {
                    if (itemIndex == 0) {
                        [weakSelf openAlbum];
                    }else if (itemIndex == 1) {
                        [weakSelf openCamera];
                    }else if (itemIndex == 2) {
                        [weakSelf openVideotape];
                    }else {
                        [weakSelf openVideo];
                    }
                }];
            }
                break;
        }
    }
    //展示媒体
    else {
        _photos = [NSMutableArray array];
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        browser.displayActionButton = NO;
        browser.alwaysShowControls = NO;
        browser.displaySelectionButtons = NO;
        browser.zoomPhotosToFill = YES;
        browser.displayNavArrows = NO;
        browser.startOnGrid = NO;
        browser.enableGrid = YES;
        for (ACMediaModel *model in _mediaArray) {
            MWPhoto *photo = [MWPhoto photoWithImage:model.image];
            photo.caption = model.name;
            if (model.isVideo) {
                if (model.mediaURL) {
                    photo.videoURL = model.mediaURL;
                }else {
                    photo = [photo initWithAsset:model.asset targetSize:CGSizeZero];
                }
            }
            [_photos addObject:photo];
        }
        [browser setCurrentPhotoIndex:indexPath.row];
        [[self viewController].navigationController pushViewController:browser animated:YES];
    }
}

#pragma mark - <MWPhotoBrowserDelegate>

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photos.count) {
        return [self.photos objectAtIndex:index];
    }
    return nil;
}

#pragma mark - 布局

///添加选中的image，然后重新布局collectionview
- (void)layoutCollection: (NSArray *)images {
    [_mediaArray addObjectsFromArray:images];
    NSInteger allImageCount = _mediaArray.count + 1;
    NSInteger maxRow = (allImageCount - 1) / 4 + 1;
    _collectionView.height = maxRow * ACMedia_ScreenWidth/4;
    self.height = _collectionView.height;
    //block回调
    !_block ?  : _block(_collectionView.height);
    !_backBlock ?  : _backBlock(_mediaArray);
    
    [_collectionView reloadData];
}

#pragma mark - actions

/** 相册 */
- (void)openAlbum {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 - _mediaArray.count delegate:self];
    //是否 在相册中显示拍照按钮
    imagePickerVc.allowTakePicture = NO;
    //是否可以选择显示原图
    imagePickerVc.allowPickingOriginalPhoto = NO;
    //是否 在相册中可以选择视频
    imagePickerVc.allowPickingVideo = _allowPickingVideo;
    [rootVC presentViewController:imagePickerVc animated:YES completion:nil];
}

/** 相机 */
- (void)openCamera {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;

    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [rootVC presentViewController:picker animated:YES completion:nil];
    }else{
        [UIAlertController showAlertWithTitle:@"该设备不支持拍照" message:nil actionTitles:@[@"确定"] cancelTitle:nil style:UIAlertControllerStyleAlert completion:nil];
    }
}

/** 录像 */
- (void)openVideotape {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSArray * mediaTypes =[UIImagePickerController  availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes = mediaTypes;
        picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
        picker.videoQuality = UIImagePickerControllerQualityTypeMedium; //录像质量
        picker.videoMaximumDuration = 600.0f; //录像最长时间
    } else {
        [UIAlertController showAlertWithTitle:@"当前设备不支持录像" message:nil actionTitles:@[@"确定"] cancelTitle:nil style:UIAlertControllerStyleAlert completion:nil];
    }
    [rootVC presentViewController:picker animated:YES completion:nil];

}

/** 视频 */
- (void)openVideo {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
    picker.allowsEditing = YES;
    UIViewController *vc = [[UIApplication sharedApplication] keyWindow].rootViewController;
    [vc presentViewController:picker animated:YES completion:nil];
}

#pragma mark - TZImagePickerController Delegate

//处理从相册单选或多选的照片
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    NSMutableArray *models = [NSMutableArray array];
    for (NSInteger index = 0; index < assets.count; index++) {
        PHAsset *asset = assets[index];
        [ACMediaManager getMediaInfoFromAsset:asset completion:^(NSString *name, id pathData) {
            ACMediaModel *model = [[ACMediaModel alloc] init];
            model.name = name;
            model.uploadType = pathData;
            model.image = photos[index];
            [models addObject:model];
            if (index == assets.count - 1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self layoutCollection:models];
                });
            }
        }];
    }
}

///选取视频后的回调
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    [ACMediaManager getMediaInfoFromAsset:asset completion:^(NSString *name, id pathData) {
        ACMediaModel *model = [[ACMediaModel alloc] init];
        model.name = name;
        model.uploadType = pathData;
        model.image = coverImage;
        model.isVideo = YES;
        model.asset = asset;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self layoutCollection:@[model]];
        });
    }];
}

#pragma mark - UIImagePickerController Delegate
///拍照、选视频图片、录像 后的回调（这种方式选择视频时，会自动压缩，但是很耗时间）
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];

    //媒体类型
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    //原图URL
    NSURL *imageAssetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    
    ///视频 和 录像
    if ([mediaType isEqualToString:@"public.movie"]) {
        
        NSURL *videoAssetURL = [info objectForKey:UIImagePickerControllerMediaURL];
        PHAsset *asset;
        //录像没有原图 所以 imageAssetURL 为nil
        if (imageAssetURL) {
            PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[imageAssetURL] options:nil];
            asset = [result firstObject];
        }
        [ACMediaManager getVideoPathFromURL:videoAssetURL PHAsset:asset enableSave:NO completion:^(NSString *name, UIImage *screenshot, id pathData) {
            ACMediaModel *model = [[ACMediaModel alloc] init];
            model.image = screenshot;
            model.name = name;
            model.uploadType = pathData;
            model.isVideo = YES;
            model.mediaURL = videoAssetURL;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self layoutCollection:@[model]];
            });
        }];
    }
    
    else if ([mediaType isEqualToString:@"public.image"]) {
        
        UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
        //如果 picker 没有设置可编辑，那么image 为 nil
        if (image == nil) {
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        
        PHAsset *asset;
        //拍照没有原图 所以 imageAssetURL 为nil
        if (imageAssetURL) {
            PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[imageAssetURL] options:nil];
            asset = [result firstObject];
        }
        [ACMediaManager getImageInfoFromImage:image PHAsset:asset completion:^(NSString *name, NSData *data) {
            ACMediaModel *model = [[ACMediaModel alloc] init];
            model.image = image;
            model.name = name;
            model.uploadType = data;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self layoutCollection:@[model]];
            });
        }];
    }
}

@end
