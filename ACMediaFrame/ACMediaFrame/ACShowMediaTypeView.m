//
//  ACShowMediaTypeView.m
//
//  Created by caoyq on 16/12/2.
//  Copyright © 2016年 SnSoft. All rights reserved.
//

#import "ACShowMediaTypeView.h"
#import "ACMediaFrameConst.h"


@interface ItemCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *itemImage;

@end

@implementation ItemCell

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.itemImage = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:self.itemImage];
    }
    return self;
}

@end

static CGFloat space = 30;

@interface ACShowMediaTypeView ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    CGFloat itemW;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *itemArray;
@property (nonatomic, copy) SelectedIndex block;

@end

@implementation ACShowMediaTypeView

#pragma mark - getter

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        itemW = (ACMedia_ScreenWidth - 5 * space)/4;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(itemW, itemW);
        layout.minimumInteritemSpacing = space;
        layout.minimumLineSpacing = space;
        layout.sectionInset = UIEdgeInsetsMake(space/2, space, space/2, space);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, ACMedia_ScreenHeight, ACMedia_ScreenWidth, itemW + space/2 * 2) collectionViewLayout:layout];
        [_collectionView registerClass:[ItemCell class] forCellWithReuseIdentifier:NSStringFromClass([ItemCell class])];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = ACMediaBackGroundColor;
    }
    return _collectionView;
}

#pragma mark - init method

- (instancetype)init {
    self = [super initWithFrame:ACMedia_ScreenBounds];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.itemArray = @[@"ACMediaFrame.bundle/Album", @"ACMediaFrame.bundle/Camera", @"ACMediaFrame.bundle/Videotape", @"ACMediaFrame.bundle/Video"];
    }
    return self;
}

- (void)selectedIndexBlock: (SelectedIndex)selectedBlock {
    self.block = selectedBlock;
}

#pragma mark - action

- (void)show {
    UIView *window = [[UIApplication sharedApplication] keyWindow].rootViewController.view;
    [window addSubview:self];
    [self addSubview:self.collectionView];
    [UIView animateWithDuration:0.3 animations:^{
        self.collectionView.y = ACMedia_ScreenHeight - (itemW + space/2 * 2);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hide];
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        _collectionView.y = ACMedia_ScreenHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [_collectionView removeFromSuperview];
        _collectionView = nil;
    }];
}

#pragma mark -  Collection View DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _itemArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ItemCell class]) forIndexPath:indexPath];
    cell.itemImage.image = [UIImage imageNamed:_itemArray[indexPath.row]];
    return cell;
}

#pragma mark - Collection View Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    !_block ?  : _block(indexPath.row);
    [self hide];
}

@end
