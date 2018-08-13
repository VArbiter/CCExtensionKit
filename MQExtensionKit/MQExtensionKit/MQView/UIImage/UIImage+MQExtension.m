//
//  UIImage+MQExtension.m
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/4/12.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UIImage+MQExtension.h"

#import <CoreGraphics/CoreGraphics.h>

UIImage * MQ_CAPTURE_WINDOW(UIWindow *window) {
    UIWindow *w = [UIApplication sharedApplication].windows.firstObject;
    if (window) w = window;
    
    UIGraphicsBeginImageContext(w.frame.size);
    [w.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@implementation UIImage (MQExtension)

/// for image size && width
- (CGFloat)width {
    return self.size.width;
}
- (CGFloat)height {
    return self.size.height;
}

/// scale size with radius
- (CGSize) mq_zoom : (CGFloat) fRadius {
    if (fRadius > .0f) {
        CGFloat ratio = self.height / self.width;
        CGFloat ratioWidth = self.width * fRadius;
        CGFloat ratioHeight = ratioWidth * ratio;
        return CGSizeMake(ratioWidth, ratioHeight);
    }
    return self.size;
}
- (instancetype) mq_resizable : (UIEdgeInsets) insets {
    return [self resizableImageWithCapInsets:insets];
}
- (instancetype) mq_rendaring : (UIImageRenderingMode) mode {
    return [self imageWithRenderingMode:mode];
}
- (instancetype) mq_always_original {
    return [self imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

/// class , imageName
+ (instancetype) mq_bundle : (Class) cls
                      name : (NSString *) sName {
    return [self mq_bundle:cls
                    module:nil
                      name:sName];
}
+ (instancetype) mq_bundle : (Class) cls
                    module : (NSString *) sModule
                      name : (NSString *) sName {
    NSBundle *b = [NSBundle bundleForClass:cls];
    NSString *bName = b.infoDictionary[@"CFBundleName"];
    NSString *sc = [NSString stringWithFormat:@"%ld",(NSInteger)UIScreen.mainScreen.scale];
    NSString *temp = [[[sName stringByAppendingString:@"@"] stringByAppendingString:sc] stringByAppendingString:@"x"];
    NSString *p = nil;
    if (sModule && sModule.length) {
        sModule = [sModule stringByReplacingOccurrencesOfString:@"/" withString:@""];
        p = [b pathForResource:temp
                        ofType:@"png"
                   inDirectory:[sModule stringByAppendingString:@".bundle"]];
    }
    else p = [b pathForResource:temp
                         ofType:@"png"
                    inDirectory:[bName stringByAppendingString:@".bundle"]];
    UIImage *image = [UIImage imageWithContentsOfFile:p];
#if DEBUG
    if (!image) NSLog(@"\n ----- [MQExtensionKit] image Named \"%@\" with class \"%@\" not found , return new image istead",sName,NSStringFromClass(cls));
#endif
    return (image ? image : UIImage.new);
}
+ (instancetype) mq_name : (NSString *) sName {
    return [self imageNamed:sName];
}
+ (instancetype) mq_name : (NSString *) sName
                  bundle : (NSBundle *) bundle {
    return [self imageNamed:sName
                   inBundle:bundle
compatibleWithTraitCollection:nil];
}
+ (instancetype) mq_file : (NSString *) sPath {
    return [UIImage imageWithContentsOfFile:sPath];
}

+ (instancetype) mq_capture_current {
    return MQ_CAPTURE_WINDOW(nil);
}

@end

#pragma mark - -----
@import Accelerate;
@import CoreImage;

CGFloat _MQ_GAUSSIAN_BLUR_VALUE_ = 4.f;
CGFloat _MQ_GAUSSIAN_BLUR_TINT_ALPHA_ = .25f;

@implementation UIImage (MQExtension_Gaussian)

- (instancetype) mq_gaussian_acc {
    return [self mq_gaussian_acc:_MQ_GAUSSIAN_BLUR_VALUE_];
}
- (instancetype) mq_gaussian_acc : (CGFloat) fRadius {
    return [self mq_gaussian_acc:fRadius tint:UIColor.clearColor];
}
- (instancetype) mq_gaussian_acc : (CGFloat) fRadius
                            tint : (UIColor *) tint {
    UIImage *imageOriginal = [self copy];
    
    CGFloat fSaturationDeltaFactor = 1;
    UIImage *imageMask = nil;
    
    CGRect rectImage = (CGRect){CGPointZero, imageOriginal.size};
    UIImage *imageEffect = imageOriginal;
    
    BOOL isHasBlur = fRadius > __FLT_EPSILON__;
    BOOL isHasSaturationChange = fabs(fSaturationDeltaFactor - 1.) > __FLT_EPSILON__;
    if (isHasBlur || isHasSaturationChange) {
        UIGraphicsBeginImageContextWithOptions(imageOriginal.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef contextEffect = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(contextEffect, 1.0, -1.0);
        CGContextTranslateCTM(contextEffect, 0, -imageOriginal.size.height);
        CGContextDrawImage(contextEffect, rectImage, imageOriginal.CGImage);
        
        vImage_Buffer bufferEffect;
        bufferEffect.data = CGBitmapContextGetData(contextEffect);
        bufferEffect.width = CGBitmapContextGetWidth(contextEffect);
        bufferEffect.height = CGBitmapContextGetHeight(contextEffect);
        bufferEffect.rowBytes = CGBitmapContextGetBytesPerRow(contextEffect);
        
        UIGraphicsBeginImageContextWithOptions(imageOriginal.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef contextOutEffect = UIGraphicsGetCurrentContext();
        vImage_Buffer bufferOutEffect;
        bufferOutEffect.data = CGBitmapContextGetData(contextOutEffect);
        bufferOutEffect.width = CGBitmapContextGetWidth(contextOutEffect);
        bufferOutEffect.height = CGBitmapContextGetHeight(contextOutEffect);
        bufferOutEffect.rowBytes = CGBitmapContextGetBytesPerRow(contextOutEffect);
        
        if (isHasBlur) {
            CGFloat fInputRadius = fRadius * [[UIScreen mainScreen] scale];
            uint32_t radius = floor(fInputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
            if (radius % 2 != 1) {
                radius += 1;
            }
            vImageBoxConvolve_ARGB8888(&bufferEffect, &bufferOutEffect, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&bufferOutEffect, &bufferEffect, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&bufferEffect, &bufferOutEffect, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
        }
        BOOL isEffectImageBuffersAreSwapped = NO;
        if (isHasSaturationChange) {
            CGFloat s = fSaturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[] = {
                0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                0,                    0,                    0,  1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
            }
            if (isHasBlur) {
                vImageMatrixMultiply_ARGB8888(&bufferOutEffect, &bufferEffect, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                isEffectImageBuffersAreSwapped = YES;
            }
            else {
                vImageMatrixMultiply_ARGB8888(&bufferEffect, &bufferOutEffect, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        if (!isEffectImageBuffersAreSwapped) imageEffect = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if (isEffectImageBuffersAreSwapped) imageEffect = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    UIGraphicsBeginImageContextWithOptions(imageOriginal.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -imageOriginal.size.height);
    
    CGContextDrawImage(outputContext, rectImage, imageOriginal.CGImage);
    
    if (isHasBlur) {
        CGContextSaveGState(outputContext);
        if (imageMask) {
            CGContextClipToMask(outputContext, rectImage, imageMask.CGImage);
        }
        CGContextDrawImage(outputContext, rectImage, imageEffect.CGImage);
        CGContextRestoreGState(outputContext);
    }
    
    if (tint) {
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tint.CGColor);
        CGContextFillRect(outputContext, rectImage);
        CGContextRestoreGState(outputContext);
    }
    
    UIImage *imageOutput = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageOutput;
}
- (instancetype) mq_gaussian_acc : (CGFloat)fRadius
                            tint : (UIColor *) tint
                        complete : (void(^)(UIImage *origin , UIImage *processed)) complete {
    __weak typeof(self) pSelf = self;
    void (^tp)(void) = ^ {
        UIImage *m = [pSelf mq_gaussian_acc:fRadius tint:tint];
        if (NSThread.isMainThread) {
            if (complete) complete(pSelf , m);
        } else dispatch_sync(dispatch_get_main_queue(), ^{
            if (complete) complete(pSelf , m);
        });
    };
    if (@available(iOS 10.0, *)) {
        dispatch_async(dispatch_queue_create("MQExtensionKit.image.operate", DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL), ^{
            if (tp) tp();
        });
    } else {
        dispatch_async(dispatch_queue_create("MQExtensionKit.image.operate", DISPATCH_QUEUE_CONCURRENT), ^{
            if (tp) tp();
        });
    }
    
    return pSelf;
}

- (instancetype) mq_gaussian_CI {
    return [self mq_gaussian_CI:_MQ_GAUSSIAN_BLUR_VALUE_];
}
- (instancetype) mq_gaussian_CI : (CGFloat) fRadius {
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
- (instancetype) mq_gaussian_CI : (CGFloat) fRadius
                       complete : (void(^)(UIImage *origin , UIImage *processed)) complete {
    __weak typeof(self) pSelf = self;
    void (^tp)(void) = ^ {
        UIImage *m = [pSelf mq_gaussian_CI:fRadius];
        if (NSThread.isMainThread) {
            if (complete) complete(pSelf , m);
        } else dispatch_sync(dispatch_get_main_queue(), ^{
            if (complete) complete(pSelf , m);
        });
    };
    
    if (@available(iOS 10.0, *)) {
        dispatch_async(dispatch_queue_create("MQExtensionKit.image.operate", DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL), ^{
            if (tp) tp();
        });
    } else {
        dispatch_async(dispatch_queue_create("MQExtensionKit.image.operate", DISPATCH_QUEUE_CONCURRENT), ^{
            if (tp) tp();
        });
    }

    return self;
}

@end

#pragma mark - -----

@implementation UIImage (MQExtension_Data)

CGFloat _MQ_IMAGE_JPEG_COMPRESSION_QUALITY_SIZE_ = 400.f;

- (NSData *)toData {
    NSData *d = nil;
    if ((d = UIImagePNGRepresentation(self))) return d;
    if ((d = UIImageJPEGRepresentation(self, .0f))) return d;
    return d;
}

- (NSData *) mq_compresss_JPEG : (CGFloat) fQuility {
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

- (BOOL) mq_is_over_limit_for : (CGFloat) fMBytes {
    return self.toData.length / powl(1024, 2) > fMBytes;
}

@end

#pragma mark - -----

@implementation NSData (MQExtension_Image)

- (MQImageType)type {
    NSData *data = [self copy];
    if (!data) return MQImageType_Unknow;
    
    UInt8 c = 0;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF: return MQImageType_JPEG;
        case 0x89: return MQImageType_PNG;
        case 0x47: return MQImageType_Gif;
        case 0x49:
        case 0x4D: return MQImageType_Tiff;
        case 0x52:{
            if (data.length < 12) {
                return MQImageType_Unknow;
            }
            // 0x52 == 'R' , and R is Riff for WEBP 
            NSString *s = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)]
                                                encoding:NSASCIIStringEncoding];
            if ([s hasPrefix:@"RIFF"] && [s hasSuffix:@"WEBP"]) {
                return MQImageType_WebP;
            }
        }
            
        default:
            return MQImageType_Unknow;
            break;
    }
    return MQImageType_Unknow;
}

@end

#pragma mark - -----

@implementation UIImageView (MQExtension_Gaussian)

- (instancetype) mq_gaussian {
    if (self.image) self.image = [self.image mq_gaussian_acc];
    return self;
}
- (instancetype) mq_gaussian : (CGFloat) fRadius {
    if (self.image) self.image = [self.image mq_gaussian_acc:fRadius];
    return self;
}

@end
