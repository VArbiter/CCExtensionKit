//
//  UIButton+CCChain.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 06/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+CCChain.h"

@interface UIButton (CCChain)

@property (nonatomic , class , copy , readonly) UIButton *(^common)();
@property (nonatomic , class , copy , readonly) UIButton *(^commonS)(UIButtonType type);
@property (nonatomic , copy , readonly) UIButton *(^frameS)(CCRect frame);
@property (nonatomic , copy , readonly) UIButton *(^frameC)(CGRect frame);

/// titles && images
@property (nonatomic , copy , readonly) UIButton *(^titleS)(NSString * sTitle , UIControlState state);
@property (nonatomic , copy , readonly) UIButton *(^imageS)(UIImage * image , UIControlState state);

/// actions , default is touchUpInside
@property (nonatomic , copy , readonly) UIButton *(^actionS)(void (^)(UIButton *sender));
@property (nonatomic , copy , readonly) UIButton *(^targetS)(id target , void (^)(UIButton *sender));

/// custom actions .
@property (nonatomic , copy , readonly) UIButton *(^custom)(id target , SEL selector , UIControlEvents events);

@end
