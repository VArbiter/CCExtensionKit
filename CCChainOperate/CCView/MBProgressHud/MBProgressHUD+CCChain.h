//
//  MBProgressHUD+CCChain.h
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 02/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

typedef NS_ENUM(NSInteger , CCHudType) {
    CCHudTypeNone = 0 ,
    CCHudTypeLight ,
    CCHudTypeDark ,
    CCHudTypeDarkDeep
};

@interface MBProgressHUD (CCChain)

/// for userInteraction
@property (nonatomic , copy , readonly) MBProgressHUD *(^enable)() ;
@property (nonatomic , copy , readonly) MBProgressHUD *(^disable)() ;

@property (nonatomic , class , copy , readonly) BOOL (^hasHud)();
@property (nonatomic , class , copy , readonly) BOOL (^hasHudS)(UIView *view);

/// for showing action
@property (nonatomic , copy , readonly) MBProgressHUD *(^show)();
@property (nonatomic , copy , readonly) MBProgressHUD *(^showS)(UIView *view);

/// messages && indicator
@property (nonatomic , copy , readonly) MBProgressHUD *(^indicator)();
@property (nonatomic , copy , readonly) MBProgressHUD *(^title)(NSString *sTitle);
@property (nonatomic , copy , readonly) MBProgressHUD *(^message)(NSString *sMessage);
@property (nonatomic , copy , readonly) MBProgressHUD *(^type)(CCHudType type);
@property (nonatomic , copy , readonly) MBProgressHUD *(^delay)(CGFloat delay);
@property (nonatomic , copy , readonly) MBProgressHUD *(^complete)(void(^)());

@end
