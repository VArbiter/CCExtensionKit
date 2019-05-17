//
//  UIImage+MQExtension.m
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/4/12.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UIImage+MQExtension.h"

#import <CoreGraphics/CoreGraphics.h>

UIImage * mq_capture_window(UIWindow *window) {
    UIWindow *w = [UIApplication sharedApplication].windows.firstObject;
    if (window) w = window;
    
    UIGraphicsBeginImageContext(w.frame.size);
    [w.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

UIImage * mq_launch_image(void) {
    CGSize size_t = [UIScreen mainScreen].bounds.size;
    
    NSString *s_orientation = nil;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (( orientation == UIInterfaceOrientationPortraitUpsideDown)
        || (orientation == UIInterfaceOrientationPortrait)) {
        s_orientation = @"Portrait";
    } else {
        s_orientation = @"Landscape";
    }
    
    NSString *s_launch_image = nil;
    
    NSArray * array_images = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary * d_info in array_images) {
        CGSize size_image = CGSizeFromString(d_info[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(size_image, size_t)
            && [s_orientation isEqualToString:d_info[@"UILaunchImageOrientation"]]) {
            s_launch_image = d_info[@"UILaunchImageName"];
        }
    }
    
    UIImage *image = [UIImage imageNamed:s_launch_image] ;
    
    return image ? image : [UIImage imageNamed:@"LaunchImage"];
}

@implementation UIImage (MQExtension)

/// for image size && width
- (CGFloat)width {
    return self.size.width;
}
- (CGFloat)height {
    return self.size.height;
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
                      name : (NSString *) s_name {
    return [self mq_bundle:cls
                    module:nil
                      name:s_name];
}
+ (instancetype) mq_bundle : (Class) cls
                    module : (NSString *) s_module
                      name : (NSString *) s_name {
    NSBundle *b = [NSBundle bundleForClass:cls];
    NSString *b_name = b.infoDictionary[@"CFBundleName"];
    NSString *sc = [NSString stringWithFormat:@"%ld",(long)UIScreen.mainScreen.scale];
    NSString *temp = [[[s_name stringByAppendingString:@"@"] stringByAppendingString:sc] stringByAppendingString:@"x"];
    NSString *p = nil;
    if (s_module && s_module.length) {
        s_module = [s_module stringByReplacingOccurrencesOfString:@"/" withString:@""];
        p = [b pathForResource:temp
                        ofType:@"png"
                   inDirectory:[s_module stringByAppendingString:@".bundle"]];
    }
    else p = [b pathForResource:temp
                         ofType:@"png"
                    inDirectory:[b_name stringByAppendingString:@".bundle"]];
    UIImage *image = [UIImage imageWithContentsOfFile:p];
#if DEBUG
    if (!image) NSLog(@"\n ----- [MQExtensionKit] image Named \"%@\" with class \"%@\" not found , return new image istead",s_name,NSStringFromClass(cls));
#endif
    return (image ? image : UIImage.new);
}
+ (instancetype) mq_name : (NSString *) s_name {
    return [self imageNamed:s_name];
}
+ (instancetype) mq_name : (NSString *) s_name
                  bundle : (NSBundle *) bundle {
    return [self imageNamed:s_name
                   inBundle:bundle
compatibleWithTraitCollection:nil];
}
+ (instancetype) mq_file : (NSString *) s_path {
    return [UIImage imageWithContentsOfFile:s_path];
}

+ (instancetype) mq_capture_current {
    return mq_capture_window(nil);
}

@end

#pragma mark - -----

@implementation UIImage (MQExtension_Operate)

/// scale size with radius
+ (instancetype) mq_zoom_ratio : (CGFloat) f_radius
                         image : (UIImage *) image {
    if (f_radius > .0f && image) {
        CGFloat ratio = image.height / image.width;
        CGFloat ratio_width = image.width * f_radius;
        CGFloat ratio_height = ratio_width * ratio;
        CGSize size = CGSizeMake(ratio_width, ratio_height);
        
        UIGraphicsBeginImageContext(size);
        [image drawInRect:(CGRect){.size = size}];
        UIImage *image_resize = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image_resize;
    }
    return image;
}
+ (instancetype) mq_zoom_size : (CGSize) size
                        image : (UIImage *) image {
    if (image) {
        UIGraphicsBeginImageContext(size);
        [image drawInRect:(CGRect){.size = size}];
        UIImage *image_resize = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image_resize;
    }
    return image;
}

+ (CGContextRef) mq_create_ARGB_bitmap_context :(CGImageRef) image_ref {
    
    /*
        found : https://www.aliyun.com/jiaocheng/351202.html
     */
    
    CGContextRef context = NULL;
    CGColorSpaceRef color_space;
    void * bitmap_data;
    int bitmap_byte_count;
    int bitmap_bytes_per_row;
    
    // Get image width, height. We'll use the entire image.
    size_t pixels_width = CGImageGetWidth(image_ref);
    size_t pixels_height = CGImageGetHeight(image_ref);
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmap_bytes_per_row = (int)(pixels_width * 4);
    bitmap_byte_count =(int)(bitmap_bytes_per_row * pixels_height);
    // Use the generic RGB color space.
    color_space = CGColorSpaceCreateDeviceRGB();
    if (!color_space) {
        fprintf(stderr, "Error allocating color space/n");
        return NULL;
    }
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmap_data = malloc( bitmap_byte_count );
    if (!bitmap_data) {
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( color_space );
        return NULL;
    }
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate (bitmap_data,
                                     pixels_width,
                                     pixels_height,
                                     8,// bits per component
                                     bitmap_bytes_per_row,
                                     color_space,
                                     kCGImageAlphaPremultipliedFirst);
    if (!context) {
        free (bitmap_data);
        fprintf (stderr, "Context not created!");
    }
    // Make sure and release colorspace before returning
    CGColorSpaceRelease( color_space );
    return context;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wunused-variable"
+ (UIColor *) mq_pixel_color_in_point : (CGPoint) point
                                image : (UIImage *) image {
    UIColor * color = nil;
    CGImageRef image_ref = image.CGImage;
    CGContextRef context = [UIImage mq_create_ARGB_bitmap_context:image_ref];
    
    if (!context) { return nil; }
    size_t w = CGImageGetWidth(image_ref);
    size_t h = CGImageGetHeight(image_ref);
    CGRect rect = (CGRect){.size = {w,h}} ;
    
    CGContextDrawImage(context, rect, image_ref);
    
    unsigned char * data = CGBitmapContextGetData (context);
    
    if (data) {
        int offset = 4 * ((w * round(point.y)) + round(point.x));
        
        int a = data[offset];
        int r = data[offset + 1];
        int g = data[offset + 2];
        int b = data[offset + 3];
        
#if DEBUG
        NSLog(@"offset: %i colors: RGB A %i %i %i  %i", offset,
              r, g, b, a);
        NSLog(@"x:%f y:%f", point.x, point.y);
#endif
        CGFloat f = 255.f;
        color = [UIColor colorWithRed:(r / f)
                                green:(g / f)
                                 blue:(b / f)
                                alpha:(1 / f)];
    }
    CGContextRelease(context);
    
    if (data) { free(data); }
    
    return color;
}
#pragma clang diagnostic pop

@end

#pragma mark - -----
@import Accelerate;
@import CoreImage;

CGFloat mq_gaussian_blur_value = 4.f;
CGFloat mq_gaussian_blur_tint_alpha = .25f;

@implementation UIImage (MQExtension_Gaussian)

- (instancetype) mq_gaussian_acc {
    return [self mq_gaussian_acc:mq_gaussian_blur_value];
}
- (instancetype) mq_gaussian_acc : (CGFloat) f_radius {
    return [self mq_gaussian_acc:f_radius tint:UIColor.clearColor];
}
- (instancetype) mq_gaussian_acc : (CGFloat) f_radius
                            tint : (UIColor *) tint {
    UIImage *image_original = [self copy];
    
    CGFloat f_saturation_delta_factor = 1;
    UIImage *image_mask = nil;
    
    CGRect rect_image = (CGRect){CGPointZero, image_original.size};
    UIImage *image_effect = image_original;
    
    BOOL is_has_blur = f_radius > __FLT_EPSILON__;
    BOOL is_has_saturation_change = fabs(f_saturation_delta_factor - 1.f) > __FLT_EPSILON__;
    if (is_has_blur || is_has_saturation_change) {
        UIGraphicsBeginImageContextWithOptions(image_original.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef context_effect = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(context_effect, 1.0, -1.0);
        CGContextTranslateCTM(context_effect, 0, -image_original.size.height);
        CGContextDrawImage(context_effect, rect_image, image_original.CGImage);
        
        vImage_Buffer buffer_effect;
        buffer_effect.data = CGBitmapContextGetData(context_effect);
        buffer_effect.width = CGBitmapContextGetWidth(context_effect);
        buffer_effect.height = CGBitmapContextGetHeight(context_effect);
        buffer_effect.rowBytes = CGBitmapContextGetBytesPerRow(context_effect);
        
        UIGraphicsBeginImageContextWithOptions(image_original.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef context_out_effect = UIGraphicsGetCurrentContext();
        vImage_Buffer buffer_out_effect;
        buffer_out_effect.data = CGBitmapContextGetData(context_out_effect);
        buffer_out_effect.width = CGBitmapContextGetWidth(context_out_effect);
        buffer_out_effect.height = CGBitmapContextGetHeight(context_out_effect);
        buffer_out_effect.rowBytes = CGBitmapContextGetBytesPerRow(context_out_effect);
        
        if (is_has_blur) {
            CGFloat f_input_radius = f_radius * [[UIScreen mainScreen] scale];
            uint32_t radius = floor(f_input_radius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
            if (radius % 2 != 1) {
                radius += 1;
            }
            vImageBoxConvolve_ARGB8888(&buffer_effect, &buffer_out_effect, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&buffer_out_effect, &buffer_effect, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&buffer_effect, &buffer_out_effect, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
        }
        BOOL is_effect_image_buffers_are_swapped = NO;
        if (is_has_saturation_change) {
            CGFloat s = f_saturation_delta_factor;
            CGFloat floating_point_saturation_matrix[] = {
                0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                0,                    0,                    0,  1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floating_point_saturation_matrix)/sizeof(floating_point_saturation_matrix[0]);
            int16_t saturationMatrix[matrixSize];
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                saturationMatrix[i] = (int16_t)roundf(floating_point_saturation_matrix[i] * divisor);
            }
            if (is_has_blur) {
                vImageMatrixMultiply_ARGB8888(&buffer_out_effect, &buffer_effect, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                is_effect_image_buffers_are_swapped = YES;
            }
            else {
                vImageMatrixMultiply_ARGB8888(&buffer_effect, &buffer_out_effect, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        if (!is_effect_image_buffers_are_swapped) image_effect = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if (is_effect_image_buffers_are_swapped) image_effect = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    UIGraphicsBeginImageContextWithOptions(image_original.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef output_context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(output_context, 1.0, -1.0);
    CGContextTranslateCTM(output_context, 0, -image_original.size.height);
    
    CGContextDrawImage(output_context, rect_image, image_original.CGImage);
    
    if (is_has_blur) {
        CGContextSaveGState(output_context);
        if (image_mask) {
            CGContextClipToMask(output_context, rect_image, image_mask.CGImage);
        }
        CGContextDrawImage(output_context, rect_image, image_effect.CGImage);
        CGContextRestoreGState(output_context);
    }
    
    if (tint) {
        CGContextSaveGState(output_context);
        CGContextSetFillColorWithColor(output_context, tint.CGColor);
        CGContextFillRect(output_context, rect_image);
        CGContextRestoreGState(output_context);
    }
    
    UIImage *image_output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image_output;
}
- (instancetype) mq_gaussian_acc : (CGFloat)f_radius
                            tint : (UIColor *) tint
                        complete : (void(^)(UIImage *origin , UIImage *processed)) complete {
    __weak typeof(self) weak_self = self;
    void (^tp)(void) = ^ {
        __strong typeof(weak_self) strong_self = weak_self;
        UIImage *m = [strong_self mq_gaussian_acc:f_radius tint:tint];
        if (NSThread.isMainThread) {
            if (complete) complete(strong_self , m);
        } else dispatch_sync(dispatch_get_main_queue(), ^{
            if (complete) complete(strong_self , m);
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

- (instancetype) mq_gaussian_CI {
    return [self mq_gaussian_CI:mq_gaussian_blur_value];
}
- (instancetype) mq_gaussian_CI : (CGFloat) f_radius {
    UIImage *image = [self copy];
    if (!image) return self;
    
    CIContext *context = [CIContext contextWithOptions:@{kCIContextPriorityRequestLow : @(YES)}];
    CIImage *image_input= [CIImage imageWithCGImage:image.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:image_input forKey:kCIInputImageKey];
    [filter setValue:@(f_radius) forKey: @"inputRadius"];
    
    CIImage *imageResult = [filter valueForKey:kCIOutputImageKey];
    CGImageRef imageOutput = [context createCGImage:imageResult
                                           fromRect:[imageResult extent]];
    UIImage *imageBlur = [UIImage imageWithCGImage:imageOutput];
    CGImageRelease(imageOutput);
    
    return imageBlur;
}
- (instancetype) mq_gaussian_CI : (CGFloat) f_radius
                       complete : (void(^)(UIImage *origin , UIImage *processed)) complete {
    __weak typeof(self) weak_self = self;
    void (^tp)(void) = ^ {
        __strong typeof(weak_self) strong_self = weak_self;
        UIImage *m = [strong_self mq_gaussian_CI:f_radius];
        if (NSThread.isMainThread) {
            if (complete) complete(strong_self , m);
        } else dispatch_sync(dispatch_get_main_queue(), ^{
            if (complete) complete(strong_self , m);
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

CGFloat mq_image_jpeg_compression_quality_size = 400.f;

- (NSData *)to_data {
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

- (BOOL) mq_is_over_limit_for : (CGFloat) f_MBytes {
    return self.to_data.length / powl(1024, 2) > f_MBytes;
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
- (instancetype) mq_gaussian : (CGFloat) f_radius {
    if (self.image) self.image = [self.image mq_gaussian_acc:f_radius];
    return self;
}

@end
