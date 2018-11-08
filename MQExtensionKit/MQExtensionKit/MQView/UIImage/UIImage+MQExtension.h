//
//  UIImage+MQExtension.h
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/4/12.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef MQ_IMAGE_B
    #define MQ_IMAGE_B(_value_) [UIImage mq_bundle:self.class name:(_value_)]
#endif

#ifndef MQ_IMAGE_MODULE_B
    #define MQ_IMAGE_MODULE_B(_module_,_value_) [UIImage mq_bundle:self.class module:(_module_) name:(_value_)]
#endif

#ifndef MQ_IMAGE_NAME
    #define MQ_IMAGE_NAME(_value_) [UIImage mq_name:(_value_)]
#endif

#ifndef MQ_IMAGE_FILE
    #define MQ_IMAGE_FILE(_value_) [UIImage mq_file:(_value_)]
#endif

#ifndef MQ_IMAGE_BUNDLE
    #define MQ_IMAGE_BUNDLE(_vBundle_,_vName_) [UIImage mq_name:(_vName_) bundle:(_vBundle_)]
#endif

UIImage * mq_capture_window(UIWindow *window);
UIImage * mq_launch_image(void);

@interface UIImage (MQExtension)

/// for image size && width // 获得 image 的宽和高
@property (nonatomic , readonly) CGFloat width ;
@property (nonatomic , readonly) CGFloat height ;

/// scale size with radius // 按比例缩放图片
- (CGSize) mq_zoom : (CGFloat) fRadius ;
- (instancetype) mq_resizable : (UIEdgeInsets) insets ;
- (instancetype) mq_rendaring : (UIImageRenderingMode) mode ;
- (instancetype) mq_always_original ;

/// class , imageName // 类名 , 图片名称
+ (instancetype) mq_bundle : (Class) cls
                      name : (NSString *) sName;
+ (instancetype) mq_bundle : (Class) cls
                    module : (NSString *) sModule // the module for archiving bundle . // 用来打包的 module
                      name : (NSString *) sName ;
+ (instancetype) mq_name : (NSString *) sName ;
+ (instancetype) mq_name : (NSString *) sName
                  bundle : (NSBundle *) bundle ;
+ (instancetype) mq_file : (NSString *) sPath ;

/// create an image with current window // 对当前 window 进行截图
+ (instancetype) mq_capture_current ;

@end

#pragma mark - -----

@interface UIImage (MQExtension_Gaussian)

FOUNDATION_EXPORT CGFloat mq_gaussian_blur_value ;
FOUNDATION_EXPORT CGFloat mq_gaussian_blur_tint_alpha ;

// for blur issues // 针对模糊

/// using Accelerate // 使用 Accelerate 框架
- (instancetype) mq_gaussian_acc ;
- (instancetype) mq_gaussian_acc : (CGFloat) fRadius ;
- (instancetype) mq_gaussian_acc : (CGFloat) fRadius
                            tint : (UIColor *) tint ;
- (instancetype) mq_gaussian_acc : (CGFloat) fRadius
                            tint : (UIColor *) tint
                        complete : (void(^)(UIImage *origin , UIImage *processed)) complete ;

/// using CoreImage // 使用 CoreImage 框架
- (instancetype) mq_gaussian_CI ; // sync , not recommended // 同步 , 不建议
- (instancetype) mq_gaussian_CI : (CGFloat) fRadius ; // sync , not recommended // 同步 , 不建议
- (instancetype) mq_gaussian_CI : (CGFloat) fRadius
                       complete : (void(^)(UIImage *origin , UIImage *processed)) complete ; // async


@end

#pragma mark - -----

@interface UIImage (MQExtension_Data)

FOUNDATION_EXPORT CGFloat mq_image_jpeg_compression_quality_size ; // 400 kb

// available for PNG && JPEG // 对于 PNG 和 JPEG 起效

@property (nonatomic , readonly) NSData *toData ;
/// compress and limit it with in a fitable range . // 压缩 , 并限制图片在合适的大小
- (NSData *) mq_compresss_JPEG : (CGFloat) fQuility;
/// arguments with Mbytes . // 参数是 兆 为单位的
- (BOOL) mq_is_over_limit_for : (CGFloat) fMBytes ;

@end

#pragma mark - -----

typedef NS_ENUM(NSInteger , MQImageType) {
    MQImageType_Unknow = 0 ,
    MQImageType_JPEG ,
    MQImageType_PNG ,
    MQImageType_Gif ,
    MQImageType_Tiff ,
    MQImageType_WebP
};

@interface NSData (MQExtension_Image)

/// technically , you have to read all 8-Bytes length to specific an imageType . // 从技术角度上来说 , 你必须读取所有的 8 个字节才能确定一张图片的类型
/// for now , i just use the first to decide is type . (borrowed from SDWebImage) . // 目前 , 我只是读取了首个 , (借鉴自 SDWebImage)
@property (nonatomic , readonly) MQImageType type ;

@end

#pragma mark - -----

@interface UIImageView (MQExtension_Gaussian)

/// using Accelerate // 使用 Accelerate 框架

- (instancetype) mq_gaussian ;
- (instancetype) mq_gaussian : (CGFloat) fRadius;

@end
