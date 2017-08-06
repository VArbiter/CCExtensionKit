//
//  MBProgressHUD+CCChain.h
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 02/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

typedef NS_ENUM(NSInteger , CCHudChainType) {
    CCHudChainTypeNone = 0 ,
    CCHudChainTypeLight ,
    CCHudChainTypeDark ,
    CCHudChainTypeDarkDeep
};

@interface MBProgressHUD (CCChain)

/// init ,  default showing after chain complete , no need to deploy showing action "show()".
@property (nonatomic , class , copy , readonly) MBProgressHUD *(^initC)();
@property (nonatomic , class , copy , readonly) MBProgressHUD *(^initS)(UIView *v);

/// generate a hud with its bounds . default with application window .
/// also , you have to add it after generate compete , and deploy showing action "show()" .
@property (nonatomic , class , copy , readonly) MBProgressHUD *(^generate)();
@property (nonatomic , class , copy , readonly) MBProgressHUD *(^generateS)(UIView *v);

/// for userInteraction
@property (nonatomic , copy , readonly) MBProgressHUD *(^enable)() ;
@property (nonatomic , copy , readonly) MBProgressHUD *(^disableT)() ;

@property (nonatomic , class , copy , readonly) BOOL (^hasHud)();
@property (nonatomic , class , copy , readonly) BOOL (^hasHudS)(UIView *view);

/// for showing action , last step
@property (nonatomic , copy , readonly) MBProgressHUD *(^show)(); // if needed , default showing after chain complete
@property (nonatomic , copy , readonly) MBProgressHUD *(^hide)(); // default 2 seconds .
@property (nonatomic , copy , readonly) MBProgressHUD *(^hideS)(NSTimeInterval interval);

/// messages && indicator
@property (nonatomic , copy , readonly) MBProgressHUD *(^indicatorD)();
@property (nonatomic , copy , readonly) MBProgressHUD *(^simple)(); // default
@property (nonatomic , copy , readonly) MBProgressHUD *(^title)(NSString *sTitle);
@property (nonatomic , copy , readonly) MBProgressHUD *(^message)(NSString *sMessage);
@property (nonatomic , copy , readonly) MBProgressHUD *(^type)(CCHudChainType type);
@property (nonatomic , copy , readonly) MBProgressHUD *(^delay)(CGFloat delay);
@property (nonatomic , copy , readonly) MBProgressHUD *(^complete)(void(^)());

@end
