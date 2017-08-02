//
//  UIView+CCChain.h
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 02/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CCChain)

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

/// for gesture actions
@property (nonatomic , copy , readonly) UIView *(^tap)(void(^t)(UIView *v , UITapGestureRecognizer *gr));
@property (nonatomic , copy , readonly) UIView *(^tapC)(NSInteger iCount , void(^t)(UIView *v , UITapGestureRecognizer *gr));
@property (nonatomic , copy , readonly) UIView *(^press)(void(^t)(UIView *v , UILongPressGestureRecognizer *gr));
@property (nonatomic , copy , readonly) UIView *(^pressC)(CGFloat fSeconds , void(^t)(UIView *v , UILongPressGestureRecognizer *gr));

@end
