//
//  UIImage+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/12.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UIImage+CCExtension.h"

#import "CCCommonDefine.h"
#import "CCCommonTools.h"

#import <CoreImage/CoreImage.h>
#import <Accelerate/Accelerate.h>
#import <CoreGraphics/CoreGraphics.h>

@implementation UIImage (CCExtension)

- (UIImage *)gaussianImageAcc{
    return self.ccGaussianImageAcc;
}
- (UIImage *)gaussianImageCI {
    return self.ccGaussianImageCI; // sync , 不推荐使用
}

- (CGFloat)width {
    return self.size.width;
}
- (CGFloat)height {
    return self.size.height;
}

- (CGSize) ccZoom : (CGFloat) floatScale {
    if (floatScale > .0f) {
        CGFloat ratio = self.height / self.width;
        CGFloat ratioWidth = self.width * floatScale;
        CGFloat ratioHeight = ratioWidth * ratio;
        return CGSizeMake(ratioWidth, ratioHeight);
    }
    return self.size;
}

+ (instancetype) ccGenerate : (UIColor *) color {
    return [self ccGenerate:color
                       size:.0f];
}

+ (instancetype) ccGenerate : (UIColor *)color
                       size : (CGFloat) floatSize {
    if (floatSize <= .0f) {
        floatSize = 1.f;
    }
    
    CGRect rect = CGRectMake(0.0f, 0.0f, floatSize, floatSize);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *imageGenerate = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageGenerate;
}

- (instancetype) ccGaussianImageAcc {
    return [self ccGaussianImageAcc:_CC_GAUSSIAN_BLUR_VALUE_];
}

- (instancetype) ccGaussianImageAcc : (CGFloat) floatValue {
    return [self ccGaussianImageAcc:floatValue
                     iterationCount:0
                               tint:UIColor.whiteColor];
}

- (instancetype) ccGaussianImageAcc : (CGFloat) floatValue
                     iterationCount : (NSInteger) iCount
                               tint : (UIColor *) color {
    UIImage *image = [self copy];
    if (!image) return self;
    
    if (floatValue < 0.f || floatValue > 1.f) {
        floatValue = 0.5f;
    }
    
    if (floor(self.width) * floor(self.height) <= 0) {
        return self;
    }
    
    UInt32 boxSize = (UInt32)(floatValue * self.scale);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef imageRef = image.CGImage;
    
    CGBitmapInfo bitMapInfo = CGImageGetBitmapInfo(imageRef);
    if (CGImageGetBitsPerPixel(imageRef) != 32
        || CGImageGetBitsPerComponent(imageRef) != 8
        || ((bitMapInfo & kCGBitmapAlphaInfoMask) != kCGBitmapAlphaInfoMask)) {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
        [self drawAtPoint:CGPointZero];
        imageRef = UIGraphicsGetImageFromCurrentImageContext().CGImage;
        UIGraphicsEndImageContext();
    }
    
    if (!imageRef) return self;
    
    vImage_Buffer inBuffer, outBuffer;
    
    inBuffer.width = CGImageGetWidth(imageRef);
    inBuffer.height = CGImageGetHeight(imageRef);
    inBuffer.rowBytes = CGImageGetBytesPerRow(imageRef);
    
    outBuffer.width = CGImageGetWidth(imageRef);
    outBuffer.height = CGImageGetHeight(imageRef);
    outBuffer.rowBytes = CGImageGetBytesPerRow(imageRef);
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(imageRef);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    NSUInteger bytes = outBuffer.rowBytes * outBuffer.height;
    inBuffer.data = malloc(bytes);
    outBuffer.data = malloc(bytes);
    
    if (!inBuffer.data || !outBuffer.data) {
        free(inBuffer.data);
        free(outBuffer.data);
        return self;
    }
    
    void * tempBuffer = malloc(vImageBoxConvolve_ARGB8888(&outBuffer,
                                                          &inBuffer,
                                                          NULL,
                                                          0,
                                                          0,
                                                          boxSize,
                                                          boxSize,
                                                          NULL,
                                                          kvImageEdgeExtend | kvImageGetTempBufferSize));

    CGDataProviderRef providerRef = CGImageGetDataProvider(imageRef);
    CFDataRef dataInBitMap = CGDataProviderCopyData(providerRef);
    if (!dataInBitMap) return self;
    
    memcpy(outBuffer.data, CFDataGetBytePtr(dataInBitMap), MIN(bytes, CFDataGetLength(dataInBitMap)));

    for (NSInteger i = 0; i < iCount; i ++) {
        vImage_Error error = vImageBoxConvolve_ARGB8888(&outBuffer,
                                                        &inBuffer,
                                                        tempBuffer,
                                                        0,
                                                        0,
                                                        boxSize,
                                                        boxSize,
                                                        NULL,
                                                        kvImageEdgeExtend);
        if (error != kvImageNoError) {
            free(tempBuffer);
            free(inBuffer.data);
            free(outBuffer.data);
            return self;
        }
        void * temp = inBuffer.data;
        inBuffer.data = outBuffer.data;
        outBuffer.data = temp;
    }
    
    free(inBuffer.data);
    free(tempBuffer);
    
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    if (!colorSpace) return self;
    
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             bitMapInfo);
    if (color && CGColorGetAlpha(color.CGColor) > 0.0) {
        CGColorRef colorRef = CGColorCreateCopyWithAlpha(color.CGColor, _CC_GAUSSIAN_BLUR_TINT_ALPHA_);
        CGContextSetFillColor(ctx, CGColorGetComponents(colorRef));
        CGContextSetBlendMode(ctx, kCGBlendModePlusLighter);
        CGContextFillRect(ctx, (CGRect){CGPointZero , outBuffer.width , outBuffer.height});
    }
    imageRef = CGBitmapContextCreateImage(ctx);
    UIImage * imageProcessed = [UIImage imageWithCGImage:imageRef];
    
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return imageProcessed;
}

- (void) ccGaussianImageAcc : (CGFloat) floatValue
             iterationCount : (NSInteger) iCount
                       tint : (UIColor *) color
                   complete : (void(^)(UIImage *imageOrigin , UIImage *imageProcessed)) block {
    
    if (CC_Available(10.0)) {
        // ios 10 DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL
        dispatch_async(dispatch_queue_create("Love.cc.love.home", DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL), ^{
            UIImage *image = [self ccGaussianImageAcc:floatValue
                                       iterationCount:iCount
                                                 tint:color];
            CC_Safe_UI_Operation(block, ^{
                block(self, image);
            });
        });
    } else {
        dispatch_async(dispatch_queue_create("Love.cc.love.home", DISPATCH_QUEUE_CONCURRENT), ^{
            UIImage *image = [self ccGaussianImageAcc:floatValue
                                       iterationCount:iCount
                                                 tint:color];

            CC_Safe_UI_Operation(block, ^{
                block(self , image);
            });
        });
    }
}

// Core Image . 处理速度太慢 . 不推荐使用 .
- (instancetype) ccGaussianImageCI {
    return [self ccGaussianImageCI:_CC_GAUSSIAN_BLUR_VALUE_];
}
- (instancetype) ccGaussianImageCI : (CGFloat) floatValue {
    UIImage *image = [self copy];
    if (!image) return self;
    
    CIContext *context = [CIContext contextWithOptions:@{kCIContextPriorityRequestLow : @(YES)}];
    CIImage *imageInput= [CIImage imageWithCGImage:image.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:imageInput forKey:kCIInputImageKey];
    [filter setValue:@(floatValue) forKey: @"inputRadius"];
    
    CIImage *imageResult = [filter valueForKey:kCIOutputImageKey];
    CGImageRef imageOutput = [context createCGImage:imageResult
                                           fromRect:[imageResult extent]];
    UIImage *imageBlur = [UIImage imageWithCGImage:imageOutput];
    CGImageRelease(imageOutput);
    
    return imageBlur;
}
- (void) ccGaussianImageCI : (CGFloat) floatValue
                  complete : (void(^)(UIImage *imageOrigin , UIImage *imageProcessed)) block {
    ccWeakSelf;
    if (CC_Available(10.0)) {
        dispatch_async(dispatch_queue_create("Love.cc.love.home", DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL), ^{
            UIImage *image = [self ccGaussianImageCI:floatValue];
            CC_Safe_UI_Operation(block, ^{
                block(pSelf , image);
            });
        });
    } else {
        dispatch_async(dispatch_queue_create("Love.cc.love.home", DISPATCH_QUEUE_CONCURRENT), ^{
            UIImage *image = [self ccGaussianImageCI:floatValue];;
            CC_Safe_UI_Operation(block, ^{
                block(pSelf , image);
            });
        });
    }
}

+ (instancetype) ccImage : (NSString *) stringImageName {
    return [self ccImage:stringImageName
                  isFile:false];
}
+ (instancetype) ccImage : (NSString *) stringImageName
                  isFile : (BOOL) isFile {
    return [self ccImage:stringImageName
                  isFile:isFile
           renderingMode:UIImageRenderingModeAlwaysOriginal];
}
+ (instancetype) ccImage : (NSString *) stringImageName
                  isFile : (BOOL) isFile
           renderingMode : (UIImageRenderingMode) mode {
    UIImage *image = isFile ? [UIImage imageWithContentsOfFile:stringImageName] : [UIImage imageNamed:stringImageName];
    return [image imageWithRenderingMode:mode] ;
}
+ (instancetype) ccImage : (NSString *) stringImageName
                  isFile : (BOOL) isFile
           renderingMode : (UIImageRenderingMode) mode
      resizableCapInsets : (UIEdgeInsets) insets {
    UIImage *image = [self ccImage:stringImageName
                             isFile:isFile
                      renderingMode:mode];
    return [image resizableImageWithCapInsets:insets];
}

- (NSData *) ccImageDataStream : (void (^)(CCImageType type , NSData *dataImage)) block {
    NSData *data = nil;
    if (self && [self isKindOfClass:[UIImage class]]) {
        if ((data = UIImagePNGRepresentation(self))) {
            CC_Safe_UI_Operation(block, ^{
                block(CCImageTypePNG , data);
            });
        }
        else if ((data = UIImageJPEGRepresentation(self, _CC_IMAGE_JPEG_COMPRESSION_QUALITY_))) {
            CC_Safe_Operation(block, ^{
                block(CCImageTypeJPEG , data);
            });
        }
        else {
            CC_Safe_Operation(block, ^{
                block(CCImageTypeUnknow , data);
            });
        }
    }
    return data;
}

- (CCImageType) ccType : (NSData *) data {
    if (!data) return CCImageTypeUnknow;
    
    UInt8 c = 0;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return CCImageTypeJPEG;
        case 0x89:
            return CCImageTypePNG;
        case 0x47:
            return CCImageTypeGif;
        case 0x49:
        case 0x4D:
            return CCImageTypeTiff;
        case 0x52:
            if (data.length < 12) {
                return CCImageTypeUnknow;
            }
            
        default:
            return CCImageTypeUnknow;
            break;
    }
    return CCImageTypeUnknow;
}

- (NSData *) ccCompressQuality {
    return [self ccCompressQuality:_CC_IMAGE_JPEG_COMPRESSION_QUALITY_SIZE_];
}
- (NSData *) ccCompressQuality : (CGFloat) floatQuality {
    NSData *dataOrigin = [self ccImageDataStream:nil];
    if (!dataOrigin) {
        return nil;
    }
    NSData *dataCompress = dataOrigin ;
    NSData *dataResult = dataOrigin;
    
    long long lengthData = dataCompress.length;
    NSInteger i = 0;
    for (NSInteger j = 0 ; j < 10; j ++) {
        if (lengthData / 1024.f > floatQuality) {
            NSData *dataTemp = UIImageJPEGRepresentation(self , 1.f - (++ i) * .1f);
            dataResult = dataTemp;
            lengthData = dataResult.length;
            continue;
        }
        break;
    }
    return dataResult;
}

- (BOOL) ccIsOverLimit_3M {
    return [self ccIsOverLimit:2.9f];
}
- (BOOL) ccIsOverLimit : (CGFloat) floatMBytes {
    NSData *data = [self ccImageDataStream:nil];
    return [data length] / powl(1024, 2) > floatMBytes;
}

@end
