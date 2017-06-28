//
//  UIView+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/3/28.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CCExtension)

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

+ (instancetype) ccViewFromXib ;
+ (instancetype) ccViewFromXib : (NSBundle *) bundle ;

- (void) ccAddTap : (dispatch_block_t) block ;
- (void) ccAddTap : (NSInteger) iTaps
           action : (dispatch_block_t) block ;

@end
#pragma mark - CCHudAlert ------------------------------------------------------

#import "MBProgressHUD+CCExtension.h"

@interface UIView (CCHudAlert)

@property (nonatomic , assign , readonly) BOOL isHasHud ;

/// 菊花转 , 不会自动消失 .
- (MBProgressHUD *) ccShowIndicator ;
- (MBProgressHUD *) ccShowIndicator : (CCHudType) type ;
- (MBProgressHUD *) ccShowIndicator : (CCHudType) type
                            message : (NSString *) stringMessage ;

/// 会自动消失
- (MBProgressHUD *) ccShow : (NSString *) stringMessage ;
- (MBProgressHUD *) ccShow : (NSString *) stringMessage
                      type : (CCHudType) type ;

- (void) ccHide ;

@end
