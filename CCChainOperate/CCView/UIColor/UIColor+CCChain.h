//
//  UIColor+CCChain.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 09/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (CCChain)

@property (nonatomic , class , copy , readonly) UIColor *(^hex)(int value);
@property (nonatomic , class , copy , readonly) UIColor *(^hexA)(int value , double alpha);
@property (nonatomic , class , copy , readonly) UIColor *(^RGB)(double r , double g , double b);
@property (nonatomic , class , copy , readonly) UIColor *(^RGBA)(double r , double g , double b , double a);

@property (nonatomic , copy , readonly) UIColor *(^alphaS)(CGFloat alpha);
/// generate a image that size equals (CGSize){1.f , 1.f}
@property (nonatomic , copy , readonly) UIImage *(^image)();

@end
