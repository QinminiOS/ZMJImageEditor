//
//  WBGDrawView.m
//  ZMJImageEditor_Example
//
//  Created by minqin on 2019/5/14.
//  Copyright © 2019 keshiim. All rights reserved.
//

#import "WBGDrawView.h"

@implementation WBGDrawView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    
    return self;
}

+ (Class)layerClass
{
    return [CAShapeLayer class];
}

- (void)drawRect:(CGRect)rect
{
    if (self.drawViewBlock)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //去掉锯齿
        CGContextSetAllowsAntialiasing(context, true);
        CGContextSetShouldAntialias(context, true);
        
        self.drawViewBlock(context);
    }
}

@end
