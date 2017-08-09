//
//  UIImage+CCChain.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 09/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CCChain)

/// for image size && width
@property (nonatomic , assign , readonly) CGFloat width ;
@property (nonatomic , assign , readonly) CGFloat height ;

/// scale size with radius
@property (nonatomic , copy , readonly) CGSize (^zoom)(CGFloat radius);

@property (nonatomic , copy , readonly) UIImage *(^resizable)(UIEdgeInsets insets);
@property (nonatomic , copy , readonly) UIImage *(^rendering)(UIImageRenderingMode);

/// generate a image with colors.
@property (nonatomic , class , copy , readonly) UIImage *(^colorS)(UIColor *color);
@property (nonatomic , class , copy , readonly) UIImage *(^colorC)(UIColor *color , CGSize size);

/// class , imageName
@property (nonatomic , class , copy , readonly) UIImage *(^bundle)(Class clazz, NSString *sImage);
@property (nonatomic , class , copy , readonly) UIImage *(^named)(NSString *sImageName);
@property (nonatomic , class , copy , readonly) UIImage *(^namedB)(NSString *sImageName , NSBundle *bundle);
@property (nonatomic , class , copy , readonly) UIImage *(^file)(NSString *sPath);

/// for gaussianIssues


@end
