//
//  ACMediaManager.h
//
//  Created by caoyq on 16/12/22.
//  Copyright © 2016年 ArthurCao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

/** 媒体库管理中心 */
@interface ACMediaManager : NSObject

/**
 初始化单例

 @return 返回 ACMediaManager 的一个实例
 */
+ (instancetype)manager;

/**
 传入 Image 和 PHAsset，得到该图片的原图名称、上传类型NSData
 
 @param image 传入的图片
 @param asset PHAsset对象，没有原图则传入nil
 @param completion 成功的回调
 */
- (void)getImageInfoFromImage: (UIImage *)image PHAsset: (PHAsset *)asset completion: (void(^)(NSString *name, NSData *data))completion;

/**
 根据 URL 等获取视频封面、名称 和 上传类型(优先路径 或 NSData)
 
 @param videoURL   视频URL
 @param asset      视频PHAsset（本地存在原图才有这个属性值，不然传入nil）
 @param enableSave 对于本地没有的是否保存到本地
 @param completion 成功回调，不保存的话，返回的NSData
 */
- (void)getVideoPathFromURL: (NSURL *)videoURL PHAsset: (PHAsset *)asset enableSave: (BOOL)enableSave completion: (void(^)(NSString *name, UIImage *screenshot, id pathData))completion;

/**
 根据 PHAsset 来获取 媒体文件(视频或图片)相关信息：文件名、文件上传类型（data 或 path）
 
 @param asset  PHAsset对象
 @param completion 成功回调
 */
- (void)getMediaInfoFromAsset: (PHAsset *)asset completion: (void(^)(NSString *name, id pathData))completion;

#pragma mark - 权限

/**
 判断麦克风权限，第一次时让用户选择是否开启权限（仅一次）
 */
- (void)microphoneAuthorizationStatus;

@end
