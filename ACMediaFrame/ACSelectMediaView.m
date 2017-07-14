//
//  ACSelectMediaView.m
//
//  Created by caoyq on 17/04/12.
//  Copyright © 2016年 ArthurCao. All rights reserved.
//

#import "ACSelectMediaView.h"
#import "ACMediaImageCell.h"
#import "ACMediaFrameConst.h"
#import "ACMediaManager.h"
#import "ACAlertController.h"
#import "TZImagePickerController.h"
#import "MWPhotoBrowser.h"

@interface ACSelectMediaView ()<UICollectionViewDelegate, UICollectionViewDataSource, TZImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MWPhotoBrowserDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, copy) ACMediaHeightBlock block;

@property (nonatomic, copy) ACSelectMediaBackBlock backBlock;

/** 总的媒体数组 */
@property (nonatomic, strong) NSMutableArray *mediaArray;

/** 记录从相册中已选的Image Asset */
@property (nonatomic, strong) NSMutableArray *selectedImageAssets;

/** 字典存储从相册中已选的 Asset 以及对应显示的下标: key为asset, value为下标 */
@property (nonatomic, strong) NSMutableDictionary *selectedAssetsDic;

/** MWPhoto对象数组 */
@property (nonatomic, strong) NSMutableArray *photos;

@end

@implementation ACSelectMediaView

#pragma mark - Init

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.frame = CGRectMake(self.x, self.y, self.width, ACMedia_ScreenWidth/4);
        [self _setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _setup];
    }
    return self;
}

- (void)_setup {
    _mediaArray = [NSMutableArray array];
    _preShowMedias = [NSMutableArray array];
    _selectedImageAssets = [NSMutableArray array];
    self.selectedAssetsDic = [NSMutableDictionary dictionary];
    _type = ACMediaTypePhotoAndCamera;
    _showDelete = YES;
    _showAddButton = YES;
    _allowMultipleSelection = YES;
    _maxImageSelected = 9;
    _videoMaximumDuration = 60;
    _backgroundColor = [UIColor whiteColor];
    [self configureCollectionView];
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

#pragma mark - getter

- (UIViewController *)rootViewController {
    if (!_rootViewController) {
        _rootViewController = [self getCurrentVC];
    }
    return _rootViewController;
}

#pragma mark - setter

- (void)setShowDelete:(BOOL)showDelete {
    _showDelete = showDelete;
}

- (void)setShowAddButton:(BOOL)showAddButton {
    _showAddButton = showAddButton;
    if (_mediaArray.count > 3 || _mediaArray.count == 0) {
        [self layoutCollection];
    }
}

- (void)setPreShowMedias:(NSArray *)preShowMedias {
    
    _preShowMedias = preShowMedias;
    NSMutableArray *temp = [NSMutableArray array];
    for (id object in preShowMedias) {
        ACMediaModel *model = [ACMediaModel new];
        if ([object isKindOfClass:[UIImage class]]) {
            model.image = object;
        }else if ([object isKindOfClass:[NSString class]]) {
            NSString *obj = (NSString *)object;
            if ([obj isValidUrl]) {
                model.imageUrlString = object;
            }else if ([obj isGifImage]) {
                //名字中有.gif是识别不了的（和自己的拓展名重复了，所以先去掉）
                NSString *name_ = obj.lowercaseString;
                if ([name_ containsString:@"gif"]) {
                    name_ = [name_ stringByReplacingOccurrencesOfString:@".gif" withString:@""];
                }
                model.image = [UIImage ac_setGifWithName:name_];
            }else {
                model.image = [UIImage imageNamed:object];
            }
        }else if ([object isKindOfClass:[ACMediaModel class]]) {
            model = object;
        }
        [temp addObject:model];
    }
    if (temp.count > 0) {
        _mediaArray = temp;
        [self layoutCollection];
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
    //预防先加载数据源的情况
    if (_mediaArray.count > 3) {
        _block(_collectionView.height);
    }
}

- (void)observeSelectedMediaArray: (ACSelectMediaBackBlock)backBlock {
    _backBlock = backBlock;
}

+ (CGFloat)defaultViewHeight {
    return ACMedia_ScreenWidth/4;
}

- (void)reload {
    [self.collectionView reloadData];
}

#pragma mark -  Collection View DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger num = self.mediaArray.count < 9 ? self.mediaArray.count : 9;
    if (num == 9) {
        return 9;
    }
    return _showAddButton ? num + 1 : num;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ACMediaImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ACMediaImageCell class]) forIndexPath:indexPath];
    if (indexPath.row == _mediaArray.count) {
        cell.icon.image = [UIImage imageForResourcePath:@"ACMediaFrame.bundle/AddMedia" ofType:@"png" inBundle:[NSBundle bundleForClass:[self class]]];
        cell.videoImageView.hidden = YES;
        cell.deleteButton.hidden = YES;
    }else{
        ACMediaModel *model = [[ACMediaModel alloc] init];
        model = _mediaArray[indexPath.row];
        
        if (model.imageUrlString) {
            [cell.icon ac_setImageWithUrlString:model.imageUrlString placeholderImage:nil];
        }else {
#warning    这个地方可能会存在一个问题
            cell.icon.image = model.image;
        }
        
        cell.videoImageView.hidden = !model.isVideo;
        cell.deleteButton.hidden = !_showDelete;
        [cell setACMediaClickDeleteButton:^{
            
            ACMediaModel *model = _mediaArray[indexPath.row];
            if (!_allowMultipleSelection) {
                
                if ([self.selectedImageAssets containsObject:model.asset]) {
                   [self.selectedImageAssets removeObject:model.asset];
                }
                [self adjustSelectedAssetsDicWithDeletedIndex:indexPath.row deletedAsset:model.asset];
            }
            
            [_mediaArray removeObjectAtIndex:indexPath.row];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self layoutCollection];
            });
        }];
    }
    return cell;
}

#pragma mark - collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _mediaArray.count && _mediaArray.count >= _maxImageSelected) {
        [UIAlertController showAlertWithTitle:[NSString stringWithFormat:@"最多只能选择%ld张",(long)_maxImageSelected] message:nil actionTitles:@[@"确定"] cancelTitle:nil style:UIAlertControllerStyleAlert completion:nil];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    //点击的是添加媒体的按钮
    if (indexPath.row == _mediaArray.count) {
        switch (_type) {
            case ACMediaTypePhoto:
                [self openAlbum];
                break;
            case ACMediaTypeCamera:
                [self openCamera];
                break;
            case ACMediaTypePhotoAndCamera:
            {
                ACAlertController *alert = [[ACAlertController alloc] initWithActionSheetTitles:@[@"相册", @"相机"] cancelTitle:@"取消"];
                [alert clickActionButton:^(NSInteger index) {
                    if (index == 0) {
                        [weakSelf openAlbum];
                    }else {
                        [weakSelf openCamera];
                    }
                }];
                [alert show];
            }
                break;
            case ACMediaTypeVideotape:
                [self openVideotape];
                break;
            case ACMediaTypeVideo:
                [self openVideo];
                break;
            default:
            {
                ACAlertController *alert = [[ACAlertController alloc] initWithActionSheetTitles:@[@"相册", @"相机", @"录像", @"视频"] cancelTitle:@"取消"];
                [alert clickActionButton:^(NSInteger index) {
                    if (index == 0) {
                        [weakSelf openAlbum];
                    }else if (index == 1) {
                        [weakSelf openCamera];
                    }else if (index == 2) {
                        [weakSelf openVideotape];
                    }else {
                        [weakSelf openVideo];
                    }
                }];
                [alert show];
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
            }else if (model.imageUrlString) {
                photo = [MWPhoto photoWithURL:[NSURL URLWithString:model.imageUrlString]];
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

///重新布局collectionview
- (void)layoutCollection {
    
    NSInteger allImageCount = _showAddButton ? _mediaArray.count + 1 : _mediaArray.count;
    NSInteger maxRow = (allImageCount - 1) / 4 + 1;
    _collectionView.height = allImageCount == 0 ? 0 : maxRow * ACMedia_ScreenWidth/4;
    self.height = _collectionView.height;
    //block回调
    !_block ?  : _block(_collectionView.height);
    !_backBlock ?  : _backBlock(_mediaArray);
    
    [_collectionView reloadData];
}

#pragma mark - actions

/** 相册 */
- (void)openAlbum {
    NSInteger count = 0;
    if (!_allowMultipleSelection) {
        count = _maxImageSelected - (_mediaArray.count - _selectedImageAssets.count);
    }else {
        count = _maxImageSelected - _mediaArray.count;
    }
    TZImagePickerController *imagePickController = [[TZImagePickerController alloc] initWithMaxImagesCount:count delegate:self];
    [self configureTZNaviBar:imagePickController];
    //是否 在相册中显示拍照按钮
    imagePickController.allowTakePicture = self.allowTakePicture;
    //是否可以选择显示原图
    imagePickController.allowPickingOriginalPhoto = self.allowPickingOriginalPhoto;
    //是否 在相册中可以选择视频
    imagePickController.allowPickingVideo = _allowPickingVideo;
    if (!_allowMultipleSelection) {
        imagePickController.selectedAssets = _selectedImageAssets;
    }
    [self.rootViewController presentViewController:imagePickController animated:YES completion:nil];
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
        [self.rootViewController presentViewController:picker animated:YES completion:nil];
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
        picker.videoMaximumDuration = self.videoMaximumDuration;        //录像最长时间
    } else {
        [UIAlertController showAlertWithTitle:@"当前设备不支持录像" message:nil actionTitles:@[@"确定"] cancelTitle:nil style:UIAlertControllerStyleAlert completion:nil];
    }
    [self.rootViewController presentViewController:picker animated:YES completion:nil];

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

//相册选取图片
- (void)imagePickerController:(TZImagePickerController *)picker
       didFinishPickingPhotos:(NSArray<UIImage *> *)photos
                 sourceAssets:(NSArray *)assets
        isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
{
    [self handleAssetsFromAlbum:assets photos:photos];
}

///选取视频后的回调
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    
    [[ACMediaManager manager] getMediaInfoFromAsset:asset completion:^(NSString *name, id pathData) {
        ACMediaModel *model = [[ACMediaModel alloc] init];
        model.name = name;
        model.uploadType = pathData;
        model.image = coverImage;
        model.isVideo = YES;
        model.asset = asset;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!self.allowMultipleSelection) {
                //去重，判断是否有想同
                for (ACMediaModel *md in self.mediaArray) {
                    if ([md.asset isEqual:asset]) {
                        return;
                    }
                }
            }
            [self.mediaArray addObject:model];
            [self layoutCollection];
            
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
        [[ACMediaManager manager] getVideoPathFromURL:videoAssetURL PHAsset:asset enableSave:NO completion:^(NSString *name, UIImage *screenshot, id pathData) {
            ACMediaModel *model = [[ACMediaModel alloc] init];
            model.image = screenshot;
            model.name = name;
            model.uploadType = pathData;
            model.isVideo = YES;
            model.mediaURL = videoAssetURL;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_mediaArray addObject:model];
                [self layoutCollection];
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
        [[ACMediaManager manager] getImageInfoFromImage:image PHAsset:asset completion:^(NSString *name, NSData *data) {
            ACMediaModel *model = [[ACMediaModel alloc] init];
            model.image = image;
            model.name = name;
            model.uploadType = data;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_mediaArray addObject:model];
                [self layoutCollection];
            });
        }];
    }
}

#pragma mark - private methods

/** 从相册中选择图片之后的数据处理 */
- (void)handleAssetsFromAlbum: (NSArray *)assets photos: (NSArray *)photos
{
    NSMutableArray *selectedAssets = [self.selectedImageAssets mutableCopy];
    
    if ([selectedAssets isEqualToArray: assets]) {
        return;
    }
    
    NSMutableArray *newAssets = [NSMutableArray arrayWithArray:assets];
    NSMutableArray *deletedAssets = [selectedAssets mutableCopy];
    NSArray *existentAssets = [NSArray array];
    
    if (!self.allowMultipleSelection) {
        
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF in %@",assets];
        //取交集
        existentAssets = [selectedAssets filteredArrayUsingPredicate:pre];
        
        //已选好的图片数组 - 共同存在的数组 = 已经被删除的数组
        [deletedAssets removeObjectsInArray:existentAssets];
        
        //从相册新选好的图片数组 - 共同存在的数组 = 新选取的数组
        [newAssets removeObjectsInArray:existentAssets];
        
        for (PHAsset *delete in deletedAssets) {
            NSInteger idx = [[self.selectedAssetsDic objectForKey:delete] integerValue];
            [self.mediaArray removeObjectAtIndex:idx];
            [self adjustSelectedAssetsDicWithDeletedIndex:idx deletedAsset:delete];
        }
    }
    
    for (PHAsset *new in newAssets) {
        NSInteger index = [assets indexOfObject:new];
        __weak typeof(self) weakSelf = self;
        [[ACMediaManager manager] getMediaInfoFromAsset:new completion:^(NSString *name, id pathData) {
            
            ACMediaModel *model = [[ACMediaModel alloc] init];
            model.name = name;
            model.asset = new;
            model.uploadType = pathData;
            model.image = photos[index];
            
            if ([NSString isGifWithImageData:pathData]) {
                model.image = [UIImage ac_setGifWithData:pathData];
            }
            
            if (!weakSelf.allowMultipleSelection) {
                [self.selectedAssetsDic setObject:[NSNumber numberWithInteger:self.mediaArray.count] forKey:new];
                self.selectedImageAssets = [NSMutableArray arrayWithArray:assets];
            }else {
                [self.selectedImageAssets addObjectsFromArray:assets];
            }
            [self.mediaArray addObject:model];
            
            //最后一个处理完就在主线程中进行布局
            if ([new isEqual:[newAssets lastObject]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self layoutCollection];
                });
            }
        }];
    }
}

/** 数据源下标有改变的时候，调整字典中其余下标值 */
- (void)adjustSelectedAssetsDicWithDeletedIndex: (NSInteger)deletedIndex deletedAsset: (PHAsset *)deletedAsset
{
    if (deletedAsset) {
        [self.selectedAssetsDic removeObjectForKey:deletedAsset];
    }
    for (PHAsset *asset in self.selectedAssetsDic.allKeys) {
        NSInteger idx = [[self.selectedAssetsDic objectForKey:asset] integerValue];
        if (idx > deletedIndex) {
            [self.selectedAssetsDic setObject:[NSNumber numberWithInteger:idx-1] forKey:asset];
        }
    }
}

///配置 TZImagePickerController 导航栏属性
- (void)configureTZNaviBar: (TZImagePickerController *)pick {
    
    if (self.naviBarBgColor) {
        pick.naviBgColor = self.naviBarBgColor;
    }
    if (self.naviBarTitleColor) {
        pick.naviTitleColor = self.naviBarTitleColor;
    }
    if (self.naviBarTitleFont) {
        pick.naviTitleFont = self.naviBarTitleFont;
    }
    if (self.barItemTextColor) {
        pick.barItemTextColor = self.barItemTextColor;
    }
    if (self.barItemTextFont) {
        pick.barItemTextFont = self.barItemTextFont;
    }
}

//有时候获取不到
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    NSAssert(result, @"\n*******\n rootViewController must not be nil. \n******");
    
    return result;
}

@end
