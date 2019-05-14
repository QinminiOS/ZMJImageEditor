//
//  WBGColorPanel.m
//  ZMJImageEditor_Example
//
//  Created by minqin on 2019/5/7.
//  Copyright © 2019 keshiim. All rights reserved.
//

#import "WBGTextColorPanel.h"
#import "WBGColorfullButton.h"
#import "WBGImageEditor.h"

@interface WBGTextColorPanel ()
@property (strong, nonatomic) UIColor *currentColor;
@property (weak, nonatomic) IBOutlet WBGColorfullButton *redButton;
@property (weak, nonatomic) IBOutlet WBGColorfullButton *orangeButton;
@property (weak, nonatomic) IBOutlet WBGColorfullButton *yellowButton;
@property (weak, nonatomic) IBOutlet WBGColorfullButton *greenButton;
@property (weak, nonatomic) IBOutlet WBGColorfullButton *blueButton;
@property (weak, nonatomic) IBOutlet WBGColorfullButton *pinkButton;
@property (weak, nonatomic) IBOutlet WBGColorfullButton *whiteButton;

@property (strong, nonatomic) IBOutletCollection(WBGColorfullButton) NSArray *colorButtons;
@end

@implementation WBGTextColorPanel

+ (CGFloat)fixedHeight
{
    return 50;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.redButton.isUse = YES;
    self.currentColor = self.redButton.color;
}

- (UIColor *)currentColor
{
    return _currentColor;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)panSelectColor:(UIPanGestureRecognizer *)recognizer
{
    
    NSLog(@"recon = %@", NSStringFromCGPoint([recognizer translationInView:self]));
}

- (IBAction)buttonAction:(UIButton *)sender
{
    WBGColorfullButton *theBtns = (WBGColorfullButton *)sender;
    
    for (WBGColorfullButton *button in _colorButtons)
    {
        if (button == theBtns)
        {
            button.isUse = YES;
            self.currentColor = theBtns.color;
            
            if (self.onTextColorChange)
            {
                self.onTextColorChange(self.currentColor);
            }
        }
        else
        {
            button.isUse = NO;
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    NSLog(@"point: %@", NSStringFromCGPoint([touch locationInView:self]));
    NSLog(@"view=%@", touch.view);
    CGPoint touchPoint = [touch locationInView:self];
    for (WBGColorfullButton *button in _colorButtons) {
        CGRect rect = [button convertRect:button.bounds toView:self];
        if (CGRectContainsPoint(rect, touchPoint) && button.isUse == NO) {
            [self buttonAction:button];
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    //NSLog(@"move->point: %@", NSStringFromCGPoint([touch locationInView:self]));
    CGPoint touchPoint = [touch locationInView:self];
    
    for (WBGColorfullButton *button in _colorButtons) {
        CGRect rect = [button convertRect:button.bounds toView:self];
        if (CGRectContainsPoint(rect, touchPoint) && button.isUse == NO) {
            [self buttonAction:button];
        }
    }
}

@end
