# ACMediaFrame
一个完整的媒体库选择和展示的框架。包括本地图片、视频选取，拍摄、录像等，并得到对应的用于上传的数据类型，再也不用担心媒体文件上传了。

![ACMediaFrameExampleGif.gif](https://github.com/honeycao/ACMediaFrame/blob/master/ACMediaFrameExampleGif.gif)

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
* 选择媒体上支持：删除、限定最大选择数数量、同个媒体资源是否多次选择等。、
* 从本地相册选择图片用到了`TZImagePickerController`；查看图片视频用到了`MWPhotoBrowser`；底部弹出框用到`ACAlertController`替代系统弹框
* 自定义媒体model，返回图片、视频上传数据类型，如：NSData或视频路径。不用为了得到上传的数据类型做任何处理了。

## <a id="Architecture">结构层次

* [如何添加](#add)
* [使用详情](#detail)
* [属性自定义](#custom)

### <a id="add"></a>如何添加

* 使用 `CocoaPods`
  - 待支持
* 手动添加
  - 把`ACMediaFrame`文件拉到项目中
  - 添加头文件`#import "ACMediaFrame.h"`

### <a id="detail"></a>使用详情（具体看`ACMediaFrameExample`示例）
```
简单演示
```

### <a id="custom"></a>属性自定义
>demo中有些属性可能没用上，不同属性的设置可以达成不同的效果

## <a id="version"></a>版本更新
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
​
## Licenses
All source code is licensed under the MIT License.
