//
//  WBGImageEditorViewController.h
//  CLImageEditorDemo
//
//  Created by Jason on 2017/2/27.
//  Copyright © 2017年 CALACULU. All rights reserved.
//

#import "WBGImageEditor.h"
#import "WBGColorPanel.h"
#import "WBGScratchView.h"

typedef NS_ENUM(NSUInteger, WBGEditorMode)
{
    WBGEditorModeNone,
    WBGEditorModeDraw,
    WBGEditorModeText,
    WBGEditorModeClip,
    WBGEditorModePaper,
    WBGEditorModeMosica
};

@interface WBGImageEditorViewController : WBGImageEditor

@property (nonatomic, copy, readonly) UIImage *originImage;

@property (weak, nonatomic, readonly) IBOutlet UIImageView *imageView;
@property (weak, nonatomic, readonly) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic, readonly) WBGScratchView *mosicaView;
@property (strong, nonatomic, readonly) UIImageView *drawingView;

@property (nonatomic, strong, readonly) WBGColorPanel *colorPanel;
@property (nonatomic, assign, readonly) WBGEditorMode currentMode;

- (CGFloat)bottomBarHeight;

- (void)resetCurrentTool;

- (void)editTextAgain;

- (void)hiddenTopAndBottomBar:(BOOL)isHide
                    animation:(BOOL)animation;
@end
