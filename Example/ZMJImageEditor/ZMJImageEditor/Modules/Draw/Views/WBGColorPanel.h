//
//  WBGColorPanel.h
//  ZMJImageEditor_Example
//
//  Created by minqin on 2019/5/7.
//  Copyright © 2019 keshiim. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kColorPanelNotificaiton;

@protocol WBGImageEditorDataSource;
typedef void (^WBGUndoButtonTappedBlock)();

@interface WBGColorPanel : UIView
@property (nonatomic, strong, readonly) UIColor *currentColor;
@property (nonatomic, weak) id<WBGImageEditorDataSource> dataSource;
@property (nonatomic, copy) WBGUndoButtonTappedBlock undoButtonTappedBlock;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

+ (CGFloat)fixedHeight;
@end
