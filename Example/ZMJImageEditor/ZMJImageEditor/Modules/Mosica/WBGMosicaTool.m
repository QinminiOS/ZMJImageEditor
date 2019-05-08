//
//  WBGTextTool.m
//  CLImageEditorDemo
//
//  Created by Jason on 2017/3/1.
//  Copyright © 2017年 CALACULU. All rights reserved.
//

#import "WBGMosicaTool.h"
#import "WBGMosicaToolBar.h"
#import "XXNibBridge.h"

@interface WBGMosicaTool ()
@property (nonatomic, strong) WBGMosicaToolBar *mosicaToolBar;
@end

@implementation WBGMosicaTool

- (void)setup
{
    self.mosicaToolBar = [WBGMosicaToolBar xx_instantiateFromNib];
    [self.editor.view addSubview:self.mosicaToolBar];
}

- (void)cleanup
{
    [self.mosicaToolBar removeFromSuperview];
}

- (void)executeWithCompletionBlock:(WBGImageToolCompletionBlock)completionBlock
{
    
}

@end
