//
//  UIImage+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/12.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef CC_IMAGE_B
    #define CC_IMAGE_B(_value_) [UIImage cc_bundle:self.class name:(_value_)]
#endif

#ifndef CC_IMAGE_MODULE_B
    #define CC_IMAGE_MODULE_B(_module_,_value_) [UIImage cc_bundle:self.class module:(_module_) name:(_value_)]
#endif

#ifndef CC_IMAGE_NAME
    #define CC_IMAGE_NAME(_value_) [UIImage cc_name:(_value_)]
#endif

#ifndef CC_IMAGE_FILE
    #define CC_IMAGE_FILE(_value_) [UIImage cc_file:(_value_)]
#endif

#ifndef CC_IMAGE_BUNDLE
    #define CC_IMAGE_BUNDLE(_vName_,_vBundle_) [UIImage cc_name:(_vName_) bundle:(_vBundle_)]
#endif

UIImage * CC_CAPTURE_WINDOW(UIWindow *window);

@interface UIImage (CCExtension)

/// for image size && width // 获得 image 的宽和高
@property (nonatomic , readonly) CGFloat width ;
@property (nonatomic , readonly) CGFloat height ;

/// scale size with radius // 按比例缩放图片
- (CGSize) cc_zoom : (CGFloat) fRadius ;
- (instancetype) cc_resizable : (UIEdgeInsets) insets ;
- (instancetype) cc_rendaring : (UIImageRenderingMode) mode ;
- (instancetype) cc_always_original ;

/// class , imageName // 类名 , 图片名称
+ (instancetype) cc_bundle : (Class) cls
                      name : (NSString *) sName;
+ (instancetype) cc_bundle : (Class) cls
                    module : (NSString *) sModule // the module for archiving bundle . // 用来打包的 module
                      name : (NSString *) sName ;
+ (instancetype) cc_name : (NSString *) sName ;
+ (instancetype) cc_name : (NSString *) sName
                  bundle : (NSBundle *) bundle ;
+ (instancetype) cc_file : (NSString *) sPath ;

/// create an image with current window // 对当前 window 进行截图
+ (instancetype) cc_capture_current ;

@end

#pragma mark - -----

@interface UIImage (CCExtension_Gaussian)

FOUNDATION_EXPORT CGFloat _CC_GAUSSIAN_BLUR_VALUE_ ;
FOUNDATION_EXPORT CGFloat _CC_GAUSSIAN_BLUR_TINT_ALPHA_ ;

// for blur issues // 针对模糊

/// using Accelerate // 使用 Accelerate 框架
- (instancetype) cc_gaussian_acc ;
- (instancetype) cc_gaussian_acc : (CGFloat) fRadius ;
- (instancetype) cc_gaussian_acc : (CGFloat) fRadius
                            tint : (UIColor *) tint ;
- (instancetype) cc_gaussian_acc : (CGFloat) fRadius
                            tint : (UIColor *) tint
                        complete : (void(^)(UIImage *origin , UIImage *processed)) complete ;

/// using CoreImage // 使用 CoreImage 框架
- (instancetype) cc_gaussian_CI ; // sync , not recommended // 同步 , 不建议
- (instancetype) cc_gaussian_CI : (CGFloat) fRadius ; // sync , not recommended // 同步 , 不建议
- (instancetype) cc_gaussian_CI : (CGFloat) fRadius
                       complete : (void(^)(UIImage *origin , UIImage *processed)) complete ; // async


@end

#pragma mark - -----

@interface UIImage (CCExtension_Data)

FOUNDATION_EXPORT CGFloat _CC_IMAGE_JPEG_COMPRESSION_QUALITY_SIZE_ ; // 400 kb

// available for PNG && JPEG // 对于 PNG 和 JPEG 起效

@property (nonatomic , readonly) NSData *toData ;
/// compress and limit it with in a fitable range . // 压缩 , 并限制图片在合适的大小
- (NSData *) cc_compresss_JPEG : (CGFloat) fQuility;
/// arguments with Mbytes . // 参数是 兆 为单位的
- (BOOL) cc_is_over_limit_for : (CGFloat) fMBytes ;

@end

#pragma mark - -----

typedef NS_ENUM(NSInteger , CCImageType) {
    CCImageType_Unknow = 0 ,
    CCImageType_JPEG ,
    CCImageType_PNG ,
    CCImageType_Gif ,
    CCImageType_Tiff ,
    CCImageType_WebP
};

@interface NSData (CCExtension_Image)

/// technically , you have to read all 8-Bytes length to specific an imageType . // 从技术角度上来说 , 你必须读取所有的 8 个字节才能确定一张图片的类型
/// for now , i just use the first to decide is type . (borrowed from SDWebImage) . // 目前 , 我只是读取了首个 , (借鉴自 SDWebImage)
@property (nonatomic , readonly) CCImageType type ;

@end

#pragma mark - -----

@interface UIImageView (CCExtension_Gaussian)

/// using Accelerate // 使用 Accelerate 框架

- (instancetype) cc_gaussian ;
- (instancetype) cc_gaussian : (CGFloat) fRadius;

@end
