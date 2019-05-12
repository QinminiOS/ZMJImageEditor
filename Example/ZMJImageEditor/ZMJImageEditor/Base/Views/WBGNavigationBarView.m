//
//  WBGNavigationBarView.m
//  ZMJImageEditor_Example
//
//  Created by Qinmin on 2019/5/12.
//  Copyright © 2019 keshiim. All rights reserved.
//

#import "WBGNavigationBarView.h"

@implementation WBGNavigationBarView

- (IBAction)onCancelButtonTapped:(UIButton *)sender
{
    if (self.onCancelButtonClickBlock)
    {
        self.onCancelButtonClickBlock(sender);
    }
}

- (IBAction)onDoneButtonTapped:(UIButton *)sender
{
    if (self.onDoneButtonClickBlock)
    {
        self.onDoneButtonClickBlock(sender);
    }
}
@end
