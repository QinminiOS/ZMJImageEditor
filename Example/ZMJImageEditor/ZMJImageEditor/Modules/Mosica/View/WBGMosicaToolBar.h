//
//  WBGMosicaToolBar.h
//  ZMJImageEditor_Example
//
//  Created by minqin on 2019/5/8.
//  Copyright © 2019 keshiim. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WBGMosicaStyle)
{
    WBGMosicaStyleNormal,
};

typedef void (^WBGMosicaToolClickBlock)(UIButton *btn);
typedef void (^WBGMosicaStyleClickBlock)(UIButton *btn, WBGMosicaStyle style);

@interface WBGMosicaToolBar : UIView
@property (nonatomic, copy) WBGMosicaToolClickBlock backButtonClickBlock;
@property (nonatomic, copy) WBGMosicaStyleClickBlock mosicaStyleButtonClickBlock;

+ (CGFloat)fixedHeight;

@end
