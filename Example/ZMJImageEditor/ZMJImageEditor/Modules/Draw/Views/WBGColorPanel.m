//
//  WBGColorPanel.m
//  ZMJImageEditor_Example
//
//  Created by minqin on 2019/5/7.
//  Copyright © 2019 keshiim. All rights reserved.
//

#import "WBGColorPanel.h"
#import "WBGColorfullButton.h"
#import "WBGImageEditor.h"

NSString * const kColorPanNotificaiton = @"kColorPanNotificaiton";

@interface WBGColorPanel ()
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

@implementation WBGColorPanel

+ (CGFloat)fixedHeight
{
    return 50;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.redButton.isUse = YES;
}

- (UIColor *)currentColor
{
    if (_currentColor == nil) {
        _currentColor = ([self.dataSource respondsToSelector:@selector(imageEditorDefaultColor)] && [self.dataSource imageEditorDefaultColor]) ? [self.dataSource imageEditorDefaultColor] : self.redButton.color;
    }
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
    
    for (WBGColorfullButton *button in _colorButtons) {
        if (button == theBtns) {
            button.isUse = YES;
            self.currentColor = theBtns.color;
            [[NSNotificationCenter defaultCenter] postNotificationName:kColorPanNotificaiton object:self.currentColor];
        } else {
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

- (IBAction)onUndoButtonTapped:(UIButton *)sender
{
    if (self.undoButtonTappedBlock)
    {
        self.undoButtonTappedBlock();
    }
}
@end
