//
//  colorfullButton.m
//  CLImageEditorDemo
//
//  Created by Jason on 2017/2/27.
//  Copyright © 2017年 CALACULU. All rights reserved.
//

#import "WBGColorfullButton.h"
#import "FrameAccessor.h"

static CGFloat const kButtonSize = 22.0f;
static CGFloat const kButtonLargeSize = 30.0f;

@implementation WBGColorfullButton
{
    UIView *_dotColorView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupUI];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupUI];
}

- (void)setupUI
{
    _dotColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kButtonSize, kButtonSize)];
    _dotColorView.userInteractionEnabled = NO;
    [self addSubview:_dotColorView];
    
    self.backgroundColor = [UIColor clearColor];
    
    [self setIsUse:_isUse];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _dotColorView.center = CGPointMake(self.width/2, self.height/2);
}

- (void)setRadius:(CGFloat)radius
{
    _radius = radius;
    
    _dotColorView.layer.cornerRadius = kButtonSize/2;
    _dotColorView.layer.masksToBounds = YES;
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    _dotColorView.backgroundColor = color;
}

- (void)setIsUse:(BOOL)isUse
{
    _isUse = isUse;
    
    if (!isUse)
    {
        _dotColorView.viewSize = CGSizeMake(kButtonSize, kButtonSize);
        _dotColorView.center = CGPointMake(self.width/2, self.height/2);
        _dotColorView.layer.cornerRadius = kButtonSize/2;
        _dotColorView.backgroundColor = _color;
        _dotColorView.layer.cornerRadius = kButtonSize/2;
        _dotColorView.layer.borderWidth = 2.0f;
        _dotColorView.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    else
    {
        _dotColorView.viewSize = CGSizeMake(kButtonLargeSize, kButtonLargeSize);
        _dotColorView.center = CGPointMake(self.width/2, self.height/2);
        _dotColorView.layer.cornerRadius = kButtonLargeSize/2;
        _dotColorView.backgroundColor = _color;
        _dotColorView.layer.borderWidth = 4.0f;
        _dotColorView.layer.borderColor = [UIColor whiteColor].CGColor;
    }
}

@end
