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
@property (nonatomic, strong) WBGScratchView *scratchView;
@end

@implementation WBGMosicaTool

- (void)setup
{
    self.mosicaToolBar = [WBGMosicaToolBar xx_instantiateFromNib];
    [self.editor.view addSubview:self.mosicaToolBar];
    
    UIImage *originImage = self.editor.originImage;
    WBGScratchView *scratchView = [[WBGScratchView alloc] initWithFrame:self.editor.mosicaView.bounds];
    scratchView.surfaceImage = originImage;
    scratchView.mosaicImage = [XRGBTool getMosaicImageWith:originImage level:0];
    [self.editor.mosicaView addSubview:scratchView];
    self.scratchView = scratchView;
}

- (void)cleanup
{
    [self.mosicaToolBar removeFromSuperview];
}

- (void)executeWithCompletionBlock:(WBGImageToolCompletionBlock)completionBlock
{
    
}

@end
