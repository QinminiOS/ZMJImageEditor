//
//  WBGDrawTool.m
//  CLImageEditorDemo
//
//  Created by Jason on 2017/2/28.
//  Copyright © 2017年 CALACULU. All rights reserved.
//

#import "WBGPath.h"

@interface WBGPath()
@property (nonatomic, strong) UIBezierPath *bezierPath;
@property (nonatomic, assign) CGPoint beginPoint;
@property (nonatomic, assign) CGFloat pathWidth;
@end

@implementation WBGPath

+ (instancetype)pathToPoint:(CGPoint)beginPoint pathWidth:(CGFloat)pathWidth
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    bezierPath.lineWidth     = pathWidth;
    bezierPath.lineCapStyle  = kCGLineCapRound;
    bezierPath.lineJoinStyle = kCGLineJoinRound;
    [bezierPath moveToPoint:beginPoint];
    
    
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineWidth = pathWidth;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.path = bezierPath.CGPath;
    
    WBGPath *path   = [[WBGPath alloc] init];
    path.beginPoint = beginPoint;
    path.pathWidth  = pathWidth;
    path.bezierPath = bezierPath;
    path.shape      = shapeLayer;
    
    return path;
}

//曲线
- (void)pathLineToPoint:(CGPoint)movePoint;
{
    //判断绘图类型
    [self.bezierPath addLineToPoint:movePoint];
    self.shape.path = self.bezierPath.CGPath;
}

- (void)applyTransform:(CGAffineTransform)transform
{
    [self.bezierPath applyTransform:transform];
}

- (void)drawPath
{
    [self.pathColor set];
    [self.bezierPath stroke];
}

@end
