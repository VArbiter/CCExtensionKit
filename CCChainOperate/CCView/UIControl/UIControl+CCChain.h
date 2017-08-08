//
//  UIControl+CCChain.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 08/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+CCChain.h"

@interface UIControl (CCChain)

@property (nonatomic , class , copy , readonly) UIControl *(^commonS)(CCRect frame);
@property (nonatomic , class , copy , readonly) UIControl *(^commonC)(CGRect frame);

/// actions , default is touchUpInside
@property (nonatomic , copy , readonly) UIControl *(^actionS)(void (^)(UIControl *sender));
@property (nonatomic , copy , readonly) UIControl *(^targetS)(id target , void (^)(UIControl *sender));

/// custom actions .
@property (nonatomic , copy , readonly) UIControl *(^custom)(id target , SEL selector , UIControlEvents events);

@end
