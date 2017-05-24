//
//  UIImage+YMExtension.h
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/4/12.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , UIImageType) {
    UIImageTypeUnknow = 0 ,
    UIImageTypeJPEG ,
    UIImageTypePNG
};

@interface UIImage (YMExtension)

+ (instancetype) ymGenerateImageWithColor : (UIColor *) color;
+ (instancetype) ymGenerateImageWithColor : (UIColor *)color
                                 withSize : (CGFloat) floatSize ;

- (instancetype) ymGaussianImage ;
- (instancetype) ymGaussianImage : (CGFloat) floatValue
               withCompleteBlock : (void(^)(UIImage *imageOrigin , UIImage *imageProcessed)) block;

+ (instancetype) ymImageNamed : (NSString *) stringImageName ;
+ (instancetype) ymImageNamed : (NSString *) stringImageName
                   withIsFile : (BOOL) isFile ;
+ (instancetype) ymImageNamed : (NSString *) stringImageName
                   withIsFile : (BOOL) isFile
            withRenderingMode : (UIImageRenderingMode) mode;
+ (instancetype) ymImageNamed : (NSString *) stringImageName
                   withIsFile : (BOOL) isFile
            withRenderingMode : (UIImageRenderingMode) mode
       withResizableCapInsets : (UIEdgeInsets) insets ;

- (NSData *) ymImageDataStreamWithBlock : (void (^)(UIImageType type , NSData *dataImage)) block ;
- (UIImageType) ymImageType ; // 同样是先转换为 Data 再进行判断 , 若需要用到 data , 用上面的就行 .

/// 只针对 UIImage 起效
- (NSData *) ymCompressQuality ;
- (NSData *) ymCompressQuality : (CGFloat) floatQuality ; // 压缩大小限制 , kb 单位
- (BOOL) ymIsOverLimit_3M ; // iOS 是千进制, 所以 3M 限制定在 2.9
- (BOOL) ymIsOverLimit : (CGFloat) floatMBytes ;

@end
