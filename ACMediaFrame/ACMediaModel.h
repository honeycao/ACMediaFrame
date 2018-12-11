//
//  ACMediaModel.h
//
//  Created by caoyq on 2018/11/26.
//  Copyright © 2018 AllenCao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface ACMediaModel : NSObject

///文件名
@property (nonatomic, strong) NSString *name;
///二进制文件数据
@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) PHAsset *asset;

///原始图片
@property (nonatomic, strong) UIImage *originalImage;

///视频URL
@property (nonatomic, strong) NSURL *videoURL;
///视频封面图
@property (nonatomic, strong) UIImage *coverImage;

#pragma mark - methods

///处理 UIImagePickerControllerDelegate 得到的数据
+ (instancetype)mediaInfoWithDict: (NSDictionary *)dict;

///处理 TZImagePickerControllerDelegate 中得到的图片与gif
+ (instancetype)imageInfoWithAsset: (PHAsset *)asset image: (UIImage *)image;
///处理 TZImagePickerControllerDelegate 中得到的视频
+ (void)videoInfoWithAsset: (PHAsset *)asset coverImage: (UIImage *)coverImage completion: (void(^)(ACMediaModel *model))completion;

@end

@interface ACMediaModel (Tool)

///获取图片二进制数据
+ (NSData *)imageDataWithImage: (UIImage *)image;
///获取视频二进制数据
+ (void)videoDataWithAsset: (PHAsset *)asset completion: (void(^)(NSData *data, NSURL *videoURL))completion;

///获取图片名
+ (NSString *)imageNameWithAsset: (PHAsset *)asset;
///获取视频名
+ (NSString *)videoNameWithAsset: (PHAsset *)asset;

///获取视频封面图
+ (UIImage *)coverImageWithVideoURL: (NSURL *)videoURL;

///获取修正方向后的图片
+ (UIImage *)fixOrientation:(UIImage *)aImage;

@end

NS_ASSUME_NONNULL_END
