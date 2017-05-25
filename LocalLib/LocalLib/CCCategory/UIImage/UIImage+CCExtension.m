//
//  UIImage+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/12.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UIImage+CCExtension.h"
#import "CCCommonDefine.h"

//#import <CoreImage/CoreImage.h>
#import <Accelerate/Accelerate.h>

@implementation UIImage (CCExtension)

+ (instancetype) ccGenerateImageWithColor : (UIColor *) color {
    return [self ccGenerateImageWithColor:color
                                 withSize:.0f];
}

+ (instancetype) ccGenerateImageWithColor : (UIColor *)color
                                 withSize : (CGFloat) floatSize {
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

- (instancetype) ccGaussianImage {
    return [self ccGaussianImage:_CC_GAUSSIAN_BLUR_VALUE_
               withCompleteBlock:nil];
}
- (instancetype) ccGaussianImage : (CGFloat) floatValue
               withCompleteBlock : (void(^)(UIImage *imageOrigin , UIImage *imageProcessed)) block {
    __block UIImage *image = [self copy];
    if (!image) return self;
    
    __block CGFloat floatRadius = floatValue;
    
    // ios 10 DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL
    ccWeakSelf;
//    dispatch_async(dispatch_queue_create("queue_Background", DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL), ^{
    dispatch_async(dispatch_queue_create("queue_Background", DISPATCH_QUEUE_CONCURRENT), ^{
        /*
         // Core Image . 处理速度太慢 . 弃用 .
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
         
         pSelf.image = imageBlur;
         */
        
        if (floatRadius < 0.f || floatRadius > 1.f) {
            floatRadius = 0.5f;
        }
        int boxSize = (int)(floatRadius * 40);
        boxSize = boxSize - (boxSize % 2) + 1;
        
        CGImageRef img = image.CGImage;
        
        vImage_Buffer inBuffer, outBuffer;
        vImage_Error error;
        
        void *pixelBuffer;
        
        CGDataProviderRef inProvider = CGImageGetDataProvider(img);
        CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
        
        inBuffer.width = CGImageGetWidth(img);
        inBuffer.height = CGImageGetHeight(img);
        inBuffer.rowBytes = CGImageGetBytesPerRow(img);
        
        inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
        
        pixelBuffer = malloc(CGImageGetBytesPerRow(img) *
                             CGImageGetHeight(img));
        
        if(pixelBuffer == NULL)
            CCLog(@"No pixelbuffer");
        
        outBuffer.data = pixelBuffer;
        outBuffer.width = CGImageGetWidth(img);
        outBuffer.height = CGImageGetHeight(img);
        outBuffer.rowBytes = CGImageGetBytesPerRow(img);
        
        error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
        
        if (error) {
            CCLog(@"error from convolution %ld", error);
        }
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef ctx = CGBitmapContextCreate(
                                                 outBuffer.data,
                                                 outBuffer.width,
                                                 outBuffer.height,
                                                 8,
                                                 outBuffer.rowBytes,
                                                 colorSpace,
                                                 kCGImageAlphaNoneSkipLast);
        CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
        UIImage * imageProcessed = [UIImage imageWithCGImage:imageRef];
        
        //clean up
        CGContextRelease(ctx);
        CGColorSpaceRelease(colorSpace);
        
        free(pixelBuffer);
        CFRelease(inBitmapData);
        
        CGColorSpaceRelease(colorSpace);
        CGImageRelease(imageRef);
        
        _CC_Safe_UI_Block_(block, ^{
            block(pSelf , imageProcessed);
        });
    });
    
    return self;
}

+ (instancetype) ccImageNamed : (NSString *) stringImageName {
    return [self ccImageNamed:stringImageName
                   withIsFile:false];
}
+ (instancetype) ccImageNamed : (NSString *) stringImageName
                   withIsFile : (BOOL) isFile {
    return [self ccImageNamed:stringImageName
                   withIsFile:isFile
            withRenderingMode:UIImageRenderingModeAlwaysOriginal];
}
+ (instancetype) ccImageNamed : (NSString *) stringImageName
                   withIsFile : (BOOL) isFile
            withRenderingMode : (UIImageRenderingMode) mode {
    UIImage *image = isFile ? [UIImage imageWithContentsOfFile:stringImageName] : [UIImage imageNamed:stringImageName];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] ;
}
+ (instancetype) ccImageNamed : (NSString *) stringImageName
                   withIsFile : (BOOL) isFile
            withRenderingMode : (UIImageRenderingMode) mode
       withResizableCapInsets : (UIEdgeInsets) insets {
    UIImage *image = [self ccImageNamed:stringImageName
                             withIsFile:isFile
                      withRenderingMode:mode];
    return [image resizableImageWithCapInsets:insets];
}

- (NSData *) ccImageDataStreamWithBlock : (void (^)(CCImageType type , NSData *dataImage)) block {
    NSData *data = nil;
    if (self && [self isKindOfClass:[UIImage class]]) {
        if ((data = UIImagePNGRepresentation(self))) {
            _CC_Safe_Block_(block, ^{
                block(CCImageTypePNG , data);
            });
        }
        else if ((data = UIImageJPEGRepresentation(self, _CC_IMAGE_JPEG_COMPRESSION_QUALITY_))) {
            _CC_Safe_Block_(block, ^{
                block(CCImageTypeJPEG , data);
            });
        }
        else {
            _CC_Safe_Block_(block, ^{
                block(CCImageTypeUnknow , data);
            });
        }
    }
    return data;
}

- (CCImageType) ccImageType {
    NSData *dataImage = [self ccImageDataStreamWithBlock:nil];
    if (dataImage.length > 4) {
        const unsigned char * bytes = [dataImage bytes];
        if (bytes[0] == 0xff
            && bytes[1] == 0xd8
            && bytes[2] == 0xff) {
            return CCImageTypeJPEG;
        }
        if (bytes[0] == 0x89
            && bytes[1] == 0x50
            && bytes[2] == 0x4e
            && bytes[3] == 0x47) {
            return CCImageTypePNG;
        }
    }
    return CCImageTypeUnknow;
}

- (NSData *) ccCompressQuality {
    return [self ccCompressQuality:_CC_IMAGE_JPEG_COMPRESSION_QUALITY_SIZE_];
}
- (NSData *) ccCompressQuality : (CGFloat) floatQuality {
    NSData *dataOrigin = [self ccImageDataStreamWithBlock:nil];
    if (!dataOrigin) {
        return nil;
    }
    NSData *dataCompress = dataOrigin ;
    NSData *dataResult = dataOrigin;
    
    long long lengthData = dataCompress.length;
    NSInteger i = 0;
    for (NSInteger j = 0 ; j < 10; j ++) {
        if (lengthData / 1024.f > 300.f) {
            ++ i ;
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
    NSData *data = [self ccImageDataStreamWithBlock:nil];
    return [data length] / powl(1024, 2) > floatMBytes;
}

@end
