//
//  WBGTextTool.h
//  CLImageEditorDemo
//
//  Created by Jason on 2017/3/1.
//  Copyright © 2017年 CALACULU. All rights reserved.
//

#import "WBGImageToolBase.h"
#import "YYText.h"
#import "WBGTextColorPanel.h"

@class WBGTextView;

@interface WBGTextTool : WBGImageToolBase
@property (nonatomic, copy) void(^dissmissTextTool)(NSString *currentText);//, BOOL isEditAgain);
@property (nonatomic, strong) WBGTextView *textView;
@property (nonatomic, assign) BOOL isEditAgain;
@property (nonatomic, copy)   void(^editAgainCallback)(NSString *text);
- (void)hideTextBorder;
@end


@interface WBGTextView : UIView
@property (nonatomic, strong) UIView *effectView;
@property (nonatomic, copy) void(^dissmissTextTool)(NSString *currentText, BOOL isUse);//, BOOL isEditAgain);
@property (nonatomic, strong) YYTextView *textView;
@property (nonatomic, weak) WBGTextColorPanel *colorPanel;
@end
