//
//  UIImage+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/12.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , CCImageType) {
    CCImageTypeUnknow = 0 ,
    CCImageTypeJPEG ,
    CCImageTypePNG ,
    CCImageTypeGif ,
    CCImageTypeTiff
};

@interface UIImage (CCExtension)

@property (nonatomic , readonly) CGFloat width ;
@property (nonatomic , readonly) CGFloat height ;

@property (nonatomic , readonly) UIImage * gaussianImageAcc ;
@property (nonatomic , readonly) UIImage * gaussianImageCI ;

+ (instancetype) ccGenerate : (UIColor *) color;
+ (instancetype) ccGenerate : (UIColor *)color
                       size : (CGFloat) floatSize ;

- (instancetype) ccGaussianImageAcc ;
- (instancetype) ccGaussianImageAcc : (CGFloat) floatValue ;
- (instancetype) ccGaussianImageAcc : (CGFloat) floatValue
                     iterationCount : (NSInteger) iCount
                               tint : (UIColor *) color ;
- (void) ccGaussianImageAcc : (CGFloat) floatValue
             iterationCount : (NSInteger) iCount
                       tint : (UIColor *) color
                   complete : (void(^)(UIImage *imageOrigin , UIImage *imageProcessed)) block;

- (instancetype) ccGaussianImageCI ;
- (instancetype) ccGaussianImageCI : (CGFloat) floatValue ;
- (void) ccGaussianImageCI : (CGFloat) floatValue
                  complete : (void(^)(UIImage *imageOrigin , UIImage *imageProcessed)) block;

+ (instancetype) ccImage : (NSString *) stringImageName ;
+ (instancetype) ccImage : (NSString *) stringImageName
                  isFile : (BOOL) isFile ;
+ (instancetype) ccImage : (NSString *) stringImageName
                  isFile : (BOOL) isFile
           renderingMode : (UIImageRenderingMode) mode;
+ (instancetype) ccImage : (NSString *) stringImageName
                  isFile : (BOOL) isFile
           renderingMode : (UIImageRenderingMode) mode
      resizableCapInsets : (UIEdgeInsets) insets ;

- (NSData *) ccImageDataStream : (void (^)(CCImageType type , NSData *dataImage)) block ;
- (CCImageType) ccType : (NSData *) data ; // 同样是先转换为 Data 再进行判断 

/// 只针对 UIImage 起效
- (NSData *) ccCompressQuality ;
- (NSData *) ccCompressQuality : (CGFloat) floatQuality ; // 压缩大小限制 , kb 单位
- (BOOL) ccIsOverLimit_3M ; // iOS 是千进制, 所以 3M 限制定在 2.9
- (BOOL) ccIsOverLimit : (CGFloat) floatMBytes ;

@end
