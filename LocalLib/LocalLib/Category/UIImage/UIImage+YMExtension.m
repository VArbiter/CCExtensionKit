//
//  UIImage+YMExtension.m
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/4/12.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UIImage+YMExtension.h"
#import "YMCommonDefine.h"

//#import <CoreImage/CoreImage.h>
#import <Accelerate/Accelerate.h>

@implementation UIImage (YMExtension)

+ (instancetype) ymGenerateImageWithColor : (UIColor *) color {
    return [self ymGenerateImageWithColor:color
                                 withSize:.0f];
}

+ (instancetype) ymGenerateImageWithColor : (UIColor *)color
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

- (instancetype) ymGaussianImage {
    return [self ymGaussianImage:_YM_GAUSSIAN_BLUR_VALUE_
               withCompleteBlock:nil];
}
- (instancetype) ymGaussianImage : (CGFloat) floatValue
               withCompleteBlock : (void(^)(UIImage *imageOrigin , UIImage *imageProcessed)) block {
    __block UIImage *image = [self copy];
    if (!image) return self;
    
    __block CGFloat floatRadius = floatValue;
    
    // ios 10 DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL
    ymWeakSelf;
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
            YMLog(@"No pixelbuffer");
        
        outBuffer.data = pixelBuffer;
        outBuffer.width = CGImageGetWidth(img);
        outBuffer.height = CGImageGetHeight(img);
        outBuffer.rowBytes = CGImageGetBytesPerRow(img);
        
        error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
        
        if (error) {
            YMLog(@"error from convolution %ld", error);
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
        
        _YM_Safe_UI_Block_(block, ^{
            block(pSelf , imageProcessed);
        });
    });
    
    return self;
}

+ (instancetype) ymImageNamed : (NSString *) stringImageName {
    return [self ymImageNamed:stringImageName
                   withIsFile:false];
}
+ (instancetype) ymImageNamed : (NSString *) stringImageName
                   withIsFile : (BOOL) isFile {
    return [self ymImageNamed:stringImageName
                   withIsFile:isFile
            withRenderingMode:UIImageRenderingModeAlwaysOriginal];
}
+ (instancetype) ymImageNamed : (NSString *) stringImageName
                   withIsFile : (BOOL) isFile
            withRenderingMode : (UIImageRenderingMode) mode {
    UIImage *image = isFile ? [UIImage imageWithContentsOfFile:stringImageName] : [UIImage imageNamed:stringImageName];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] ;
}
+ (instancetype) ymImageNamed : (NSString *) stringImageName
                   withIsFile : (BOOL) isFile
            withRenderingMode : (UIImageRenderingMode) mode
       withResizableCapInsets : (UIEdgeInsets) insets {
    UIImage *image = [self ymImageNamed:stringImageName
                             withIsFile:isFile
                      withRenderingMode:mode];
    return [image resizableImageWithCapInsets:insets];
}

- (NSData *) ymImageDataStreamWithBlock : (void (^)(UIImageType type , NSData *dataImage)) block {
    NSData *data = nil;
    if (self && [self isKindOfClass:[UIImage class]]) {
        if ((data = UIImagePNGRepresentation(self))) {
            _YM_Safe_Block_(block, ^{
                block(UIImageTypePNG , data);
            });
        }
        else if ((data = UIImageJPEGRepresentation(self, _YM_IMAGE_JPEG_COMPRESSION_QUALITY_))) {
            _YM_Safe_Block_(block, ^{
                block(UIImageTypeJPEG , data);
            });
        }
        else {
            _YM_Safe_Block_(block, ^{
                block(UIImageTypeUnknow , data);
            });
        }
    }
    return data;
}

- (UIImageType) ymImageType {
    NSData *dataImage = [self ymImageDataStreamWithBlock:nil];
    if (dataImage.length > 4) {
        const unsigned char * bytes = [dataImage bytes];
        if (bytes[0] == 0xff
            && bytes[1] == 0xd8
            && bytes[2] == 0xff) {
            return UIImageTypeJPEG;
        }
        if (bytes[0] == 0x89
            && bytes[1] == 0x50
            && bytes[2] == 0x4e
            && bytes[3] == 0x47) {
            return UIImageTypePNG;
        }
    }
    return UIImageTypeUnknow;
}

- (NSData *) ymCompressQuality {
    return [self ymCompressQuality:_YM_IMAGE_JPEG_COMPRESSION_QUALITY_SIZE_];
}
- (NSData *) ymCompressQuality : (CGFloat) floatQuality {
    NSData *dataOrigin = [self ymImageDataStreamWithBlock:nil];
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

- (BOOL) ymIsOverLimit_3M {
    return [self ymIsOverLimit:2.9f];
}
- (BOOL) ymIsOverLimit : (CGFloat) floatMBytes {
    NSData *data = [self ymImageDataStreamWithBlock:nil];
    return [data length] / powl(1024, 2) > floatMBytes;
}

@end
