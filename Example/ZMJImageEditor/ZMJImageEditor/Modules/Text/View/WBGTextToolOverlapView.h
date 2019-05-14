//
//  WBGTextToolView.h
//  CLImageEditorDemo
//
//  Created by Jason on 2017/3/2.
//  Copyright © 2017年 CALACULU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBGTextToolOverlapView.h"

@interface WBGTextToolOverlapView : UIView
@property (nonatomic, copy  ) NSString *text;
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIImage *image;
@end
