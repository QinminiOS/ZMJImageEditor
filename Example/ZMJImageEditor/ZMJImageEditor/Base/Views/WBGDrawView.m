//
//  WBGDrawView.m
//  ZMJImageEditor_Example
//
//  Created by minqin on 2019/5/14.
//  Copyright © 2019 keshiim. All rights reserved.
//

#import "WBGDrawView.h"

@implementation WBGDrawView

+ (Class)layerClass
{
    return [CAShapeLayer class];
}

+ (dispatch_queue_t)drawQueue
{
    static dispatch_queue_t _drawQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _drawQueue = dispatch_queue_create("com.image.editor.queue", DISPATCH_QUEUE_SERIAL);
    });
    
    return _drawQueue;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        self.layer.contentsScale = [[UIScreen mainScreen] scale];
    }
    
    return self;
}

- (void)setNeedDraw
{
    CGSize originSize = self.originSize;
    dispatch_async([self.class drawQueue], ^{
        [self draw:originSize];
    });
}

- (void)draw:(CGSize)size
{
    if (self.drawViewBlock)
    {
        CGFloat scale = [[UIScreen mainScreen] scale];
        UIGraphicsBeginImageContextWithOptions(size, NO, scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //去掉锯齿
        CGContextSetAllowsAntialiasing(context, true);
        CGContextSetShouldAntialias(context, true);
        
        self.drawViewBlock(context);
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.layer.contents = (__bridge id _Nullable)(image.CGImage);
        });
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}

@end
