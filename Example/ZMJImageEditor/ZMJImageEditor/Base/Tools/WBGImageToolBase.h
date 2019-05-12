//
//  WBGImageToolBase.h
//  CLImageEditorDemo
//
//  Created by Jason on 2017/2/28.
//  Copyright © 2017年 CALACULU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBGImageEditorViewController.h"

typedef void (^WBGImageToolCompletionBlock)(UIImage *image,
                                            NSError *error,
                                            NSDictionary *userInfo);

@interface WBGImageToolBase : NSObject

@property (nonatomic, weak) WBGImageEditorViewController *editor;

- (instancetype)initWithImageEditor:(WBGImageEditorViewController *)editor;

- (void)setup;
- (void)cleanup;
- (void)hideTools:(BOOL)hidden;
- (void)executeWithCompletionBlock:(WBGImageToolCompletionBlock)completionBlock;

- (void)cropToRect:(CGRect)rect;

@end
