//
//  WBGMosicaPath.m
//  ZMJImageEditor_Example
//
//  Created by minqin on 2019/5/9.
//  Copyright © 2019 keshiim. All rights reserved.
//

#import "WBGMosicaPath.h"
#import "WBGChatMacros.h"

@interface WBGPathItem : NSObject
@property (nonatomic, assign) CGPoint beginPoint;
@property (nonatomic, strong) NSMutableArray<NSValue *> *pointArray;
@property (nonatomic, strong) UIBezierPath *path;
- (void)transformToRect:(CGRect)rect angle:(NSInteger)angle;
@end

@implementation WBGPathItem
- (instancetype)init
{
    if (self = [super init])
    {
        _pointArray = [NSMutableArray array];
    }
    
    return self;
}

- (void)transformToRect:(CGRect)rect angle:(NSInteger)angle
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    self.beginPoint = CGRectConvertPointToRect(self.beginPoint, rect);
    [bezierPath moveToPoint:self.beginPoint];
    
    NSMutableArray<NSValue *> *transArray = [NSMutableArray array];
    for (NSValue *value in self.pointArray)
    {
        CGPoint p = [value CGPointValue];
        CGPoint trans = CGRectConvertPointToRect(p, rect);
        
        [bezierPath addLineToPoint:trans];
        [transArray addObject:@(trans)];
        
    }
    
    self.path = bezierPath;
    self.pointArray = transArray;
}
@end


@interface WBGMosicaPath ()
@property (nonatomic, strong) NSMutableArray<WBGPathItem *> *pathArray;
@end

@implementation WBGMosicaPath

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _pathArray = [NSMutableArray array];
    }
    
    return self;
}

- (void)beginNewDraw:(CGPoint)point
{
    WBGPathItem *item = [WBGPathItem new];
    item.beginPoint = point;
    item.path = [UIBezierPath bezierPath];
    [self.pathArray addObject:item];
    
    [self addPoint:point];
}

- (void)addPoint:(CGPoint)point
{
    WBGPathItem *item = [self.pathArray lastObject];
    [item.pointArray addObject:@(point)];
    [item.path moveToPoint:point];
}

- (void)addLineToPoint:(CGPoint)point
{
    WBGPathItem *item = [self.pathArray lastObject];
    [item.pointArray addObject:@(point)];
    [item.path addLineToPoint:point];
}

- (void)backToLastDraw
{
    [self.pathArray removeLastObject];
}

- (void)transformToRect:(CGRect)rect angle:(NSInteger)angle
{
    for (WBGPathItem *item in self.pathArray)
    {
        [item transformToRect:rect angle:angle];
    }
}

- (CGPathRef)makePath
{
    CGMutablePathRef pathRef = CGPathCreateMutable();
    
    for (WBGPathItem *pathItem in _pathArray)
    {
        CGPathAddPath(pathRef, nil, pathItem.path.CGPath);
    }
    
    return pathRef;
}

@end
