//
//  WBGMosicaToolBar.m
//  ZMJImageEditor_Example
//
//  Created by minqin on 2019/5/8.
//  Copyright © 2019 keshiim. All rights reserved.
//

#import "WBGMosicaToolBar.h"

@interface WBGMosicaToolBar ()
@property (weak, nonatomic) IBOutlet UIButton *masicNormal;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@end

@implementation WBGMosicaToolBar

+ (CGFloat)fixedHeight
{
    return 55;
}

- (IBAction)onMasicNormalButtonTapped:(UIButton *)sender
{
    if (self.mosicaStyleButtonClickBlock)
    {
        self.mosicaStyleButtonClickBlock(sender, WBGMosicaStyleNormal);
    }
}

- (IBAction)onBackButtonTapped:(UIButton *)sender
{
    if (self.backButtonClickBlock)
    {
        self.backButtonClickBlock(sender);
    }
}

@end
