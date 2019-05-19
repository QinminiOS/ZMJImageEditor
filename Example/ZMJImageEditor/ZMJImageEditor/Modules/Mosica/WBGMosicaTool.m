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
#import "Masonry.h"
#import "UIView+TouchBlock.h"

@interface WBGMosicaTool ()
@property (nonatomic, strong) WBGMosicaToolBar *mosicaToolBar;
@property (nonatomic, weak) WBGScratchView *scratchView;
@end

@implementation WBGMosicaTool

- (void)setup
{
    self.scratchView = self.editor.mosicaView;
    self.mosicaToolBar = [WBGMosicaToolBar xx_instantiateFromNib];
    [self.editor.view addSubview:self.mosicaToolBar];
    [self.mosicaToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo([WBGMosicaToolBar fixedHeight]);
        make.bottom.mas_equalTo(self.editor.bottomBar.mas_top).mas_offset(35);
    }];
    
    [self setupActions];
    
    CGFloat height = [WBGMosicaToolBar fixedHeight];
    CGFloat y = HEIGHT_SCREEN - height - [self.editor bottomBarHeight];
    self.mosicaToolBar.frame = CGRectMake(0, y, WIDTH_SCREEN, height);
    
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

- (void)hideTools:(BOOL)hidden
{
    if (hidden)
    {
        self.editor.bottomBar.alpha = 0;
        self.mosicaToolBar.alpha = 0;
    }
    else
    {
        self.editor.bottomBar.alpha = 1.0f;
        self.mosicaToolBar.alpha = 1.0f;
    }
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
    
    [self.scratchView setTouchesBeganBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.editor hiddenTopAndBottomBar:YES animation:YES];
    }];
    
    [self.scratchView setTouchesCancelledBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.editor hiddenTopAndBottomBar:NO animation:YES];
    }];
    
    [self.scratchView setTouchesEndedBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.editor hiddenTopAndBottomBar:NO animation:YES];
    }];
    
    [self.scratchView setTapGestureBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.editor hiddenTopAndBottomBar:!strongSelf.editor.barsHiddenStatus animation:YES];
    }];
    
    self.mosicaToolBar.backButtonClickBlock = ^(UIButton *btn) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.scratchView backToLastDraw];
    };
}

@end
