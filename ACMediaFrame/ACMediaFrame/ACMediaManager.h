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

+ (void)getImageInfoFromImage: (UIImage *)image PHAsset: (PHAsset *)asset completion: (void(^)(NSString *name, NSData *data))completion;

+ (void)getVideoPathFromURL: (NSURL *)videoURL PHAsset: (PHAsset *)asset enableSave: (BOOL)enableSave completion: (void(^)(NSString *name, UIImage *screenshot, id pathData))completion;

+ (void)getMediaInfoFromAsset: (PHAsset *)asset completion: (void(^)(NSString *name, id pathData))completion;

@end
