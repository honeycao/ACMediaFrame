//
//  ACMediaModel.h
//
//  Created by caoyq on 2018/11/26.
//  Copyright © 2018 AllenCao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

typedef NS_ENUM(NSInteger, ACMediaModelType) {
    ACMediaModelTypePhoto = 0,
    ACMediaModelTypeLivePhoto,
    ACMediaModelTypePhotoGif,
    ACMediaModelTypeVideo,
    ACMediaModelTypeAudio
};

/**
 * 媒体资源模型
 */
@interface ACMediaModel : NSObject

/// 文件名
@property (nonatomic, strong) NSString *name;
/// 二进制文件数据
@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) PHAsset *asset;

/// 图片、gif以及视频的封面图
@property (nonatomic, strong) UIImage *image;

/// 视频URL(单选视频会有，多选的话只有data)
@property (nonatomic, strong) NSURL *videoURL;

/// 媒体类型
@property (nonatomic, assign) ACMediaModelType mediaType;

@end
