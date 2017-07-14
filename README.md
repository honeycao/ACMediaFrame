# ACMediaFrame
一个完整的媒体库选择和展示的框架。包括本地图片、视频选取，拍摄、录像等，并得到对应的用于上传的数据类型，再也不用担心媒体文件上传了。

![ACMediaFrameExample.gif](https://gitlab.com/ImageLibrary/githubImage/raw/master/ACMediaFrame/ACMediaFrame.gif)

## 导航
* [基本要求](#Requirements)
* [实现功能](#function)
* [结构层次](#Architecture)
  * [如何添加](#add)
  * [使用详情](#detail)
  * [属性自定义](#custom)
* [版本更新](#version)
* [Hope](#hope)


## <a id="Requirements"></a>基本要求

* iOS 8.0  or later

* Xcode 7.0 or later

* 用到github上第三方：[TZImagePickerController](https://github.com/banchichen/TZImagePickerController)和[MWPhotoBrowser](https://github.com/mwaterfall/MWPhotoBrowser)和 [ACAlertController](https://github.com/honeycao/ACAlertController)


## <a id="function"></a>实现功能
* 本地图片视频选择、拍照录制等一条龙轻松实现
* 框架主体是一个view，已经实现高度配置，不用再去做任何处理
* 框架主体形势支持：添加媒体、预览展示媒体、混合编辑（添加和预览展示一起实现）
* 选择媒体上支持：删除、限定最大选择数数量、同个媒体资源是否多次选择等多种自定义功能。
* 从本地相册选择图片用到了`TZImagePickerController`；查看图片视频用到了`MWPhotoBrowser`；底部弹出框用到`ACAlertController`替代系统弹框
* 自定义媒体model，返回图片、视频上传数据类型，如：NSData或视频路径。不用为了得到上传的数据类型做任何处理了。

## <a id="Architecture">结构层次

### <a id="add"></a>如何添加

* 使用 `CocoaPods`
  - 待支持
* 手动添加
  - 把`ACMediaFrame`文件拉到项目中
  - 添加头文件`#import "ACMediaFrame.h"`

### <a id="detail"></a>使用详情（具体看 `ACMediaFrameExample` 示例）
*demo目录分析*
* `AddTableViewController`        添加媒体的演示
* `DisplayTableViewController`    预览媒体的演示
* `EditTableViewController`       添加和预览混合编排的演示
```
// 唯一获取初始化高度的方法
CGFloat height = [ACSelectMediaView defaultViewHeight];

// 初始化
ACSelectMediaView *mediaView = [[ACSelectMediaView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, height)];

// 需要展示的媒体的资源类型，当前是仅本地图库
mediaView.type = ACMediaTypePhoto;

// 是否允许 同个图片或视频进行多次选择
mediaView.allowMultipleSelection = NO;

//视情况看是否需要改变高度，目前单独使用且作为tableview的header，并不用监控并改变高度
[mediaView observeViewHeight:^(CGFloat mediaHeight) {
    //
}];

// 随时获取选择好媒体文件
[mediaView observeSelectedMediaArray:^(NSArray<ACMediaModel *> *list) {
    // do something
    for (ACMediaModel *model in list) {
    //遍历得到模型中想要的数据  e.g.
    // id uplodaType = model.uploadType;
    // NSString *name = model.name;
}
NSLog(@"list.count = %lu",(unsigned long)list.count);
}];

// 添加到控件上
self.tableView.tableHeaderView = mediaView;
```
-------

### <a id="custom"></a>属性自定义

>demo中有些属性可能没用上，不同属性的设置可以达成不同的效果

* `type`
>需要展示的媒体的资源类型：如仅显示图片等，默认是 ACMediaTypePhotoAndCamera
```
e.g. 点击加号按钮，自定义所想要的媒体资源选项
mediaView.type = ACMediaTypePhoto
```

* `preShowMedias`
>预先展示的媒体数组。如果一开始有需要显示媒体资源，可以先传入进行显示，没有的话可以不赋值。
传入的如果是图片类型，则可以是：UIImage，NSString，至于其他的都可以传入 ACMediaModel类型
包括网络图片和gif图片、视频。

```
e.g. 在预览或者之前已经有图片的情况下，需要传入进行预先展示(其中包括预展示视频、gif等)

//视频必须是传入这样一个model参数
ACMediaModel *md = [ACMediaModel new];
md.mediaURL = [NSURL URLWithString:@"http://baobab.wdjcdn.com/1451897812703c.mp4"];
md.isVideo = YES;
md.image = [UIImage imageNamed:@"memory"]; //封面图

mediaView.preShowMedias = @[@"bg_1", @"bg_2", @"bug.gif", @"http://c.hiphotos.baidu.com/image/h%3D200/sign=ad1c53cd0355b31983f9857573ab8286/279759ee3d6d55fbb02469ea64224f4a21a4dd1f.jpg"];
```

* `maxImageSelected`
>最大图片、视频选择个数，包括 `preShowMedias`的数量. default is 9
```
e.g. 自定义从本地相册中所选取的最大数量
mediaView.maxImageSelected = 5;
```

* `showDelete`
>是否显示删除按钮. Defaults is YES
```
e.g. 一般在预览情况下设置为 NO
mediaView.showDelete = NO;
```

* `showAddButton`
>是否需要显示添加按钮. Defaults is YES 
```
e.g. 一般在预览情况下设置为 NO
mediaView.showAddButton = NO;
```

* `allowPickingVideo`
>是否允许 在选择图片的同时可以选择视频文件. default is NO
>选择的本地视频只是简单加载显示，当需要立刻播放选择的本地视频时，会有一个转码加载的过程，请等待（注意）
```
e.g. 如果希望在选择图片的时候，出现视频资源，那么可以设置为 YES
mediaView.allowPickingVideo = NO;
```

* `allowMultipleSelection`
>是否允许 同个图片或视频进行多次选择. default is YES
如果设置为 NO，那么在已经选择了一张以上图片之后，就不能同时选择视频了（注意）
```
e.g.  如果不希望已经选择的图片或视频，再次被选择，那么可以设置为 NO
mediaView.allowMultipleSelection = NO;
```

* `allowTakePicture`
>是否允许 在相册中出现拍照选择. default is NO
设置为YES，那么在相册最后一格会出现一格拍照按钮，点击可以打开相机拍照，拍照成功之后会保存到相册并选中状态
```
e.g. 如果希望出现拍照按钮，可以设置为YES
mediaView.allowTakePicture = YES;
```

* `allowPickingOriginalPhoto`
>是否允许 相册中出现选择原图. default is NO 
设置为 YES，那么相册底部会出现一格原图选项，可以保证选中的图片是原图，原图可能就比较大点，所以一般没这个必要。
```
e.g. 如果希望选择原图，那么可以设置为YES
mediaView.allowPickingOriginalPhoto = YES;
```

* `videoMaximumDuration`
>设置录像的一个最大持续时间(以秒为单位). default is 60
```
e.g. 设置录像最大时长为10秒
mediaView.videoMaximumDuration = 10.0;
```

* `rootViewController`
>当前的主控制器(非必传)
但是有时候碰到无法自动获取的时候会抛出异常(rootViewController must not be nil)，那么就必须手动传入

* `backgroundColor`
>底部collectionView的背景颜色，有特殊颜色要求的可以单独去设置

***一系列自定义导航栏属性***

* `naviBarBgColor`
>navigationbar background color. 

* `naviBarTitleColor`
>navigationBar title color

* `naviBarTitleFont`
>navigationBar title font

* `barItemTextColor`
>navigationItem right/left barButtonItem text color

* `barItemTextFont`
>navigationItem right/left barButtonItem text font

------

## <a id="version"></a>版本更新
* `1.3.9` : 之前对预展示视频写的不够清楚，于是这次就对如何集成和使用预展示视频功能，添加了相关的演示范例。
* `1.3.8` : 添加、开放属性，用于自定义相册界面的导航栏.
* `1.3.7` : 由于会碰到无法自动获取一个主视图的情况，所以开放一个参数`rootViewController`,用于手动传入当前的主控制器，非必传的，如果自动获取失败会抛出一个异常，具体看`属性自定义`中的使用即可.
* `1.3.6` : 应使用者需求，继续开放了功能接口，包括：是否允许相册中拍照、是否可以选择原图、设置录像最大持续时间。
* `1.3.5` : 添加支持gif图片选择和展示功能。
* `1.3.4` : 完善图片视频选择的一些逻辑问题。
* `1.3.3` : 这个版本其实和上个版本一样，只不过有热心群众反馈播放视频的时候没有开启麦克风权限没有声音，所以添加了一个权限判断，但是后来自己测试的时候发现并没有这个bug，所以最终就没做什么大的调整。
* `1.3.2` : 上一版本处理好之后，没有同时测试相册和相机选择图片的情况，所以出现了点问题，现在这版本就是修改这个问题，很感谢小伙伴的使用和提供的bug，由于自己能力有限，所以难免会有些许bug，不打紧，你们发现bug告诉我，我会尽快修复。。。
* `1.3.1` : 对上一版本的简单改动，修改获取主控制器失败的方法，以及继续完善
* `1.3.0` : 改动比较大的一次，首先是代码整体层次上变动了下，另外添加了自己写的一个底部弹出框功能，添加几个开放属性（是否在图片中可以选择视频、选择的图片下次是否可以继续选择等）
* `1.2.0` : 由于上次的提交，导致一个问题（设置的隐藏添加图片按钮失效的问题），当时没有考虑完全，所以这次进行修改并修复有默认图片是显示的一些布局问题；另外继续完善几个开放接口，比如设置选择图片数量等。
* `1.1.0` :
  * 添加了几个属性，使得框架更容易集成和修改。现在不仅可以用来选择图片等媒体资源，同时也可以只是用来展示等。
  * 修改了添加框架的头文件等
* `1.0.1` : 添加一个媒体类型，默认媒体资源是本地图片、视频，拍摄的图片、录像等，现在可以自己选择类型，例如：当只需要图片时，就设置媒体类型属性即可。 
* `1.0.0` : 最初原型，封装的选择媒体以及布局的页面，把媒体资源的处理全进行封装，减少重复工作，只需添加到视图上，然后接收获取的媒体数据。
   
## <a id="hope"></a>Hope
* 代码使用过程中，发现任何问题，可以随时[issues me](https://github.com/honeycao/ACMediaFrame/issues/new)
* 如果有更多建议或者想法也可以直接联系我 QQ:331864805
* 觉得框架对你有一点点帮助的，就请支持下，点个赞。

## Licenses
All source code is licensed under the MIT License.
