//
//  WBGTextTool.m
//  CLImageEditorDemo
//
//  Created by Jason on 2017/3/1.
//  Copyright © 2017年 CALACULU. All rights reserved.
//

#import "WBGMosicaTool.h"
#import "WBGMosicaToolBar.h"
#import "WBGScratchView.h"
#import "XXNibBridge.h"
#import "XRGBTool.h"
#import "WBGChatMacros.h"

@interface WBGMosicaTool ()
@property (nonatomic, strong) WBGMosicaToolBar *mosicaToolBar;
@property (nonatomic, weak) WBGScratchView *scratchView;
@end

@implementation WBGMosicaTool

- (void)setup
{
    self.mosicaToolBar = [WBGMosicaToolBar xx_instantiateFromNib];
    [self.editor.view addSubview:self.mosicaToolBar];
    [self setupActions];
    
    CGFloat height = [WBGMosicaToolBar fixedHeight];
    CGFloat y = HEIGHT_SCREEN - height - [self.editor bottomBarHeight];
    self.mosicaToolBar.frame = CGRectMake(0, y, WIDTH_SCREEN, height);
    
    self.scratchView = self.editor.mosicaView;
    if (!self.scratchView.mosaicImage)
    {
        self.scratchView.mosaicImage = [XRGBTool getMosaicImageWith:self.editor.originImage level:0];
    }
    
    self.editor.drawingView.userInteractionEnabled = NO;
}

- (void)cleanup
{
    [self.mosicaToolBar removeFromSuperview];
    
    self.editor.drawingView.userInteractionEnabled = YES;
}

- (void)executeWithCompletionBlock:(WBGImageToolCompletionBlock)completionBlock
{
    
}

- (void)setupActions
{
//  目前只有一种样式不用
//    __weak __typeof(self)weakSelf = self;
//    self.mosicaToolBar.mosicaStyleButtonClickBlock = ^(UIButton *btn, WBGMosicaStyle style)
//    {
//        __strong __typeof(weakSelf) strongSelf = weakSelf;
//    };
    
    __weak __typeof(self)weakSelf = self;
    self.mosicaToolBar.backButtonClickBlock = ^(UIButton *btn) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.scratchView backToLastDraw];
    };
}

@end
