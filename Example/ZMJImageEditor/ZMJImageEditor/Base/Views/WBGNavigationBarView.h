//
//  WBGNavigationBarView.h
//  ZMJImageEditor_Example
//
//  Created by Qinmin on 2019/5/12.
//  Copyright © 2019 keshiim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XXNibBridge.h>

@interface WBGNavigationBarView : UIView<XXNibBridge>
@property (nonatomic, copy) void (^onDoneButtonClickBlock)(UIButton *btn);
@property (nonatomic, copy) void (^onCancelButtonClickBlock)(UIButton *btn);
+ (CGFloat)fixedHeight;
@end
