//
//  UIView+TouchBlock.h
//  ZMJImageEditor_Example
//
//  Created by minqin on 2019/5/9.
//  Copyright © 2019 keshiim. All rights reserved.
//

typedef void (^TBTouchesBeganBlock)(void);
typedef void (^TBTouchesMovedBlock)(void);
typedef void (^TBTouchesEndedBlock)(void);
typedef void (^TBTouchesCancelledBlock)(void);

@interface UIView (TouchBlock)
@property (nonatomic, copy) TBTouchesBeganBlock touchesBeganBlock;
@property (nonatomic, copy) TBTouchesMovedBlock touchesMovedBlock;
@property (nonatomic, copy) TBTouchesEndedBlock touchesEndedBlock;
@property (nonatomic, copy) TBTouchesCancelledBlock touchesCancelledBlock;
@end
