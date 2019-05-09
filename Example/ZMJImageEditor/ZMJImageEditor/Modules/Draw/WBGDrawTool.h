//
//  WBGDrawTool.h
//  CLImageEditorDemo
//
//  Created by Jason on 2017/2/28.
//  Copyright © 2017年 CALACULU. All rights reserved.
//

#import "WBGImageToolBase.h"
#import "WBGPath.h"

@interface WBGDrawTool : WBGImageToolBase
@property (nonatomic, copy) void (^drawToolStatus)(BOOL canPrev);
@property (nonatomic, copy) void (^drawingCallback)(BOOL isDrawing);
@property (nonatomic, copy) void (^drawingDidTap)(void);
@property (nonatomic, strong) NSMutableArray<WBGPath *> *allLineMutableArray;
@property (nonatomic, assign) CGFloat pathWidth;
//撤销
- (void)backToLastDraw;
- (void)drawLine;
@end
