//
//  ACSelectMediaView.h
//
//  Created by ArthurCao<https://github.com/honeycao> on 2017/04/12.
//  Version: 2.0.4.
//  Update: 2017/12/28.
//

#import <UIKit/UIKit.h>
#import "ACMediaModel.h"
#import "ACMediaFrameConst.h"

/** 媒体资源的类型 */
typedef NS_ENUM(NSInteger, ACMediaType) {
    ACMediaTypePhotoAndCamera = 0, /**< 本地图片和相机 */
    ACMediaTypePhoto, /**< 本地图片 */
    ACMediaTypeCamera, /**< 相机拍摄 */
    ACMediaTypeVideotape, /**< 录像 */
    ACMediaTypeVideo, /**< 视频 */
    ACMediaTypeAll /**< 所有媒体资源 */
};

typedef void(^ACMediaHeightBlock)(CGFloat mediaHeight);

typedef void(^ACSelectMediaBackBlock)(NSArray<ACMediaModel *> *list);

/** 选择媒体 并 排列展示 的页面 */
@interface ACSelectMediaView : UIView

#pragma mark - 自定义的属性

/** 
 * 需要展示的媒体的资源类型：如仅显示图片等，默认是 ACMediaTypePhotoAndCamera
 */
@property (nonatomic, assign) ACMediaType type;

/** 
 * 预先展示的媒体数组。如果一开始有需要显示媒体资源，可以先传入进行显示，没有的话可以不赋值。
 * 传入的如果是图片类型，则可以是：UIImage，NSString，至于其他的都可以传入 ACMediaModel类型
 * 当前只支持图片和视频
 */
@property (nonatomic, strong) NSArray *preShowMedias;

/**
 * 可选择的最大资源数,（包括 preShowMedias 预先展示数据）. default is 9
 */
@property (nonatomic, assign) NSInteger maxImageSelected;

/**
 * 是否显示删除按钮. Defaults is YES
 */
@property (nonatomic, assign) BOOL showDelete;

/**
 * 是否需要显示添加按钮. Defaults is YES
 */
@property (nonatomic, assign) BOOL showAddButton;

/** 
 * 是否允许 在选择图片的同时可以选择视频文件. default is NO
 */
@property (nonatomic, assign) BOOL allowPickingVideo;

/** 
 * 是否允许 同个图片或视频进行多次选择. default is YES 
 */
@property (nonatomic, assign) BOOL allowMultipleSelection;
    
/** 
 * 是否允许 在相册中出现拍照选择. default is NO
 */
@property (nonatomic, assign) BOOL allowTakePicture;
    
/** 
 * 是否允许 相册中出现选择原图. default is NO 
 */
@property (nonatomic, assign) BOOL allowPickingOriginalPhoto;
    
/** 
 * 录像的最大持续时间(以秒为单位). default is 60 
 */
@property (nonatomic, assign) CGFloat videoMaximumDuration;

/**
 * 当前的主控制器(非必传)
 * 但是有时候碰到无法自动获取的时候会抛出异常(rootViewController must not be nil)，那么就必须手动传入
 */
@property (nonatomic, strong) UIViewController *rootViewController;

#pragma mark - UI布局

/** 一行显示图片个数. default is 4. */
@property (nonatomic, assign) NSInteger rowImageCount;
/** item行间距. default is 10. */
@property (nonatomic, assign) CGFloat lineSpacing;
/** item列间距. default is 10. */
@property (nonatomic, assign) CGFloat interitemSpacing;
/** section边距. default is (10, 10, 10, 10). */
@property (nonatomic, assign) UIEdgeInsets sectionInset;
/** 添加按钮的图片. 不想使用自带的图片可以自定义传入. */
@property (nonatomic, strong) UIImage *addImage;
/** 删除按钮的图片. 不想使用自带的图片可以自定义传入. */
@property (nonatomic, strong) UIImage *deleteImage;
/** 视频标签图片. 不想使用自带的图片可以自定义传入. */
@property (nonatomic, strong) UIImage *videoTagImage;

/** 图片底层视图的背景色 */
@property (nonatomic, strong) UIColor *backgroundColor;

#pragma mark - 自定义相册的导航栏相关属性

/** navigationbar background color */
@property (nonatomic, strong) UIColor *naviBarBgColor;

/** navigationBar title color */
@property (nonatomic, strong) UIColor *naviBarTitleColor;

/** navigationBar title font */
@property (nonatomic, strong) UIFont *naviBarTitleFont;

/** navigationItem right/left barButtonItem text color */
@property (nonatomic, strong) UIColor *barItemTextColor;

/** navigationItem right/left barButtonItem text font */
@property (nonatomic, strong) UIFont *barItemTextFont;

/** 顶部statusBar 是否为系统默认的黑色. default is NO. */
@property (nonatomic, assign) BOOL isStatusBarDefault;

/** 自定义返回按钮样式及其属性 */
@property (nonatomic, strong) UIButton *barBackButton;

#pragma mark - methods

/** 
 * 监控view的高度变化，如果不和其他控件一起使用，则可以不用监控高度变化
 */
- (void)observeViewHeight: (ACMediaHeightBlock)value;

/** 
 * 随时监控当前选择到的媒体文件 
 */
- (void)observeSelectedMediaArray: (ACSelectMediaBackBlock)backBlock;

/**
 * 视图一开始默认高度，该方法在 2.0.4版本开始就不需要了.
 */
+ (CGFloat)defaultViewHeight ACMediaDeprecated("使用 reload 自动刷新高度");

/**
  刷新，自动变更高度约束.
 
  使用了 observeViewHeight 方法，该方法可不用.
 */
- (void)reload;

@end
