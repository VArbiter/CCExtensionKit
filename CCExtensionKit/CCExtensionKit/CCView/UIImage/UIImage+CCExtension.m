//
//  UIImage+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/12.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UIImage+CCExtension.h"

#import <CoreGraphics/CoreGraphics.h>

@implementation UIImage (CCExtension)

/// for image size && width
- (CGFloat)width {
    return self.size.width;
}
- (CGFloat)height {
    return self.size.height;
}

/// scale size with radius
- (CGSize) ccZoom : (CGFloat) fRadius {
    if (fRadius > .0f) {
        CGFloat ratio = self.height / self.width;
        CGFloat ratioWidth = self.width * fRadius;
        CGFloat ratioHeight = ratioWidth * ratio;
        return CGSizeMake(ratioWidth, ratioHeight);
    }
    return self.size;
}
- (instancetype) ccResizable : (UIEdgeInsets) insets {
    return [self resizableImageWithCapInsets:insets];
}
- (instancetype) ccRendaring : (UIImageRenderingMode) mode {
    return [self imageWithRenderingMode:mode];
}
- (instancetype) ccAlwaysOriginal {
    return [self imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

/// class , imageName
+ (instancetype) ccBundle : (Class) cls
                     name : (NSString *) sName {
    NSBundle *b = [NSBundle bundleForClass:cls];
    NSString *bName = b.infoDictionary[@"CFBundleName"];
    NSString *sc = [NSString stringWithFormat:@"%ld",(NSInteger)UIScreen.mainScreen.scale];
    NSString *temp = [[[sName stringByAppendingString:@"@"] stringByAppendingString:sc] stringByAppendingString:@"x"];
    NSString *p = [b pathForResource:temp
                              ofType:@"png"
                         inDirectory:[bName stringByAppendingString:@".bundle"]];
    UIImage *image = [UIImage imageWithContentsOfFile:p];
#if DEBUG
    if (!image) NSLog(@"image Named \"%@\" with class \"%@\" not found , return new image istead",sName,NSStringFromClass(cls));
#endif
    return (image ? image : UIImage.new);
}
+ (instancetype) ccName : (NSString *) sName {
    return [self imageNamed:sName];
}
+ (instancetype) ccName : (NSString *) sName
                 bundle : (NSBundle *) bundle {
    return [self imageNamed:sName
                   inBundle:bundle
compatibleWithTraitCollection:nil];
}
+ (instancetype) ccFile : (NSString *) sPath {
    return [UIImage imageWithContentsOfFile:sPath];
}

@end

#pragma mark - -----
@import Accelerate;
@import CoreImage;

CGFloat _CC_GAUSSIAN_BLUR_VALUE_ = .1f;
CGFloat _CC_GAUSSIAN_BLUR_TINT_ALPHA_ = .25f;

@implementation UIImage (CCExtension_Gaussian)

- (instancetype) ccGaussianAcc {
    return [self ccGaussianAcc:_CC_GAUSSIAN_BLUR_VALUE_];
}
- (instancetype) ccGaussianAcc : (CGFloat) fRadius {
    return [self ccGaussianAcc:fRadius iteration:0 tint:UIColor.whiteColor];
}
- (instancetype) ccGaussianAcc : (CGFloat) fRadius
                     iteration : (NSInteger) iteration
                          tint : (UIColor *) tint {
    UIImage *image = [self copy];
    if (!image) return self;
    
    if (fRadius < 0.f || fRadius > 1.f) {
        fRadius = 0.5f;
    }
    
    if (floor(self.width) * floor(self.height) <= 0) {
        return self;
    }
    
    UInt32 boxSize = (UInt32)(fRadius * self.scale);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef imageRef = image.CGImage;
    
    CGBitmapInfo bitMapInfo = CGImageGetBitmapInfo(imageRef);
    if (CGImageGetBitsPerPixel(imageRef) != 32
        || CGImageGetBitsPerComponent(imageRef) != 8
        || ((bitMapInfo & kCGBitmapAlphaInfoMask) != kCGBitmapAlphaInfoMask)) {
#warning TODO >>>
        /// 这里的重绘出问题了 ? 色彩失真严重
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
    
    for (NSInteger i = 0; i < iteration; i ++) {
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
#warning TODO >>>
        /// 这里的交换出问题了 ? 模糊不起效 .
        
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
    if (tint && CGColorGetAlpha(tint.CGColor) > 0.0) {
        CGColorRef colorRef = CGColorCreateCopyWithAlpha(tint.CGColor, _CC_GAUSSIAN_BLUR_TINT_ALPHA_);
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
- (instancetype) ccGaussianAcc : (CGFloat)fRadius
                     iteration : (NSInteger) iteration
                          tint : (UIColor *) tint
                      complete : (void(^)(UIImage *origin , UIImage *processed)) complete {
    __weak typeof(self) pSelf = self;
    void (^tp)() = ^ {
        UIImage *m = [pSelf ccGaussianAcc:fRadius iteration:iteration tint:tint];
        if (NSThread.isMainThread) {
            if (complete) complete(pSelf , m);
        } else dispatch_sync(dispatch_get_main_queue(), ^{
            if (complete) complete(pSelf , m);
        });
    };
    
    if (UIDevice.currentDevice.systemVersion.floatValue >= 10.f) {
        dispatch_async(dispatch_queue_create("love.cc.love.home", DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL), ^{
            if (tp) tp();
        });
    } else {
        dispatch_async(dispatch_queue_create("love.cc.love.home", DISPATCH_QUEUE_CONCURRENT), ^{
            if (tp) tp();
        });
    }
    return pSelf;
}

- (instancetype) ccGaussianCI {
    return [self ccGaussianCI:_CC_GAUSSIAN_BLUR_VALUE_];
}
- (instancetype) ccGaussianCI : (CGFloat) fRadius {
    UIImage *image = [self copy];
    if (!image) return self;
    
    CIContext *context = [CIContext contextWithOptions:@{kCIContextPriorityRequestLow : @(YES)}];
    CIImage *imageInput= [CIImage imageWithCGImage:image.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:imageInput forKey:kCIInputImageKey];
    [filter setValue:@(fRadius) forKey: @"inputRadius"];
    
    CIImage *imageResult = [filter valueForKey:kCIOutputImageKey];
    CGImageRef imageOutput = [context createCGImage:imageResult
                                           fromRect:[imageResult extent]];
    UIImage *imageBlur = [UIImage imageWithCGImage:imageOutput];
    CGImageRelease(imageOutput);
    
    return imageBlur;
}
- (instancetype) ccGaussianCI : (CGFloat) fRadius
                     complete : (void(^)(UIImage *origin , UIImage *processed)) complete {
    __weak typeof(self) pSelf = self;
    void (^tp)() = ^ {
        UIImage *m = [pSelf ccGaussianCI:fRadius];
        if (NSThread.isMainThread) {
            if (complete) complete(pSelf , m);
        } else dispatch_sync(dispatch_get_main_queue(), ^{
            if (complete) complete(pSelf , m);
        });
    };
    
    if (UIDevice.currentDevice.systemVersion.floatValue >= 10.f) {
        dispatch_async(dispatch_queue_create("love.cc.love.home", DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL), ^{
            if (tp) tp();
        });
    } else {
        dispatch_async(dispatch_queue_create("love.cc.love.home", DISPATCH_QUEUE_CONCURRENT), ^{
            if (tp) tp();
        });
    }
    return self;
}

@end

#pragma mark - -----

@implementation UIImage (CCExtension_Data)

CGFloat _CC_IMAGE_JPEG_COMPRESSION_QUALITY_SIZE_ = 400.f;

- (NSData *)toData {
    NSData *d = nil;
    if ((d = UIImagePNGRepresentation(self))) return d;
    if ((d = UIImageJPEGRepresentation(self, .0f))) return d;
    return d;
}

- (NSData *) ccCompresssJPEG : (CGFloat) fQuility {
    NSData *dO = UIImageJPEGRepresentation(self, .0f); // dataOrigin
    if (!dO) return nil;
    NSData *dC = dO ; // dataCompress
    NSData *dR = dO; // dataResult
    
    long long lengthData = dC.length;
    NSInteger i = 0;
    for (NSInteger j = 0 ; j < 10; j ++) {
        if (lengthData / 1024.f > fQuility) {
            NSData *dataTemp = UIImageJPEGRepresentation(self , 1.f - (++ i) * .1f);
            dR = dataTemp;
            lengthData = dR.length;
            continue;
        }
        break;
    }
    return dR;
}

- (BOOL) ccIsOverLimitFor : (CGFloat) fMBytes {
    return self.toData.length / powl(1024, 2) > fMBytes;
}

@end

#pragma mark - -----

@implementation NSData (CCExtension_Image)

- (CCImageType)type {
    NSData *data = [self copy];
    if (!data) return CCImageType_Unknow;
    
    UInt8 c = 0;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF: return CCImageType_JPEG;
        case 0x89: return CCImageType_PNG;
        case 0x47: return CCImageType_Gif;
        case 0x49:
        case 0x4D: return CCImageType_Tiff;
        case 0x52:{
            if (data.length < 12) {
                return CCImageType_Unknow;
            }
            // 0x52 == 'R' , and R is Riff for WEBP
            NSString *s = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)]
                                                encoding:NSASCIIStringEncoding];
            if ([s hasPrefix:@"RIFF"] && [s hasSuffix:@"WEBP"]) {
                return CCImageType_WebP;
            }
        }
            
        default:
            return CCImageType_Unknow;
            break;
    }
    return CCImageType_Unknow;
}

@end

#pragma mark - -----

@implementation UIImageView (CCExtension_Gaussian)

- (instancetype) ccGaussian {
    if (self.image) self.image = [self.image ccGaussianAcc];
    return self;
}
- (instancetype) ccGaussian : (CGFloat) fRadius {
    if (self.image) self.image = [self.image ccGaussianAcc:fRadius];
    return self;
}

@end
