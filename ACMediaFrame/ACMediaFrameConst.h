//
//  ACMediaFrameConst.h
//
//  Version: 2.0.4.
//  Created by ArthurCao<https://github.com/honeycao> on 2017/03/16.
//  Update: 2017/12/27.
//

#import <UIKit/UIKit.h>
#import <objc/message.h>

#define  ACMedia_ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define  ACMedia_ScreenHeight [UIScreen mainScreen].bounds.size.height
#define  ACMedia_ScreenBounds [UIScreen mainScreen].bounds
#define  ACMediaBackGroundColor [UIColor colorWithRed:0xf2/255.0 green:0xf4/255.0 blue:0xf9/255.0 alpha:1]

#define ACMediaRatio ACMedia_ScreenWidth/375.0

/** cell上删除按钮的宽 */
#define ACMediaDeleteButtonWidth ACMediaRatio * 18

#define ACMediaWeakSelf      __weak __typeof__(self) weakSelf = self;

#define ACMediaDeprecated(instead)  NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)
