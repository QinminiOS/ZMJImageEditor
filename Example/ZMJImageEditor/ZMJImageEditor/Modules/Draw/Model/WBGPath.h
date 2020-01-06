//
//  WBGDrawTool.h
//  CLImageEditorDemo
//
//  Created by Jason on 2017/2/28.
//  Copyright © 2017年 CALACULU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBGPath : NSObject
@property (nonatomic, strong) UIColor *pathColor;//画笔颜色

+ (instancetype)pathToPoint:(CGPoint)beginPoint pathWidth:(CGFloat)pathWidth;

- (void)pathLineToPoint:(CGPoint)movePoint; // 画
- (void)drawPath; // 绘制
@end
