//
//  WBGImageEditorViewController.m
//  CLImageEditorDemo
//
//  Created by Jason on 2017/2/27.
//  Copyright © 2017年 CALACULU. All rights reserved.
//

#import "WBGImageEditorViewController.h"
#import "WBGImageToolBase.h"
#import "WBGColorfullButton.h"
#import "WBGDrawTool.h"
#import "WBGTextTool.h"
#import "TOCropViewController.h"
#import "UIImage+CropRotate.h"
#import "WBGTextToolView.h"
#import "UIView+YYAdd.h"
#import "WBGImageEditor.h"
#import "WBGMoreKeyboard.h"
#import "YYCategories.h"
#import "WBGMosicaTool.h"
#import "Masonry.h"


#pragma mark - WBGImageEditorViewController

@interface WBGImageEditorViewController () <UINavigationBarDelegate,
UIScrollViewDelegate, TOCropViewControllerDelegate, WBGMoreKeyboardDelegate, WBGKeyboardDelegate>

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *finishButton;
@property (weak, nonatomic) IBOutlet UIView *bottomBar;
@property (weak, nonatomic) IBOutlet UIView *topBar;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) UIView *containerView;
@property (weak, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImageView *drawingView;
@property (strong, nonatomic) WBGScratchView *mosicaView;

@property (weak, nonatomic) IBOutlet UIButton *panButton;
@property (weak, nonatomic) IBOutlet UIButton *textButton;
@property (weak, nonatomic) IBOutlet UIButton *clipButton;
@property (weak, nonatomic) IBOutlet UIButton *paperButton;

@property (nonatomic, strong) WBGImageToolBase *currentTool;
@property (nonatomic, strong) WBGDrawTool *drawTool;
@property (nonatomic, strong) WBGTextTool *textTool;
@property (nonatomic, strong) WBGMosicaTool *mosicaTool;

@property (nonatomic, copy) UIImage *originImage;
@property (nonatomic, assign) WBGEditorMode currentMode;

@property (nonatomic, assign) CGFloat clipInitScale;
@property (nonatomic, assign) BOOL barsHiddenStatus;
@property (nonatomic, strong) WBGMoreKeyboard *keyboard;

@end

@implementation WBGImageEditorViewController

- (id)init
{
    self = [self initWithNibName:NSStringFromClass([WBGImageEditorViewController class])
                          bundle:[NSBundle bundleForClass:self.class]];
    
    return self;
}

- (id)initWithImage:(UIImage *)image
{
    return [self initWithImage:image delegate:nil dataSource:nil];
}

- (id)initWithImage:(UIImage *)image
           delegate:(id<WBGImageEditorDelegate>)delegate
         dataSource:(id<WBGImageEditorDataSource>)dataSource;
{
    self = [self init];
    if (self)
    {
        _originImage = image;
        self.delegate = delegate;
        self.dataSource = dataSource;
    }
    
    return self;
}

- (id)initWithDelegate:(id<WBGImageEditorDelegate>)delegate
{
    self = [self init];
    if (self)
    {
        self.delegate = delegate;
    }
    return self;
}

#pragma mark - LifeCyle
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initViews];
    [self configCustomComponent];
    [self refreshImageView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.drawingView.frame = self.imageView.frame;
    self.mosicaView.frame = self.imageView.frame;
}

- (void)configCustomComponent
{
     self.panButton.hidden = YES;
     self.textButton.hidden = YES;
     self.clipButton.hidden = YES;
     self.paperButton.hidden = YES;
    
    NSMutableArray *valibleCompoment = [NSMutableArray new];
    WBGImageEditorComponent curComponent = [self.dataSource respondsToSelector:@selector(imageEditorCompoment)] ? [self.dataSource imageEditorCompoment] : 0;
    
    if (curComponent == 0)
    {
        curComponent = WBGImageEditorALLComponent;
    }
    
    if (curComponent & WBGImageEditorDrawComponent)
    {
        self.panButton.hidden = NO;
        [valibleCompoment addObject:self.panButton];
    }
    
    if (curComponent & WBGImageEditorTextComponent)
    {
        self.textButton.hidden = NO;
        [valibleCompoment addObject:self.textButton];
    }
    
    if (curComponent & WBGImageEditorPaperComponent)
    {
        self.paperButton.hidden = NO;
        [valibleCompoment addObject:self.paperButton];
    }
    
    if (curComponent & WBGImageEditorClipComponent)
    {
        self.clipButton.hidden = NO;
        [valibleCompoment addObject:self.clipButton];
    }
    
    CGFloat padding = 45.0f;
    CGFloat width = WIDTH_SCREEN - 2 * padding;
    NSInteger count = valibleCompoment.count;
    CGFloat length = width / ((count - 1 > 0) ? (count - 1) : 1);
    
    [valibleCompoment enumerateObjectsUsingBlock:^(UIButton * _Nonnull button,
                                                   NSUInteger idx,
                                                   BOOL * _Nonnull stop)
     {
         button.centerX = length * idx + padding;
     }];
}

#pragma mark - Getter & Setter
- (WBGDrawTool *)drawTool
{
    if (_drawTool == nil)
    {
        _drawTool = [[WBGDrawTool alloc] initWithImageEditor:self];
        _drawTool.pathWidth = [self.dataSource respondsToSelector:@selector(imageEditorDrawPathWidth)] ? [self.dataSource imageEditorDrawPathWidth].floatValue : 5.0f;
    }
    
    return _drawTool;
}

- (WBGTextTool *)textTool
{
    if (_textTool == nil)
    {
        _textTool = [[WBGTextTool alloc] initWithImageEditor:self];
    }
    
    return _textTool;
}

- (WBGMosicaTool *)mosicaTool
{
    if (_mosicaTool == nil)
    {
        _mosicaTool = [[WBGMosicaTool alloc] initWithImageEditor:self];
    }
    
    return _mosicaTool;
}

- (void)setCurrentTool:(WBGImageToolBase *)currentTool
{
    [_currentTool cleanup];
    _currentTool = currentTool;
    [_currentTool setup];
    
    [self swapToolBarWithEditting];
}

- (void)initViews
{
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.clipsToBounds = NO;
    self.scrollView.backgroundColor = [UIColor blackColor];
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.scrollView.contentOffset = CGPointZero;
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.scrollView addSubview:containerView];
    self.containerView = containerView;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.image = self.originImage;
    [self.containerView addSubview:imageView];
    self.imageView = imageView;
    
    self.mosicaView = [[WBGScratchView alloc] initWithFrame:CGRectZero];
    self.mosicaView.surfaceImage = self.originImage;
    self.mosicaView.backgroundColor = [UIColor clearColor];
    [self.containerView addSubview:self.mosicaView];
    
    self.drawingView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.drawingView.contentMode = UIViewContentModeCenter;
    self.drawingView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
    self.drawingView.clipsToBounds = YES;
    [self.containerView addSubview:self.drawingView];
    self.drawingView.userInteractionEnabled = YES;
}

- (void)refreshImageView
{
    [self resetImageViewFrame];
    [self resetZoomScaleWithAnimated:NO];
}

- (void)resetImageViewFrame
{
    CGSize size = (_imageView.image) ? _imageView.image.size : _imageView.frame.size;
    if(size.width > 0 && size.height > 0 )
    {
        CGSize imageSize = self.imageView.image.size;
        CGSize scrollViewSize = _scrollView.frame.size;
        
        self.containerView.frame = CGRectMake(0, 0, scrollViewSize.width, imageSize.height*scrollViewSize.width/imageSize.width);
        self.imageView.frame = CGRectMake(0, 0, scrollViewSize.width, imageSize.height*scrollViewSize.width/imageSize.width);
        
        // 设置scrollView的缩小比例;
        CGSize newImageSize = self.containerView.size;
        CGFloat widthRatio = 1.0f; // 宽已经缩放了
        CGFloat heightRatio = scrollViewSize.height/newImageSize.height;
        if (heightRatio >= 1.0f) heightRatio = 3.0f;
        
        self.scrollView.minimumZoomScale = MIN(widthRatio, heightRatio);
        self.scrollView.maximumZoomScale = MAX(widthRatio, heightRatio);
        self.scrollView.zoomScale = widthRatio;
    }
}

- (void)resetZoomScaleWithAnimated:(BOOL)animated
{
    CGSize size = self.scrollView.bounds.size;
    CGSize contentSize = self.scrollView.contentSize;
    
    CGFloat offsetX = (size.width > contentSize.width) ?
    (size.width - contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (size.height > contentSize.height) ?
    (size.height - contentSize.height) * 0.5 : 0.0;
    
    self.containerView.center = CGPointMake(contentSize.width * 0.5 + offsetX, contentSize.height * 0.5 + offsetY);
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark- ScrollView delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.containerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGSize size = scrollView.bounds.size;
    CGSize contentSize = scrollView.contentSize;
    
    CGFloat offsetX = (size.width > contentSize.width) ?
    (size.width - contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (size.height > contentSize.height) ?
    (size.height - contentSize.height) * 0.5 : 0.0;
    
    self.containerView.center = CGPointMake(contentSize.width * 0.5 + offsetX, contentSize.height * 0.5 + offsetY);
}

#pragma mark - Actions
///涂鸦模式
- (IBAction)panAction:(UIButton *)sender
{
    if (_currentMode == WBGEditorModeDraw)
    {
        [self resetCurrentTool];
    }
    else
    {
        //先设置状态，然后在干别的
        self.currentMode = WBGEditorModeDraw;
        self.currentTool = self.drawTool;
    }
}

///裁剪模式
- (IBAction)clipAction:(UIButton *)sender
{
    
    [self buildClipImageShowHud:NO
                 clipedCallback:^(UIImage *clipedImage)
     {
        TOCropViewController *cropController = [[TOCropViewController alloc] initWithCroppingStyle:TOCropViewCroppingStyleDefault image:clipedImage];
        cropController.delegate = self;
         
        CGRect viewFrame = [self.view convertRect:self.containerView.frame
                                           toView:self.navigationController.view];
         
        [cropController
         presentAnimatedFromParentViewController:self
         fromImage:clipedImage
         fromView:nil
         fromFrame:viewFrame
         angle:0
         toImageFrame:CGRectZero
         setup:NULL
         completion:NULL];
    }];
    
}

//文字模式
- (IBAction)textAction:(UIButton *)sender
{
    //先设置状态，然后在干别的
    self.currentMode = WBGEditorModeText;
    
    self.currentTool = self.textTool;
}

//马赛克模式
- (IBAction)paperAction:(UIButton *)sender {
    if (_currentMode == WBGEditorModeMosica)
    {
        return;
    }
    
    self.currentMode = WBGEditorModeMosica;
    self.currentTool = self.mosicaTool;
}

- (void)editTextAgain
{
    //先设置状态，然后在干别的
    self.currentMode = WBGEditorModeText;
    [_currentTool cleanup];
    _currentTool = self.textTool;
    [_currentTool setup];
}

//贴图模块
- (IBAction)onPicButtonTapped:(UIButton *)sender
{
    NSArray<WBGMoreKeyboardItem *> *sources = nil;
    if (self.dataSource) {
        sources = [self.dataSource imageItemsEditor:self];
    }
    
    [self.keyboard setChatMoreKeyboardData:sources.mutableCopy];
    [self.keyboard showInView:self.view withAnimation:YES];
}

- (IBAction)backAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onFinishButtonTapped:(UIButton *)sender
{
    [self buildClipImageShowHud:YES clipedCallback:^(UIImage *clipedImage) {
        if ([self.delegate respondsToSelector:@selector(imageEditor:didFinishEdittingWithImage:)]) {
            [self.delegate imageEditor:self didFinishEdittingWithImage:clipedImage];
        }
    }];
}

- (void)resetCurrentTool
{
    self.currentMode = WBGEditorModeNone;
    self.currentTool = nil;
}

- (WBGMoreKeyboard *)keyboard
{
    if (!_keyboard)
    {
        WBGMoreKeyboard *keyboard = [WBGMoreKeyboard keyboard];
        [keyboard setKeyboardDelegate:self];
        [keyboard setDelegate:self];
        _keyboard = keyboard;
    }
    
    return _keyboard;
}

#pragma mark - WBGMoreKeyboardDelegate
- (void)moreKeyboard:(id)keyboard didSelectedFunctionItem:(WBGMoreKeyboardItem *)funcItem
{
    WBGMoreKeyboard *kb = (WBGMoreKeyboard *)keyboard;
    [kb dismissWithAnimation:YES];
    
    
    WBGTextToolView *view = [[WBGTextToolView alloc] initWithTool:self.textTool text:@"" font:nil orImage:funcItem.image];
    view.borderColor = [UIColor whiteColor];
    view.image = funcItem.image;
    view.center = [self.imageView.superview convertPoint:self.imageView.center toView:self.drawingView];
    view.userInteractionEnabled = YES;
    [self.drawingView addSubview:view];
    [WBGTextToolView setActiveTextView:view];
    
}

#pragma mark - Cropper Delegate
- (void)cropViewController:(TOCropViewController *)cropViewController
            didCropToImage:(UIImage *)image
                  withRect:(CGRect)cropRect
                     angle:(NSInteger)angle
{
    [self updateImageViewWithImage:image
                          withRect:cropRect
                             angle:angle
            fromCropViewController:cropViewController];
}

- (void)updateImageViewWithImage:(UIImage *)image
                        withRect:(CGRect)cropRect
                           angle:(NSInteger)angle
          fromCropViewController:(TOCropViewController *)cropViewController
{
    self.imageView.image = image;
    CGRect bounds = cropViewController.cropView.foregroundImageView.bounds;
    bounds.size = CGSizeMake(bounds.size.width/self.clipInitScale, bounds.size.height/self.clipInitScale);
    
    [self refreshImageView];
    [self viewDidLayoutSubviews];


    self.navigationItem.rightBarButtonItem.enabled = YES;
    __weak typeof(self)weakSelf = self;
    if (cropViewController.croppingStyle != TOCropViewCroppingStyleCircular)
    {
        [cropViewController
         dismissAnimatedFromParentViewController:self
         withCroppedImage:image
         toView:self.imageView
         toFrame:CGRectZero
         setup:^{
             [weakSelf refreshImageView];
             [weakSelf viewDidLayoutSubviews];
         }
         completion:NULL];
    }
    else
    {
        [cropViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (void)cropViewController:(TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled
{
    [cropViewController
     dismissAnimatedFromParentViewController:self
     withCroppedImage:nil
     toView:self.imageView
     toFrame:CGRectZero
     setup:NULL
     completion:NULL];
}

#pragma mark -
- (void)swapToolBarWithEditting
{
    switch (_currentMode)
    {
        case WBGEditorModeDraw:
        {
            self.panButton.selected = YES;
            if (self.drawTool.allLineMutableArray.count > 0)
            {
                //self.undoButton.hidden  = NO;
            }
        }
            break;
        case WBGEditorModeText:
        case WBGEditorModeClip:
        case WBGEditorModeNone:
        {
            self.panButton.selected = NO;
            //self.undoButton.hidden  = YES;
        }
            break;
        default:
            break;
    }
}

- (void)hiddenTopAndBottomBar:(BOOL)isHide
                    animation:(BOOL)animation
{
    if (self.keyboard.isShow)
    {
        [self.keyboard dismissWithAnimation:YES];
        return;
    }
    
    CGFloat time = animation ? .4f : 0.f;
    [UIView animateWithDuration:time animations:^{
        [self.currentTool hideTools:isHide];
        self.barsHiddenStatus = isHide;
    }];
}

- (void)buildClipImageShowHud:(BOOL)showHud
               clipedCallback:(void(^)(UIImage *clipedImage))clipedCallback
{
    UIGraphicsBeginImageContextWithOptions(self.drawingView.size,
                                           NO,
                                           [UIScreen mainScreen].scale);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.containerView.layer renderInContext:ctx];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (clipedCallback)
    {
        clipedCallback(image);
    }
}

#pragma mark - Public
- (CGFloat)bottomBarHeight
{
    return self.bottomBar.height;
}

@end
