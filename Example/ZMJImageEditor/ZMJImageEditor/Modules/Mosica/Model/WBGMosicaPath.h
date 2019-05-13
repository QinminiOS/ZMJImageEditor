//
//  WBGMosicaPath.h
//  ZMJImageEditor_Example
//
//  Created by minqin on 2019/5/9.
//  Copyright © 2019 keshiim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBGMosicaPath : NSObject

// 开始新的绘制
- (void)beginNewDraw:(CGPoint)point;
- (void)addLineToPoint:(CGPoint)point;

- (void)backToLastDraw;

- (void)transformToRect:(CGRect)rect angle:(NSInteger)angle;

// 生成path, 需要 CGPathRelease
- (CGPathRef)makePath;

@end
