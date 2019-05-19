//
//  WBGDrawTool.m
//  CLImageEditorDemo
//
//  Created by Jason on 2017/2/28.
//  Copyright © 2017年 CALACULU. All rights reserved.
//

#import "WBGDrawTool.h"
#import "WBGImageEditorGestureManager.h"
#import "WBGTextToolView.h"
#import "WBGColorPanel.h"
#import "Masonry.h"

@interface WBGDrawTool ()
@property (nonatomic, weak) WBGDrawView *drawingView;
@property (nonatomic, assign) CGSize originalImageSize;
@property (nonatomic, weak) WBGColorPanel *colorPanel;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@end

@implementation WBGDrawTool

- (instancetype)initWithImageEditor:(WBGImageEditorViewController *)editor
{
    self = [super init];
    
    if(self)
    {
        self.editor = editor;
        self.allLineMutableArray = [NSMutableArray new];
        self.drawingView = self.editor.drawingView;
        
        WBGColorPanel *colorPanel = [WBGColorPanel xx_instantiateFromNib];
        colorPanel.backButton.alpha = 0.5f;
        [editor.view addSubview:colorPanel];
        self.colorPanel = colorPanel;
        [colorPanel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo([WBGColorPanel fixedHeight]);
            make.bottom.mas_equalTo(editor.bottomBar.mas_top).mas_offset(35);
        }];
        
        [self setupActions];
    }
    
    return self;
}

- (void)setupActions
{
    __weak WBGDrawTool *weakSelf = self;
    [self.colorPanel setUndoButtonTappedBlock:
    ^{
        __strong WBGDrawTool *strongSelf = weakSelf;
        [strongSelf backToLastDraw];
        
        if (strongSelf.allLineMutableArray.count > 0)
        {
            strongSelf.colorPanel.backButton.alpha = 1.0f;
        }
        else
        {
            strongSelf.colorPanel.backButton.alpha = 0.5f;
        }
    }];
    
    self.drawToolStatus = ^(BOOL canPrev)
    {
        //if (canPrev) {
        //    weakSelf.undoButton.hidden = NO;
        //} else {
        //    weakSelf.undoButton.hidden = YES;
        //}
    };
    
    self.drawingCallback = ^(BOOL isDrawing)
    {
         __strong WBGDrawTool *strongSelf = weakSelf;
        [strongSelf.editor hiddenTopAndBottomBar:isDrawing animation:YES];
    };
    
    self.drawingDidTap =
    ^{
         __strong WBGDrawTool *strongSelf = weakSelf;
        [strongSelf.editor hiddenTopAndBottomBar:!strongSelf.editor.barsHiddenStatus animation:YES];
    };
    
    [self.drawingView setDrawViewBlock:^(CGContextRef ctx)
    {
        __strong WBGDrawTool *strongSelf = weakSelf;
        for (WBGPath *path in strongSelf.allLineMutableArray)
        {
            [path drawPath];
        }
        
        if (strongSelf.allLineMutableArray.count > 0)
        {
            strongSelf.colorPanel.backButton.alpha = 1.0f;
        }
        else
        {
            strongSelf.colorPanel.backButton.alpha = 0.5f;
        }
    }];
}

#pragma mark - implementation 重写父方法
- (void)setup
{
    //初始化一些东西
    self.originalImageSize = self.editor.imageView.image.size;
    self.colorPanel.hidden = NO;
    
    //滑动手势
    if (!self.panGesture)
    {
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(drawingViewDidPan:)];
        self.panGesture.delegate = [WBGImageEditorGestureManager instance];
        self.panGesture.maximumNumberOfTouches = 1;
    }
    
    //点击手势
    if (!self.tapGesture)
    {
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(drawingViewDidTap:)];
        self.tapGesture.delegate = [WBGImageEditorGestureManager instance];
        self.tapGesture.numberOfTouchesRequired = 1;
        self.tapGesture.numberOfTapsRequired = 1;
        
    }
    
    [_drawingView addGestureRecognizer:self.panGesture];
    [_drawingView addGestureRecognizer:self.tapGesture];
    _drawingView.userInteractionEnabled = YES;
    _drawingView.layer.shouldRasterize = YES;
    _drawingView.layer.minificationFilter = kCAFilterTrilinear;
    
    self.editor.imageView.userInteractionEnabled = YES;
    self.editor.scrollView.panGestureRecognizer.minimumNumberOfTouches = 2;
    self.editor.scrollView.panGestureRecognizer.delaysTouchesBegan = NO;
    self.editor.scrollView.pinchGestureRecognizer.delaysTouchesBegan = NO;
    
    self.panGesture.enabled = YES;
    self.tapGesture.enabled = YES;
    
    self.editor.drawingView.userInteractionEnabled = YES;
}

- (void)cleanup
{
    self.colorPanel.hidden = YES;
    self.editor.imageView.userInteractionEnabled = NO;
    self.editor.scrollView.panGestureRecognizer.minimumNumberOfTouches = 1;
    self.panGesture.enabled = NO;
    self.tapGesture.enabled = NO;
}

- (void)hideTools:(BOOL)hidden
{
    if (hidden)
    {
        self.editor.bottomBar.alpha = 0;
        self.colorPanel.alpha = 0;
    }
    else
    {
        self.editor.bottomBar.alpha = 1.0f;
        self.colorPanel.alpha = 1.0f;
    }
}

- (void)backToLastDraw
{
    [_allLineMutableArray removeLastObject];
    [self drawLine];
    
    if (self.drawToolStatus)
    {
        self.drawToolStatus(_allLineMutableArray.count > 0 ? : NO);
    }
}

#pragma mark - Gesture
//tap
- (void)drawingViewDidTap:(UITapGestureRecognizer *)sender
{
    if (self.drawingDidTap)
    {
        self.drawingDidTap();
    }
}

//draw
- (void)drawingViewDidPan:(UIPanGestureRecognizer*)sender
{
    CGPoint currentDraggingPosition = [sender locationInView:_drawingView];
    
    if(sender.state == UIGestureRecognizerStateBegan)
    {
        //取消所有加入文字激活状态
        for (UIView *subView in self.editor.drawingView.subviews)
        {
            if ([subView isKindOfClass:[WBGTextToolView class]])
            {
                [WBGTextToolView setInactiveTextView:(WBGTextToolView *)subView];
            }
        }
        
        // 初始化一个UIBezierPath对象, 把起始点存储到UIBezierPath对象中, 用来存储所有的轨迹点
        WBGPath *path = [WBGPath pathToPoint:currentDraggingPosition pathWidth:MAX(1, self.pathWidth)];
        path.pathColor = self.colorPanel.currentColor;
        path.shape.strokeColor = self.colorPanel.currentColor.CGColor;
        [_allLineMutableArray addObject:path];
        
    }
    
    if(sender.state == UIGestureRecognizerStateChanged)
    { // 获得数组中的最后一个UIBezierPath对象(因为我们每次都把UIBezierPath存入到数组最后一个,因此获取时也取最后一个)
        WBGPath *path = [_allLineMutableArray lastObject];
        [path pathLineToPoint:currentDraggingPosition];//添加点
        [self drawLine];
        
        if (self.drawingCallback)
        {
            self.drawingCallback(YES);
        }
    }
    
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        if (self.drawToolStatus)
        {
            self.drawToolStatus(_allLineMutableArray.count > 0 ? : NO);
        }
        
        if (self.drawingCallback)
        {
            self.drawingCallback(NO);
        }
    }
}

#pragma mark - Draw
- (void)drawLine
{
    [self.drawingView setNeedsDisplay];
}

@end
