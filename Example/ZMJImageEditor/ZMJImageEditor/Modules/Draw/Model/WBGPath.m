//
//  WBGDrawTool.m
//  CLImageEditorDemo
//
//  Created by Jason on 2017/2/28.
//  Copyright © 2017年 CALACULU. All rights reserved.
//

#import "WBGPath.h"
#import "WBGChatMacros.h"

@interface WBGPath()
@property (nonatomic, strong) UIBezierPath *bezierPath;
@property (nonatomic, assign) CGPoint beginPoint;
@property (nonatomic, assign) CGFloat pathWidth;
@property (nonatomic, strong) NSMutableArray<NSValue *> *pointArray;
@end

@implementation WBGPath

static CGPoint CGPointRotate(CGPoint point, CGPoint anchorPoint, CGFloat angle)
{
    CGPoint p = CGPointZero;
    if (angle == 0 || angle == 360)
    {
        p = point;
    }
    else if (angle == -90)
    {
        p = CGPointMake(point.y, anchorPoint.x * 2 - point.x);
    }
    else if (angle == -180)
    {
        p = CGPointMake(point.x, anchorPoint.y * 2 - point.y);
    }
    else if (angle == -270)
    {
        p = CGPointMake(anchorPoint.x * 2 - point.x, anchorPoint.y * 2 - point.y);
    }
    
    return p;
}

+ (instancetype)pathToPoint:(CGPoint)beginPoint pathWidth:(CGFloat)pathWidth
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    bezierPath.lineWidth     = pathWidth;
    bezierPath.lineCapStyle  = kCGLineCapRound;
    bezierPath.lineJoinStyle = kCGLineJoinRound;
    [bezierPath moveToPoint:beginPoint];
    
    
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.contentsScale = [UIScreen mainScreen].scale;
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
    path.pointArray = [NSMutableArray array];
    
    return path;
}

//曲线
- (void)pathLineToPoint:(CGPoint)movePoint;
{
    //判断绘图类型
    [self.pointArray addObject:@(movePoint)];
    
    [self.bezierPath addLineToPoint:movePoint];
    self.shape.path = self.bezierPath.CGPath;
}

- (void)transformToRect:(CGRect)rect angle:(CGFloat)angle rotateCenter:(CGPoint)rotateCenter;
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    bezierPath.lineWidth     = self.pathWidth;
    bezierPath.lineCapStyle  = kCGLineCapRound;
    bezierPath.lineJoinStyle = kCGLineJoinRound;
    
    self.beginPoint = CGPointRotate(self.beginPoint, rotateCenter, angle);
    self.beginPoint = CGRectConvertPointToRect(self.beginPoint, rect);
    
    [bezierPath moveToPoint:self.beginPoint];
    NSMutableArray<NSValue *> *transArray = [NSMutableArray array];
    
    for (NSValue *value in self.pointArray)
    {
        CGPoint origion = [value CGPointValue];
        CGPoint newPoint = CGPointRotate(origion, rotateCenter, angle);
        CGPoint trans = CGRectConvertPointToRect(newPoint, rect);
        
        [bezierPath addLineToPoint:trans];
        [transArray addObject:@(trans)];
        
    }
    
    self.pointArray = transArray;
    self.bezierPath = bezierPath;
}

- (void)drawPath
{
    [self.pathColor set];
    [self.bezierPath stroke];
}

@end
