//
//  WBGMosicaPath.m
//  ZMJImageEditor_Example
//
//  Created by minqin on 2019/5/9.
//  Copyright © 2019 keshiim. All rights reserved.
//

#import "WBGMosicaPath.h"

@interface WBGPathItem : NSObject
@property (nonatomic, assign) CGMutablePathRef path;
@end

@implementation WBGPathItem
- (void)dealloc
{
    if (_path != NULL) { CGPathRelease(_path); _path = NULL; };
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
    item.path = CGPathCreateMutable();
    [self.pathArray addObject:item];
    
    [self addPoint:point];
}

- (void)addPoint:(CGPoint)point
{
    WBGPathItem *item = [self.pathArray lastObject];
    CGPathMoveToPoint(item.path, nil, point.x, point.y);
}

- (void)addLineToPoint:(CGPoint)point
{
    WBGPathItem *item = [self.pathArray lastObject];
    CGPathAddLineToPoint(item.path, nil, point.x, point.y);
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
        CGPathAddPath(pathRef, nil, pathItem.path);
    }
    
    return pathRef;
}

@end
