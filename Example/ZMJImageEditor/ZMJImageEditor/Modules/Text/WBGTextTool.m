//
//  WBGTextTool.m
//  CLImageEditorDemo
//
//  Created by Jason on 2017/3/1.
//  Copyright © 2017年 CALACULU. All rights reserved.
//

#import "WBGTextTool.h"
#import "WBGTextToolView.h"
#import "FrameAccessor.h"
#import "WBGTextColorPanel.h"
#import "WBGChatMacros.h"
#import "WBGNavigationBarView.h"
#import "EXTobjc.h"
#import "WBGDrawView.h"
#import "WBGTextToolOverlapView.h"
#import <XXNibBridge/XXNibBridge.h>


static const CGFloat kTopOffset = 50.f;
static const CGFloat kTextTopOffset = 60.f;
static const NSInteger kTextMaxLimitNumber = 100;

@interface WBGTextTool ()
@property (nonatomic, weak) WBGDrawView *canvas;
@property (nonatomic, weak) WBGTextColorPanel *textColorPanel;
@end

@implementation WBGTextTool

- (void)setup
{
    _canvas = self.editor.drawingView;
    self.editor.scrollView.pinchGestureRecognizer.enabled = NO;
    
    self.textView = [[WBGTextView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN)];
    self.textView.textView.font = [UIFont systemFontOfSize:25.f weight:UIFontWeightBold];
    self.textView.textView.textColor = [UIColor whiteColor];
    self.textColorPanel = self.textView.colorPanel;
    
    [self setupActions];
    
    [self.editor.view addSubview:self.textView];
}

- (void)setupActions
{
    weakify(self);
    
    self.textView.dissmissTextTool = ^(NSString *currentText, BOOL isUse)
    {
        strongify(self);
        
        self.editor.scrollView.pinchGestureRecognizer.enabled = YES;
        
        if (self.isEditAgain)
        {
            if (self.editAgainCallback && isUse)
            {
                self.editAgainCallback(currentText);
            }
            
            self.isEditAgain = NO;
        }
        else
        {
            if (isUse)
            {
                [self addNewText:currentText];
            }
        }
        
        if (self.dissmissTextTool)
        {
            self.dissmissTextTool(currentText);
        }
    };
    
    self.textColorPanel.onTextColorChange = ^(UIColor *color) {
        strongify(self);
        [self changeColor:color];
    };
}

#pragma mark - implementation 重写父方法
- (void)cleanup
{
    [self.textView removeFromSuperview];
}

- (void)hideTools:(BOOL)hidden
{
    if (hidden)
    {
        self.editor.bottomBar.alpha = 0;
    }
    else
    {
        self.editor.bottomBar.alpha = 1.0f;
    }
}

- (UIView *)drawView
{
    return nil;
}

- (void)hideTextBorder
{
    [WBGTextToolView hideTextBorder];
}

- (void)changeColor:(UIColor *)color
{
    if (color && self.textView)
    {
        [self.textView.textView setTextColor:color];
    }
}

- (void)addNewText:(NSString *)text
{
    if (text == nil || text.length <= 0)
    {
        return;
    }
    
    WBGTextToolView *view = [[WBGTextToolView alloc] initWithTool:self text:text font:self.textView.textView.font orImage:nil];
    view.fillColor = self.textColorPanel.currentColor;
    view.borderColor = [UIColor whiteColor];
    view.font = self.textView.textView.font;
    view.text = text;
    view.center = [self.editor.imageView.superview convertPoint:self.editor.imageView.center toView:self.editor.drawingView];
    view.userInteractionEnabled = YES;
    
    [self.editor.drawingView addSubview:view];
    
    // 更新位置 不然旋转了
    CGFloat scale = [(NSNumber *)[self.editor.drawingView valueForKeyPath:@"layer.transform.rotation"] floatValue];
    [view rotate:-scale];
    
    [WBGTextToolView setActiveTextView:view];
}

@end



#pragma mark - WBGTextView
@interface WBGTextView () <UITextViewDelegate>
@property (nonatomic, strong) NSString *needReplaceString;
@property (nonatomic, assign) NSRange   needReplaceRange;
@property (nonatomic, strong) WBGNavigationBarView *navigationBarView;
@end

@implementation WBGTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        self.effectView = [[UIView alloc] init];
        self.effectView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7f];
        self.effectView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        [self addSubview:self.effectView];
        
        self.navigationBarView = [WBGNavigationBarView xx_instantiateFromNib];
        self.navigationBarView.frame = CGRectMake(0, 0, WIDTH_SCREEN, [WBGNavigationBarView fixedHeight]);
        [self addSubview:self.navigationBarView];
        
        
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(16, kTopOffset, WIDTH_SCREEN - 16 * 2, HEIGHT_SCREEN - kTopOffset)];
        self.textView.top = kTextTopOffset;
        self.textView.scrollEnabled = YES;
        self.textView.returnKeyType = UIReturnKeyDone;
        self.textView.delegate = self;
        self.textView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.textView];
        
        WBGTextColorPanel *colorPanel = [WBGTextColorPanel xx_instantiateFromNib];
        colorPanel.frame = CGRectMake(0, HEIGHT_SCREEN, WIDTH_SCREEN, [WBGTextColorPanel fixedHeight]);
        [self addSubview:colorPanel];
        self.colorPanel = colorPanel;
        
        [self setupActions];
        [self addNotify];
    }
    
    return self;
}

- (void)setupActions
{
    __weak __typeof(self)weakSelf = self;
   
    self.navigationBarView.onDoneButtonClickBlock = ^(UIButton *btn) {
        [weakSelf dismissTextEditing:YES];
    };
    
    self.navigationBarView.onCancelButtonClickBlock = ^(UIButton *btn) {
        [weakSelf dismissTextEditing:NO];
    };
}

- (void)addNotify
{
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillShow:)
     name:UIKeyboardWillShowNotification
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillHide:)
     name:UIKeyboardWillHideNotification
     object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userinfo = notification.userInfo;
    CGRect  keyboardRect              = [[userinfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardAnimationDuration = [[userinfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions keyboardAnimationCurve = [[userinfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    
    self.hidden = YES;
    [UIView
     animateWithDuration:keyboardAnimationDuration
     delay:keyboardAnimationDuration
     options:keyboardAnimationCurve
     animations:^{
        self.textView.height = HEIGHT_SCREEN - keyboardRect.size.height - kTextTopOffset;
        
        self.colorPanel.frame = CGRectMake(0, HEIGHT_SCREEN - [WBGTextColorPanel fixedHeight] - keyboardRect.size.height, WIDTH_SCREEN, [WBGTextColorPanel fixedHeight]);
        
    } completion:NULL];
    
    [UIView animateWithDuration:3 animations:^{
        self.hidden = NO;
    }];
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *userinfo = notification.userInfo;
    CGFloat keyboardAnimationDuration = [[userinfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions keyboardAnimationCurve = [[userinfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    
    [UIView animateWithDuration:keyboardAnimationDuration delay:0.f options:keyboardAnimationCurve animations:^{
        self.top = self.effectView.height + kTopOffset;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismissTextEditing:(BOOL)done
{
    [self.textView resignFirstResponder];
    
    if (self.dissmissTextTool)
    {
        self.dissmissTextTool(self.textView.text, done);
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.textView becomeFirstResponder];
            [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length-1, 0)];
        });
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    // 选中范围的标记
    UITextRange *textSelectedRange = [textView markedTextRange];
    // 获取高亮部分
    UITextPosition *textPosition = [textView positionFromPosition:textSelectedRange.start offset:0];
    // 如果在变化中是高亮部分在变, 就不要计算字符了
    if (textSelectedRange && textPosition)
    {
        return;
    }
    
    // 文本内容
    NSString *textContentStr = textView.text;
    NSInteger existTextNumber = textContentStr.length; // 所以在这里为了提高效率不在判断
    
    if (existTextNumber > kTextMaxLimitNumber)
    {
        // 截取到最大位置的字符(由于超出截取部分在should时被处理了,所以在这里为了提高效率不在判断)
        NSString *str = [textContentStr substringToIndex:kTextMaxLimitNumber];
        [textView setText:str];
        //[AlertBox showMessage:@"输入字符不能超过100\n多余部分已截断" hideAfter:3];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [self dismissTextEditing:YES];
        return NO;
    }
    
    NSString *newText = [self.textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger newTextLength = [self countString:newText];
    
    if (newTextLength > kTextMaxLimitNumber)
    {
        
        __block NSInteger idx = 0;
        __block NSMutableString *trimString = [NSMutableString string]; // 截取出的字串
        
        [newText
         enumerateSubstringsInRange:NSMakeRange(0, [newText length])
         options:NSStringEnumerationByComposedCharacterSequences
         usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop)
         {
             NSInteger steplen = substring.length;
             if ([substring canBeConvertedToEncoding:NSASCIIStringEncoding])
             {
                 steplen = 1;
             }
             else
             {
                 steplen = steplen * 2;
             }
             
             idx = idx + steplen;
             
             if (idx > kTextMaxLimitNumber)
             {
                 *stop = YES; // 取出所需要就break，提高效率
             }
             else
             {
                 [trimString appendString:substring];
             }
         }];
        
        self.textView.text = trimString;
        
        return NO;
    }
    else
    {
        return YES;
    }
}

- (NSInteger)countString:(NSString *)string
{
    __block NSInteger length = 0;
    
    [string
     enumerateSubstringsInRange:NSMakeRange(0, [string length])
     options:NSStringEnumerationByComposedCharacterSequences
     usingBlock:^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop)
    {
        NSInteger steplen = substring.length;
        
        if ([substring canBeConvertedToEncoding:NSASCIIStringEncoding])
        {
            length += 1;
        }
        else
        {
            length += steplen * 2;
        }
    }];
    
    return length;
}

@end
