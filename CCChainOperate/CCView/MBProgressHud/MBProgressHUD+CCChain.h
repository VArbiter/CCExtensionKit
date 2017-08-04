//
//  MBProgressHUD+CCChain.h
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 02/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

typedef NS_ENUM(NSInteger , CCHudTypeC) {
    CCHudTypeCNone = 0 ,
    CCHudTypeCLight ,
    CCHudTypeCDark ,
    CCHudTypeCDarkDeep
};

@interface MBProgressHUD (CCChain)

/// for userInteraction
@property (nonatomic , copy , readonly) MBProgressHUD *(^enable)() ;
@property (nonatomic , copy , readonly) MBProgressHUD *(^disable)() ;

@property (nonatomic , class , copy , readonly) BOOL (^hasHud)();
@property (nonatomic , class , copy , readonly) BOOL (^hasHudS)(UIView *view);

/// for showing action , first step
@property (nonatomic , class , copy , readonly) MBProgressHUD *(^show)();
@property (nonatomic , class , copy , readonly) MBProgressHUD *(^showS)(UIView *view);
@property (nonatomic , copy , readonly) MBProgressHUD *(^hide)(); // default 2 seconds .
@property (nonatomic , copy , readonly) MBProgressHUD *(^hideS)(NSTimeInterval interval);

/// messages && indicator
@property (nonatomic , copy , readonly) MBProgressHUD *(^indicator)();
@property (nonatomic , copy , readonly) MBProgressHUD *(^simple)(); // default
@property (nonatomic , copy , readonly) MBProgressHUD *(^title)(NSString *sTitle);
@property (nonatomic , copy , readonly) MBProgressHUD *(^message)(NSString *sMessage);
@property (nonatomic , copy , readonly) MBProgressHUD *(^type)(CCHudTypeC type);
@property (nonatomic , copy , readonly) MBProgressHUD *(^delay)(CGFloat delay);
@property (nonatomic , copy , readonly) MBProgressHUD *(^complete)(void(^)());

@end
