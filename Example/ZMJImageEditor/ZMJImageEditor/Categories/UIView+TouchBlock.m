//
//  UIView+TouchBlock.m
//  ZMJImageEditor_Example
//
//  Created by minqin on 2019/5/9.
//  Copyright © 2019 keshiim. All rights reserved.
//

#import "UIView+TouchBlock.h"
#import <objc/runtime.h>

@implementation UIView (TouchBlock)

- (void)setTouchesBeganBlock:(TBTouchesBeganBlock)touchesBeganBlock
{
    objc_setAssociatedObject(self, @selector(touchesBeganBlock), touchesBeganBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (TBTouchesBeganBlock)touchesBeganBlock
{
    return objc_getAssociatedObject(self, @selector(touchesBeganBlock));
}

- (void)setTouchesMovedBlock:(TBTouchesMovedBlock)touchesMovedBlock
{
    objc_setAssociatedObject(self, @selector(touchesMovedBlock), touchesMovedBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (TBTouchesMovedBlock)touchesMovedBlock
{
    return objc_getAssociatedObject(self, @selector(touchesMovedBlock));
}

- (void)setTouchesEndedBlock:(TBTouchesEndedBlock)touchesEndedBlock
{
    objc_setAssociatedObject(self, @selector(touchesEndedBlock), touchesEndedBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (TBTouchesEndedBlock)touchesEndedBlock
{
    return objc_getAssociatedObject(self, @selector(touchesEndedBlock));
}

- (void)setTouchesCancelledBlock:(TBTouchesCancelledBlock)touchesCancelledBlock
{
    objc_setAssociatedObject(self, @selector(touchesCancelledBlock), touchesCancelledBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (TBTouchesCancelledBlock)touchesCancelledBlock
{
    return objc_getAssociatedObject(self, @selector(touchesCancelledBlock));
}

- (void)setTapGestureBlock:(TBTapGestureBlock)tapGestureBlock
{
    objc_setAssociatedObject(self, @selector(tapGestureBlock), tapGestureBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (TBTapGestureBlock)tapGestureBlock
{
    return objc_getAssociatedObject(self, @selector(tapGestureBlock));
}

@end
