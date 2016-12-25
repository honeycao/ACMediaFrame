# ACMediaFrame
一个完整的媒体选择流程框架封装，包括：图片视频选择、录制；任意页面布局展示图片视频，可删除；直接存储了供上传的数据类型，所以距离上传就一步之遥（发送请求而已）。
![ACMediFrame展示.gif](https://github.com/honeycao/ACMediaFrame/blob/master/ACMediFrame%E5%B1%95%E7%A4%BA.gif)

------
###导航
* [功能]()
* [使用]()
* [问题及完善]()
* [备注]()

-------
### 1、功能

* 本地图片视频选择、拍照录制等全封装使用
* 主体是一个展示的页面，可添加到任何地方，同时处理好了一切布局。
* 选择图片和图片预览等用到了`TZImagePickerController`和`MWPhotoBrowser`两个第三方
* 自定义媒体model，存储图片、视频上传数据类型，如：NSData或视频路径。
* 结果：添加该框架到任意页面之后不再需要做其他操作，只需要写上文件上传的网络请求即可。

-------
### 2、使用

* 下载代码集成：添加`ACMediaFrame`文件夹即可
* 添加本框架必要第三方：[TZImagePickerController](https://github.com/banchichen/TZImagePickerController)和[MWPhotoBrowser](https://github.com/mwaterfall/MWPhotoBrowser)

```objective-c
//添加头文件
#import "ACSelectMediaView.h"
//1、得到默认布局高度（唯一获取高度方法）
CGFloat height = [ACSelectMediaView defaultViewHeight];
UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, height)];
//2、初始化 媒体页面
ACSelectMediaView *mediaView = [[ACSelectMediaView alloc] initWithFrame:CGRectMake(0, 0, bgView.frame.size.width, bgView.frame.size.height)];
//3、随时获取新的布局高度
[mediaView observeViewHeight:^(CGFloat value) {
    bgView.height = value;
}];
//4、随时获取已经选择的媒体文件
[mediaView observeSelectedMediaArray:^(NSArray<ACMediaModel *> *list) {
    for (ACMediaModel *model in list) {
        NSLog(@"%@",model);
    }
}];
[bgView addSubview:mediaView];
[self.view addSubview:bgView];
```

-------
#### 3、问题及完善

* 一开始一次性添加多张照片的时候，出现过返回缺少的情况，后来又没有出现过，所以记录并统计下。

-------

#### 4、备注

* **I am a rookie ，I am not God （有建议或想法请q：331864805 ，你的点赞是我最大的动力）**
* 框架内容详细解析：[简书--iOS 媒体库完整流程封装：图片视频选择、展示布局、上传等。](http://www.jianshu.com/p/9ff1e8e68a21)
