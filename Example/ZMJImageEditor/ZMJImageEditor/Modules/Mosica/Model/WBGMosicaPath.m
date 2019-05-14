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
