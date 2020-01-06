//
//  WBGColorPanel.h
//  ZMJImageEditor_Example
//
//  Created by minqin on 2019/5/7.
//  Copyright © 2019 keshiim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XXNibBridge.h>

@interface WBGTextColorPanel : UIView<XXNibBridge>
@property (nonatomic, strong, readonly) UIColor *currentColor;
@property (nonatomic, copy) void (^onTextColorChange)(UIColor *color);

+ (CGFloat)fixedHeight;
@end
