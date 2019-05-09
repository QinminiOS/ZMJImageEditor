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

@interface WBGMosicaTool ()
@property (nonatomic, strong) WBGMosicaToolBar *mosicaToolBar;
@property (nonatomic, weak) WBGScratchView *scratchView;
@end

@implementation WBGMosicaTool

- (void)setup
{
    self.mosicaToolBar = [WBGMosicaToolBar xx_instantiateFromNib];
    [self.editor.view addSubview:self.mosicaToolBar];
    
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

@end
