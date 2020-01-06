//
//  WBGView.m
//  CYMini
//
//  Created by minqin on 2019/6/26.
//  Copyright © 2019 4c. All rights reserved.
//

#import "WBGView.h"

@implementation WBGView

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.touchesEndedBlock)
    {
        self.touchesEndedBlock();
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.touchesBeganBlock)
    {
        self.touchesBeganBlock();
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.touchesMovedBlock)
    {
        self.touchesMovedBlock();
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.touchesCancelledBlock)
    {
        self.touchesCancelledBlock();
    }
}

@end
