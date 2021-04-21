//
//  ACMediaTool.m
//
//  Created by caoyq on 2021/4/21.
//  Copyright © 2021 ArthurCao. All rights reserved.
//

#import "ACMediaTool.h"

@implementation ACMediaTool

+ (UIViewController *)topNavigationController {
    UIViewController *topVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([topVc isKindOfClass:[UITabBarController class]]) {
        topVc = ((UITabBarController *)topVc).selectedViewController;
    }
    NSArray *vcs = nil;
    if ([topVc isKindOfClass:[UINavigationController class]]) {
        vcs = ((UINavigationController *)topVc).viewControllers;
    }else {
        vcs = topVc.navigationController.viewControllers;
    }
    return vcs ? vcs.lastObject : nil;
}

// dict -> model
+ (ACMediaModel *)mediaInfoWithDict: (NSDictionary *)dict {
    ACMediaModel *model = [[ACMediaModel alloc] init];
    
    NSString *mediaType = [dict objectForKey:UIImagePickerControllerMediaType]; //UIImagePickerControllerPHAsset
    NSURL *referenceURL = [dict objectForKey:UIImagePickerControllerReferenceURL];
    PHAsset *asset;
    //录像与拍照没有引用地址 所以 referenceURL 为nil
    if (referenceURL) {
        PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[referenceURL] options:nil];
        asset = [result firstObject];
    }
    model.asset = asset;
    model.mediaType = [self getAssetType:asset];
    
    if ([mediaType isEqualToString:@"public.movie"]) {
        NSURL *videoURL = [dict objectForKey:UIImagePickerControllerMediaURL];
        model.name = [self videoNameWithAsset:asset];
        model.data = [NSData dataWithContentsOfURL:videoURL];
        model.videoURL = videoURL;
        model.image = [self coverImageWithVideoURL:videoURL];
    }else if ([mediaType isEqualToString:@"public.image"]) {
        UIImage * image = [dict objectForKey:UIImagePickerControllerEditedImage];
        //如果 picker 没有设置可编辑，那么image 为 nil
        if (image == nil) {
            image = [dict objectForKey:UIImagePickerControllerOriginalImage];
        }
        model.name = [self imageNameWithAsset:asset];
        model.image = [self fixOrientation:image];
        model.data = [self imageDataWithImage:model.image];
    }
    
    return model;
}

// asset -> model
+ (ACMediaModel *)imageInfoWithAsset: (PHAsset *)asset image: (UIImage *)image {
    ACMediaModel *model = [[ACMediaModel alloc] init];
    model.asset = asset;
    model.mediaType = [self getAssetType:asset];
    model.data = [self imageDataWithImage:image];
    model.name = [self imageNameWithAsset:asset];
    model.image = image;
    return model;
}

+ (void)videoInfoWithAsset: (PHAsset *)asset coverImage: (UIImage *)coverImage completion: (void(^)(ACMediaModel *model))completion {
    ACMediaModel *model = [[ACMediaModel alloc] init];
    model.asset = asset;
    model.name = [self videoNameWithAsset:asset];
    model.image = coverImage;
    model.mediaType = ACMediaModelTypeVideo;
    
    [self videoDataWithAsset:asset completion:^(NSData * _Nonnull data, NSURL * _Nonnull videoURL) {
        model.data = data;
        model.videoURL = videoURL;
        if (completion) completion(model);
    }];
}

+ (ACMediaModelType)getAssetType:(PHAsset *)asset {
    ACMediaModelType type = ACMediaModelTypePhoto;
    PHAsset *phAsset = (PHAsset *)asset;
    if (phAsset.mediaType == PHAssetMediaTypeVideo)      type = ACMediaModelTypeVideo;
    else if (phAsset.mediaType == PHAssetMediaTypeAudio) type = ACMediaModelTypeAudio;
    else if (phAsset.mediaType == PHAssetMediaTypeImage) {
        if (@available(iOS 9.1, *)) {
            // if (asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) type = TZAssetModelMediaTypeLivePhoto;
        }
        // Gif
        if ([[phAsset valueForKey:@"filename"] hasSuffix:@"GIF"]) {
            type = ACMediaModelTypePhotoGif;
        }
    }
    return type;
}

#pragma mark - data

+ (NSData *)imageDataWithImage: (UIImage *)image {
    NSData *imageData = nil;
    if (UIImagePNGRepresentation(image) == nil)
    {
        imageData = UIImageJPEGRepresentation(image, 1);
    } else
    {
        imageData = UIImagePNGRepresentation(image);
    }
    return imageData;
}

+ (void)videoDataWithAsset: (PHAsset *)asset completion: (void(^)(NSData *data, NSURL *videoURL))completion {
    PHVideoRequestOptions *option = [[PHVideoRequestOptions alloc] init];
    option.networkAccessAllowed = YES;
    [[PHImageManager defaultManager] requestPlayerItemForVideo:asset options:option resultHandler:^(AVPlayerItem *playerItem, NSDictionary *info) {
        NSString *key = info[@"PHImageFileSandboxExtensionTokenKey"];
        NSString *path = [key componentsSeparatedByString:@";"].lastObject;
        NSURL *url = [NSURL fileURLWithPath:path];
        NSData *data = [NSData dataWithContentsOfURL:url];
        if (completion) completion(data,url);
    }];
}

#pragma mark - name

+ (NSString *)imageNameWithAsset: (PHAsset *)asset {
    return [self mediaNameWithAsset:asset suffixName:@"IMG.PNG"];
}

+ (NSString *)videoNameWithAsset: (PHAsset *)asset {
    return [self mediaNameWithAsset:asset suffixName:@"Video.MOV"];
}

+ (NSString *)mediaNameWithAsset: (PHAsset *)asset suffixName: (NSString *)suffixName {
    //default user current time as name.
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *normalName = [formatter stringFromDate:[NSDate date]];
    normalName = [normalName stringByAppendingString:suffixName];
    
    if (asset) {
        PHAssetResource *resource = [[PHAssetResource assetResourcesForAsset:asset] firstObject];
        //获取本地原图的名称
        if (resource.originalFilename) {
            normalName = resource.originalFilename;
        }
    }
    return normalName;
}

#pragma mark - image

+ (UIImage *)coverImageWithVideoURL: (NSURL *)videoURL {
    AVURLAsset *urlAsset = [AVURLAsset assetWithURL:videoURL];
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    
    //视频总时长
    Float64 duration = CMTimeGetSeconds([urlAsset duration]);
    //取某个帧的时间，参数一表示哪个时间（秒），参数二表示每秒多少帧
    CMTime midPoint = CMTimeMake(duration * 0.5, 600);
    
    NSError *error = nil;
    //缩略图实际生成的时间
    CMTime actucalTime;
    
    //中间帧图片
    CGImageRef centerFrameImage = [imageGenerator copyCGImageAtTime:midPoint actualTime:&actucalTime error:&error];
    
    UIImage *image = nil;
    if (centerFrameImage) {
        image = [UIImage imageWithCGImage:centerFrameImage];
        CGImageRelease(centerFrameImage);
    }
    return image;
}

+ (UIImage *)fixOrientation:(UIImage *)aImage {
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end
