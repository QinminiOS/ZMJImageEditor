//
//  WBGDrawView.h
//  ZMJImageEditor_Example
//
//  Created by minqin on 2019/5/14.
//  Copyright © 2019 keshiim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBGDrawView : UIView
@property (nonatomic, assign) CGSize originSize;
@property (nonatomic, copy) void (^drawViewBlock)(CGContextRef ctx);
- (void)setNeedDraw;
@end
