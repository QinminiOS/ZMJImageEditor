#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "FrameAccessor.h"
#import "ScrollViewFrameAccessor.h"
#import "ViewFrameAccessor.h"

FOUNDATION_EXPORT double FrameAccessorVersionNumber;
FOUNDATION_EXPORT const unsigned char FrameAccessorVersionString[];

