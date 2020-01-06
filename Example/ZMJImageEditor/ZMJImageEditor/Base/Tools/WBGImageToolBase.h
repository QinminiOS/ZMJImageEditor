//
//  WBGImageToolBase.h
//  CLImageEditorDemo
//
//  Created by Jason on 2017/2/28.
//  Copyright © 2017年 CALACULU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBGImageEditorViewController.h"

@interface WBGImageToolBase : NSObject
@property (nonatomic, weak) WBGImageEditorViewController *editor;

- (instancetype)initWithImageEditor:(WBGImageEditorViewController *)editor;

- (void)setup;
- (void)cleanup;
- (UIView *)drawView;

- (void)hideTools:(BOOL)hidden;
@end
