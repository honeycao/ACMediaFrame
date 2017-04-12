# ACAlertController

At iOS 8.0 later, we use UIAlertController, it's not friendly, so we  replace it with ACAlertController. 



------

![ACAlertControllerExampleGif](https://github.com/honeycao/ACAlertController/blob/master/ACAlertControllerExampleGif.gif)



## Requirements

* iOS 7.0 or later
* Xcode 7.0 or later

## Architecture

* [How to use](#use)
* [Details (See the example program ACAlertControllerExample for details)](#Details)
* [Custom](#Custom)
* [Hope](#hope)



## <a id="use"></a>How to use

* Use CocoaPods:
  - waiting...
* Manual import：
  - Drag All files in the `ACAlertController` folder to project
  - Import the main file：`#import "ACAlertController.h"`

## <a id="Details"></a>Details (See the example program ACAlertControllerExample for details)

```objective-c
//1、初始化
ACAlertController *action2 = [[ACAlertController alloc] initWithActionSheetTitles:self.titles cancelTitle:self.cancelTitle];
    
//2、获取点击事件
[action2 clickActionButton:^(NSInteger index) {
    NSLog(@"selected item = %ld", (long)index);
}];
    
//3、显示
[action2 show];
```

## <a id="Custom"></a>Custom

* `cancelButtonTextColor`  

* `cancelButtonTextFont`

* `actionButtonsTextColor`

* `actionButtonsTextFont`

* set action button text color with index

  ```
  - (void)configureActionButtonTextColor: (UIColor *)color index: (NSInteger)index;
  ```

  ​

* set action button text font with index.

  ```
  - (void)configureActionButtonTextFont:(UIFont *)font index:(NSInteger)index;
  ```

  ​

## <a id="hope"></a>Hope

- If you have any questions during the process or want more interfaces to customize，you can [issues me](https://github.com/honeycao/ACAlertController/issues/new)
- If you feel slightly discomfort in use, please contact me QQ:331864805
- If you support me, please giving me star

## Licenses
All source code is licensed under the MIT License.
