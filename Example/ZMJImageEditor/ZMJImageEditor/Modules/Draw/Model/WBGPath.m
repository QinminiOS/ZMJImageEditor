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

+ (instancetype)pathToPoint:(CGPoint)beginPoint pathWidth:(CGFloat)pathWidth
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    bezierPath.lineWidth     = pathWidth;
    bezierPath.lineCapStyle  = kCGLineCapRound;
    bezierPath.lineJoinStyle = kCGLineJoinRound;
    [bezierPath moveToPoint:beginPoint];
    
    WBGPath *path   = [[WBGPath alloc] init];
    path.beginPoint = beginPoint;
    path.pathWidth  = pathWidth;
    path.bezierPath = bezierPath;
    path.pointArray = [NSMutableArray array];
    
    return path;
}

//曲线
- (void)pathLineToPoint:(CGPoint)movePoint;
{
    //判断绘图类型
    [self.pointArray addObject:@(movePoint)];
    
    [self.bezierPath addLineToPoint:movePoint];
    
//    // 贝塞尔曲线优化
//    if (self.pointArray.count <= 5)
//    {
//        if (self.pointArray.count % 5 == 0)
//        {
//            NSInteger lastIndex = self.pointArray.count - 1;
//
//            CGPoint p4 = [self.pointArray[lastIndex] CGPointValue];
//            CGPoint p3 = [self.pointArray[lastIndex-1] CGPointValue];
//            CGPoint p2 = [self.pointArray[lastIndex-2] CGPointValue];
//            CGPoint p1 = [self.pointArray[lastIndex-3] CGPointValue];
//            CGPoint p0 = [self.pointArray[lastIndex-4] CGPointValue];
//
//            p3 = CGPointMake((p2.x + p4.x)/2.0, (p2.y + p4.y)/2.0);
//
//            [self.bezierPath moveToPoint:p0];
//            [self.bezierPath addCurveToPoint:p3 controlPoint1:p1 controlPoint2:p2];
//
//            [self.pointArray replaceObjectAtIndex:lastIndex-1 withObject:@(p3)];
//        }
//    }
//    else
//    {
//        if ((self.pointArray.count - 5) % 3 == 0)
//        {
//            NSInteger lastIndex = self.pointArray.count - 1;
//
//            CGPoint p4 = [self.pointArray[lastIndex] CGPointValue];
//            CGPoint p3 = [self.pointArray[lastIndex-1] CGPointValue];
//            CGPoint p2 = [self.pointArray[lastIndex-2] CGPointValue];
//            CGPoint p1 = [self.pointArray[lastIndex-3] CGPointValue];
//            CGPoint p0 = [self.pointArray[lastIndex-4] CGPointValue];
//
//            p3 = CGPointMake((p2.x + p4.x)/2.0, (p2.y + p4.y)/2.0);
//
//            [self.bezierPath moveToPoint:p0];
//            [self.bezierPath addCurveToPoint:p3 controlPoint1:p1 controlPoint2:p2];
//
//            [self.pointArray replaceObjectAtIndex:lastIndex-1 withObject:@(p3)];
//        }
//    }
}

- (void)drawPath
{
    [self.pathColor set];
    [self.bezierPath stroke];
}

@end
