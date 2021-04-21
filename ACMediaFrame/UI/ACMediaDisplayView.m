//
//  ACMediaDisplayView.m
//
//  Created by caoyq on 2021/4/20.
//  Copyright © 2021 ArthurCao. All rights reserved.
//

#import "ACMediaDisplayView.h"
//
#import "ACMediaImageCell.h"
//
#import "TZPhotoPreviewController.h"
#import "TZImagePickerController.h"
#import "TZAssetModel.h"

@interface ACMediaDisplayView ()<UICollectionViewDelegate, UICollectionViewDataSource>
 
/// UI 配置项
@property (nonatomic, strong) ACMediaDisplayConfig *config;
/// 核心功能管理者
@property (nonatomic, strong) ACMediaPickerManager *pickerManager;
/// 容器
@property (nonatomic, strong) UICollectionView *collectionView;
/// 保存的媒体资源
@property (nonatomic, strong) NSMutableArray *mediaArray;

@end

@implementation ACMediaDisplayView

#pragma mark - Init

- (instancetype)init {
    return [self initWithFrame:CGRectZero config:[ACMediaDisplayConfig new]];
}

- (instancetype)initWithConfig: (ACMediaDisplayConfig *)config {
    return [self initWithFrame:CGRectZero config:config];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame config:[ACMediaDisplayConfig new]];
}

- (instancetype)initWithFrame:(CGRect)frame config: (ACMediaDisplayConfig *)config {
    self = [super initWithFrame:frame];
    if (self) {
        self.config = config;
        self.mediaArray = @[].mutableCopy;
        [self settingPickerManager];
        [self configureCollectionViewWithFrame:frame];
    }
    return self;
}

- (void)settingPickerManager {
    ACMediaPickerManager *pickMgr = [[ACMediaPickerManager alloc] init];
    if (self.customizePickerManagerBlock) {
        self.customizePickerManagerBlock(pickMgr);
    }
    __weak typeof(self) weakSelf = self;
    pickMgr.didFinishPickingBlock = ^(NSArray<ACMediaModel *> * _Nonnull list) {
        weakSelf.mediaArray = list.mutableCopy;
        [weakSelf reloadCollectionView];
    };
    self.pickerManager = pickMgr;
}

- (void)configureCollectionViewWithFrame: (CGRect)frame {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = self.config.lineSpacing;
    layout.minimumInteritemSpacing = self.config.interitemSpacing;
    layout.sectionInset = self.config.sectionInset;
    CGFloat itemW = [self itemWidth];
    layout.itemSize = CGSizeMake(itemW, itemW);
    _collectionView = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:layout];
    [_collectionView registerClass:[ACMediaImageCell class] forCellWithReuseIdentifier:NSStringFromClass([ACMediaImageCell class])];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = self.config.containerBgColor;
    [self addSubview:_collectionView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}

- (void)reloadCollectionView {
    [self.collectionView reloadData];
    CGFloat viewH = self.viewHeight;
    // 内部自动更新容器高度
    CGRect rect = self.frame;
    rect.size.height = viewH;
    self.frame = rect;
    if (self.observeContainerHeightChangeBlock) {
        self.observeContainerHeightChangeBlock(viewH);
    }
    [self setNeedsLayout];
}

#pragma mark - getter

- (NSArray *)selectedMediaList {
    return self.mediaArray;
}

- (CGFloat)viewHeight {
    NSInteger count = [self numberOfItems];
    NSInteger row = ceil(1.0 * count / self.config.rowImageCount);
    CGFloat itemW = [self itemWidth];
    CGFloat height = self.config.sectionInset.top + self.config.sectionInset.bottom + itemW * row + self.config.interitemSpacing * (row - 1);
    return height;
}

/// collection item width
- (CGFloat)itemWidth {
    return 1.0 * (self.bounds.size.width - self.config.sectionInset.left - self.config.sectionInset.right - (self.config.rowImageCount - 1) * self.config.interitemSpacing) / self.config.rowImageCount;
}

/// collection items count
- (NSInteger)numberOfItems {
    return [self isExistAddButton] ? self.mediaArray.count + 1 : self.mediaArray.count;
}

/// 是否存在添加按钮
- (BOOL)isExistAddButton {
    return self.mediaArray.count < self.pickerManager.maxImageSelected;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self numberOfItems];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ACMediaImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ACMediaImageCell class]) forIndexPath:indexPath];
    
    if ([self isExistAddButton] && indexPath.item == self.mediaArray.count) {
        cell.deleteButtonImage = nil;
        cell.showImage = self.config.addImage;
        cell.videoTagImage = nil;
    }else {
        ACMediaModel *model = self.mediaArray[indexPath.row];
        cell.deleteButtonImage = self.config.deleteImage;
        
        if (model.mediaType == ACMediaModelTypeVideo) {
            cell.videoTagImage = self.config.videoTagImage;
        }else {
            cell.videoTagImage = nil;
        }
        cell.showImage = model.image;
        __weak typeof(self) weakSelf = self;
        cell.ACMediaClickDeleteButton = ^{
            [weakSelf.mediaArray removeObjectAtIndex:indexPath.row];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf reloadCollectionView];
            });
        };
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isExistAddButton] && indexPath.item == self.mediaArray.count) {
        self.pickerManager.seletedMediaArray = self.mediaArray;
        [self.pickerManager picker];
    }else {
        if (self.customizeMediaPreviewBlock) {
            self.customizeMediaPreviewBlock(self.mediaArray, indexPath.item);
            return;
        }
        
        TZPhotoPreviewController *preViewController = [[TZPhotoPreviewController alloc] init];
        NSMutableArray *temp = @[].mutableCopy;
        for (ACMediaModel *model in self.mediaArray) {
            [temp addObject:[TZAssetModel modelWithAsset:model.asset type:model.mediaType]];
        }
        preViewController.models = temp;
        preViewController.currentIndex = indexPath.item;
        TZImagePickerController *nav = [[TZImagePickerController alloc] initWithRootViewController:preViewController];
        [self.pickerManager.currentViewController presentViewController:nav animated:YES completion:nil];
    }
}

@end
