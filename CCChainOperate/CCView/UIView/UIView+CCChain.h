//
//  UIView+CCChain.h
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 02/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

struct CCPoint {
    CGFloat x , y;
};
typedef struct CCPoint CCPoint;
CCPoint CCPointMake(CGFloat x , CGFloat y);
CCPoint CCMakePointFrom(CGPoint point);
CGPoint CGMakePointFrom(CCPoint point);

struct CCSize {
    CGFloat width , height;
};
typedef struct CCSize CCSize;
CCSize CCSizeMake(CGFloat width , CGFloat height);
CCSize CCMakeSizeFrom(CGSize size);
CGSize CGMakeSizeFrom(CCSize size);

struct CCRect {
    CCPoint origin;
    CCSize size;
};
typedef struct CCRect CCRect;
CCRect CCRectMake(CGFloat x , CGFloat y , CGFloat width , CGFloat height);
CCRect CCMakeRectFrom(CGRect rect);
CGRect CGMakeRectFrom(CCRect rect);

static inline CGRect CGRectFull();

typedef struct CCEdgeInsets {
    CGFloat top, left, bottom, right;
} CCEdgeInsets;
typedef struct CCEdgeInsets CCEdgeInsets;
CCEdgeInsets CCEdgeInsetsMake(CGFloat top , CGFloat left , CGFloat bottom , CGFloat right);
CCEdgeInsets CCMakeEdgeInsetsFrom(UIEdgeInsets insets);
UIEdgeInsets UIMakeEdgeInsetsFrom(CCEdgeInsets insets);

/// scaled width
CGFloat CCScaleW(CGFloat w);
CGFloat CCScaleH(CGFloat h);

/// length scale
CGFloat CCWScale(CGFloat w);
CGFloat CCHScale(CGFloat h);

@interface UIView (CCChain)

@property (nonatomic , class , copy , readonly) UIView *(^common)(CCRect frame);

/// set width && height for calculating , default : 750 , 1334
@property (nonatomic , class , copy , readonly) void(^scaleSet)(CGFloat w , CGFloat h);
@property (nonatomic , class , assign , readonly) CGFloat sWidth;
@property (nonatomic , class , assign , readonly) CGFloat sHeight;

@property (nonatomic , assign) CGSize size;
@property (nonatomic , assign) CGPoint origin;

@property (nonatomic , assign) CCSize sizeC;
@property (nonatomic , assign) CCPoint originC;

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

/// an easy way to margin
@property (nonatomic , copy , readonly) UIView *(^sizeS)(CGSize size);
@property (nonatomic , copy , readonly) UIView *(^originS)(CGPoint origin);

@property (nonatomic , copy , readonly) UIView *(^widthS)(CGFloat width);
@property (nonatomic , copy , readonly) UIView *(^heightS)(CGFloat height);

@property (nonatomic , copy , readonly) UIView *(^xS)(CGFloat x);
@property (nonatomic , copy , readonly) UIView *(^yS)(CGFloat y);

@property (nonatomic , copy , readonly) UIView *(^centerXs)(CGFloat centerX);
@property (nonatomic , copy , readonly) UIView *(^centerYs)(CGFloat centerY);

@property (nonatomic , copy , readonly) UIView *(^topS)(CGFloat top);
@property (nonatomic , copy , readonly) UIView *(^leftS)(CGFloat left);
@property (nonatomic , copy , readonly) UIView *(^bottomS)(CGFloat bottom);
@property (nonatomic , copy , readonly) UIView *(^rightS)(CGFloat right);

/// for xibs
@property (nonatomic , class , copy , readonly) UIView *(^fromXib)();
@property (nonatomic , class , copy , readonly) UIView *(^fromXibC)(Class c);
@property (nonatomic , class , copy , readonly) UIView *(^fromXibB)(NSBundle *bundle);

/// add && remove (return itself)
@property (nonatomic , copy , readonly) UIView *(^addSub)(UIView *view);
@property (nonatomic , copy , readonly) void (^removeFrom)(void(^t)(UIView *viewSuper));
@property (nonatomic , copy , readonly) UIView *(^bringToFront)(UIView *view);
@property (nonatomic , copy , readonly) UIView *(^sendToBack)(UIView *view);

/// color && cornerRadius
@property (nonatomic , copy , readonly) UIView *(^color)(UIColor *color);
@property (nonatomic , copy , readonly) UIView *(^radius)(CGFloat radius , BOOL masks);
@property (nonatomic , copy , readonly) UIView *(^edgeRound)(UIRectCorner rc , CGFloat radius);

/// for gesture actions
@property (nonatomic , copy , readonly) UIView *(^gesture)(UIGestureRecognizer *gr);
@property (nonatomic , copy , readonly) UIView *(^tap)(void(^t)(UIView *v , UITapGestureRecognizer *gr));
@property (nonatomic , copy , readonly) UIView *(^tapC)(NSInteger iCount , void(^t)(UIView *v , UITapGestureRecognizer *gr));
@property (nonatomic , copy , readonly) UIView *(^press)(void(^t)(UIView *v , UILongPressGestureRecognizer *gr));
@property (nonatomic , copy , readonly) UIView *(^pressC)(CGFloat fSeconds , void(^t)(UIView *v , UILongPressGestureRecognizer *gr));

@end

#pragma mark - -----
#import "MBProgressHUD+CCChain.h"

@interface UIView (CCChain_Hud)

@property (nonatomic , copy , readonly) MBProgressHUD *(^hud)();
@property (nonatomic , class , copy , readonly) MBProgressHUD *(^hudC)(UIView *view);

@end
