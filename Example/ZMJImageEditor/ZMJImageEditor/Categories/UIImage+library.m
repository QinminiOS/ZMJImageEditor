//
//  UIImage+library.m
//  Pods
//
//  Created by Jason on 2017/3/13.
//
//

#import "UIImage+library.h"

@implementation UIImage (library)

+ (UIImage *)my_bundleImageNamed:(NSString *)name {
    return [self my_imageNamed:name inBundle:[NSBundle bundleForClass:self]];
}


+ (UIImage *)my_imageNamed:(NSString *)name inBundle:(NSBundle *)bundle {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    return [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
#elif __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
    return [UIImage imageWithContentsOfFile:[bundle pathForResource:name ofType:@"png"]];
#else
    if ([UIImage respondsToSelector:@selector(imageNamed:inBundle:compatibleWithTraitCollection:)]) {
        return [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    } else {
        return [UIImage imageWithContentsOfFile:[bundle pathForResource:name ofType:@"png"]];
    }
#endif
}

- (void)writeToAlbumWithCompleteBlock:(void(^)(NSError *error, PHAsset *asset))completeBlock
{
    NSMutableArray *imageIds = [NSMutableArray array];
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        //写入图片到相册
        PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:self];
        //记录本地标识，等待完成后取到相册中的图片对象
        [imageIds addObject:req.placeholderForCreatedAsset.localIdentifier];
        
    } completionHandler:^(BOOL success, NSError *error) {
        
        if (success)
        {
            //成功后取相册中的图片对象
            __block PHAsset *imageAsset = nil;
            PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:imageIds options:nil];
            [result enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                imageAsset = obj;
                *stop = YES;
            }];
            
            if (imageAsset)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completeBlock)
                    {
                        completeBlock(nil, imageAsset);
                    }
                });
            }
            else
            {
                // LOGSYS_OC(FCKLevelError, @"PHAsset fetchAssetsWithLocalIdentifiers error: %@", error);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completeBlock)
                    {
                        completeBlock(error, nil);
                    }
                });
            }
        }
        else
        {
            // LOGSYS_OC(FCKLevelError, @"PHPhotoLibrary performChanges error: %@", error);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completeBlock)
                {
                    completeBlock(error, nil);
                }
            });
        }
        
    }];
}

@end
