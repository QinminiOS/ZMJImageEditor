//
//  ScratchCardView.m
//  RGBTool
//
//  Created by admin on 23/08/2017.
//  Copyright © 2017 gcg. All rights reserved.
//

#import "WBGScratchView.h"
#import "WBGPath.h"
#import "WBGMosicaPath.h"

@interface WBGScratchView ()

@property (nonatomic, strong) UIImageView *surfaceImageView;
@property (nonatomic, strong) CALayer *imageLayer;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) WBGMosicaPath *mosicaPath;
@end

@implementation WBGScratchView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.surfaceImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.surfaceImageView];
        
        self.imageLayer = [CALayer layer];
        self.imageLayer.frame = self.bounds;
        [self.layer addSublayer:self.imageLayer];
        
        self.shapeLayer = [CAShapeLayer layer];
        self.shapeLayer.frame = self.bounds;
        self.shapeLayer.lineCap = kCALineCapRound;
        self.shapeLayer.lineJoin = kCALineJoinRound;
        self.shapeLayer.lineWidth = 20;
        self.shapeLayer.strokeColor = [UIColor blueColor].CGColor;
        self.shapeLayer.fillColor = nil;//此处必须设为nil，否则后边添加addLine的时候会自动填充

        self.imageLayer.mask = self.shapeLayer;
        
        self.mosicaPath = [WBGMosicaPath new];
    }
    
    return self;
}

- (void)setMosaicImage:(UIImage *)mosaicImage
{
    _mosaicImage = mosaicImage;
    self.imageLayer.contents = (id)mosaicImage.CGImage;
}

- (void)setSurfaceImage:(UIImage *)surfaceImage
{
    _surfaceImage = surfaceImage;
    self.surfaceImageView.image = surfaceImage;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self.mosicaPath beginNewDraw:point];
    
    CGPathRef path = [self.mosicaPath makePath];
    self.shapeLayer.path = path;
    CGPathRelease(path);
    path = NULL;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self.mosicaPath addLineToPoint:point];
    
    CGPathRef path = [self.mosicaPath makePath];
    self.shapeLayer.path = path;
    CGPathRelease(path);
    path = NULL;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
}

- (void)backToLastDraw
{
    [self.mosicaPath backToLastDraw];
    CGPathRef path = [self.mosicaPath makePath];
    self.shapeLayer.path = path;
    CGPathRelease(path);
    path = NULL;
}

@end
