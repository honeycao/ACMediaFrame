//
//  ACShowMediaTypeView.h
//
//  Created by caoyq on 16/12/2.
//  Copyright © 2016年 SnSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedIndex)(NSInteger itemIndex);

///底部弹出4个选项，相册、相机等。只负责回传选中的下标
@interface ACShowMediaTypeView : UIView

- (void)selectedIndexBlock: (SelectedIndex)selectedBlock;

- (void)show;

@end
