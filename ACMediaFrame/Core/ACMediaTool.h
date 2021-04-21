//
//  ACMediaTool.h
//
//  Created by caoyq on 2021/4/21.
//  Copyright © 2021 ArthurCao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "ACMediaModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * 工具类
 */
@interface ACMediaTool : NSObject

/// 获取栈顶控制器
+ (UIViewController *)topNavigationController;

/// 处理 UIImagePickerControllerDelegate 得到的数据
+ (ACMediaModel *)mediaInfoWithDict: (NSDictionary *)dict;
/// 处理 TZImagePickerControllerDelegate 中得到的图片与gif
+ (ACMediaModel *)imageInfoWithAsset: (PHAsset *)asset image: (UIImage *)image;
/// 处理 TZImagePickerControllerDelegate 中得到的视频
+ (void)videoInfoWithAsset: (PHAsset *)asset coverImage: (UIImage *)coverImage completion: (void(^)(ACMediaModel *model))completion;


/// 通过 asset 获取媒体类型
+ (ACMediaModelType)getAssetType:(PHAsset *)asset;

/// 获取图片二进制数据
+ (NSData *)imageDataWithImage: (UIImage *)image;
/// 获取视频二进制数据
+ (void)videoDataWithAsset: (PHAsset *)asset completion: (void(^)(NSData *data, NSURL *videoURL))completion;

/// 获取图片名
+ (NSString *)imageNameWithAsset: (PHAsset *)asset;
/// 获取视频名
+ (NSString *)videoNameWithAsset: (PHAsset *)asset;

/// 获取视频封面图
+ (UIImage *)coverImageWithVideoURL: (NSURL *)videoURL;

/// 获取修正方向后的图片
+ (UIImage *)fixOrientation:(UIImage *)aImage;

@end

NS_ASSUME_NONNULL_END
