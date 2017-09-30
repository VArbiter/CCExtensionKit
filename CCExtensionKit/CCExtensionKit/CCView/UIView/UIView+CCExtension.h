//
//  UIView+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/3/28.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT CGFloat const _CC_DEFAULT_ANIMATION_COMMON_DURATION_;

typedef CGPoint CCPoint;
CCPoint CCPointMake(CGFloat x , CGFloat y);
CCPoint CCMakePointFrom(CGPoint point);
CGPoint CGMakePointFrom(CCPoint point);

typedef CGSize CCSize;
CCSize CCSizeMake(CGFloat width , CGFloat height);
CCSize CCMakeSizeFrom(CGSize size);
CGSize CGMakeSizeFrom(CCSize size);

typedef CGRect CCRect;
CCRect CCRectMake(CGFloat x , CGFloat y , CGFloat width , CGFloat height);
CCRect CCMakeRectFrom(CGRect rect);
CGRect CGMakeRectFrom(CCRect rect);

CGRect CGRectFull(); // main screen bounds .

typedef UIEdgeInsets CCEdgeInsets;
CCEdgeInsets CCEdgeInsetsMake(CGFloat top , CGFloat left , CGFloat bottom , CGFloat right);
CCEdgeInsets CCMakeEdgeInsetsFrom(UIEdgeInsets insets);
UIEdgeInsets UIMakeEdgeInsetsFrom(CCEdgeInsets insets);

/// scaled width && height
CGFloat CCScaleW(CGFloat w);
CGFloat CCScaleH(CGFloat h);

/// length scale
CGFloat CCWScale(CGFloat w);
CGFloat CCHScale(CGFloat h);
CGPoint CCScaleOrigin(CGPoint origin);
CGSize CCScaleSize(CGSize size);

@interface UIView (CCExtension)

+ (instancetype) common : (CGRect) frame ;

/// for some designer use basic UI that is not for iPhone 6/6s/7/8
/// set H && W only once in somewhere for "+ (void) load"
+ (void) ccSetScale : (CGFloat) fWidth
             height : (CGFloat) fHeight ;

+ (void) ccDisableAnimation : (void (^)()) action ;

@property (nonatomic , class , assign , readonly) CGFloat sWidth;
@property (nonatomic , class , assign , readonly) CGFloat sHeight;

@property (nonatomic , assign) CGSize size;
@property (nonatomic , assign) CGPoint origin;

@property (nonatomic , assign) CGFloat width;
@property (nonatomic , assign) CGFloat height;

@property (nonatomic , assign) CGFloat x;
@property (nonatomic , assign) CGFloat y;

@property (nonatomic , assign) CGFloat centerX;
@property (nonatomic , assign) CGFloat centerY;

@property (nonatomic , assign , readonly) CGFloat inCenterX ;
@property (nonatomic , assign , readonly) CGFloat inCenterY ;
@property (nonatomic , assign , readonly) CGPoint inCenter ;

@property (nonatomic , assign) CGFloat top;
@property (nonatomic , assign) CGFloat left;
@property (nonatomic , assign) CGFloat bottom;
@property (nonatomic , assign) CGFloat right;

@property (nonatomic , assign , readonly) CGFloat inTop;
@property (nonatomic , assign , readonly) CGFloat inLeft;
@property (nonatomic , assign , readonly) CGFloat inBottom;
@property (nonatomic , assign , readonly) CGFloat inRight;

/// an easy way to margin
- (instancetype) ccSize : (CGSize) size ;
- (instancetype) ccOrigin : (CGPoint) point ;

- (instancetype) ccWidth : (CGFloat) fWidth ;
- (instancetype) ccHeight : (CGFloat) fHeight ;

- (instancetype) ccX : (CGFloat) fX ;
- (instancetype) ccY : (CGFloat) fY ;

- (instancetype) ccCenterX : (CGFloat) fCenterX ;
- (instancetype) ccCenterY : (CGFloat) fCenterY ;

- (instancetype) ccTop : (CGFloat) fTop ;
- (instancetype) ccLeft : (CGFloat) fLeft ;
- (instancetype) ccBottom : (CGFloat) fBottom ;
- (instancetype) ccRight : (CGFloat) fRight ;

/// for xibs
+ (instancetype) ccFromXib ;
+ (instancetype) ccFromXib : (Class) cls ;
+ (instancetype) ccFromXibB : (NSBundle *) bundle;

/// add && remove (return itself)
- (instancetype) ccAdd : (__kindof UIView *) view ;
- (void) ccRemoveFrom : (void (^)(__kindof UIView *viewSuper)) action ;
- (instancetype) ccBringToFront : (__kindof UIView *) view ;
- (instancetype) ccSendToBack : (__kindof UIView *) view ;
- (instancetype) ccMakeToFront ;
- (instancetype) ccMakeToBack ;

/// enable / disable userinteraction
- (instancetype) ccEnable ;
- (instancetype) ccDisable ;

/// color && cornerRadius && contentMode
- (instancetype) ccColor : (UIColor *) color ;
- (instancetype) ccRadius : (CGFloat) fRadius
                    masks : (BOOL) isMask ;
- (instancetype) ccEdgeRound : (UIRectCorner) corner
                      radius : (CGFloat) fRadius ;
- (instancetype) ccContentMode : (UIViewContentMode) mode ;

@end

#pragma mark - -----

@interface UIView (CCExtension_FitHeight)

/// note: all the fit recalls ignores the text-indent .

/// system font size , default line break mode , system font size
CGFloat CC_TEXT_HEIGHT_S(CGFloat fWidth ,
                         CGFloat fEstimateHeight , // height that defualt to , if less than , return's it. (same below)
                         NSString *string);
CGFloat CC_TEXT_HEIGHT_C(CGFloat fWidth ,
                         CGFloat fEstimateHeight ,
                         NSString *string ,
                         UIFont *font ,
                         NSLineBreakMode mode);

/// for attributed string , Using system attributed auto fit
CGFloat CC_TEXT_HEIGHT_A(CGFloat fWidth ,
                         CGFloat fEstimateHeight ,
                         NSAttributedString *aString);

/// using default for NSString
CGFloat CC_TEXT_HEIGHT_AS(CGFloat fWidth ,
                          CGFloat fEstimateHeight ,
                          NSString *aString ,
                          UIFont *font ,
                          NSLineBreakMode mode ,
                          CGFloat fLineSpacing ,
                          CGFloat fCharacterSpacing);

@end
