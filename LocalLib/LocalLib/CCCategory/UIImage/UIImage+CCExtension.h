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
    CCImageTypePNG
};

@interface UIImage (CCExtension)

+ (instancetype) ccGenerateImageWithColor : (UIColor *) color;
+ (instancetype) ccGenerateImageWithColor : (UIColor *)color
                                 withSize : (CGFloat) floatSize ;

- (instancetype) ccGaussianImage ;
- (instancetype) ccGaussianImage : (CGFloat) floatValue
               withCompleteBlock : (void(^)(UIImage *imageOrigin , UIImage *imageProcessed)) block;

+ (instancetype) ccImageNamed : (NSString *) stringImageName ;
+ (instancetype) ccImageNamed : (NSString *) stringImageName
                   withIsFile : (BOOL) isFile ;
+ (instancetype) ccImageNamed : (NSString *) stringImageName
                   withIsFile : (BOOL) isFile
            withRenderingMode : (UIImageRenderingMode) mode;
+ (instancetype) ccImageNamed : (NSString *) stringImageName
                   withIsFile : (BOOL) isFile
            withRenderingMode : (UIImageRenderingMode) mode
       withResizableCapInsets : (UIEdgeInsets) insets ;

- (NSData *) ccImageDataStreamWithBlock : (void (^)(CCImageType type , NSData *dataImage)) block ;
- (CCImageType) ccImageType ; // 同样是先转换为 Data 再进行判断 , 若需要用到 data , 用上面的就行 .

/// 只针对 UIImage 起效
- (NSData *) ccCompressQuality ;
- (NSData *) ccCompressQuality : (CGFloat) floatQuality ; // 压缩大小限制 , kb 单位
- (BOOL) ccIsOverLimit_3M ; // iOS 是千进制, 所以 3M 限制定在 2.9
- (BOOL) ccIsOverLimit : (CGFloat) floatMBytes ;

@end
