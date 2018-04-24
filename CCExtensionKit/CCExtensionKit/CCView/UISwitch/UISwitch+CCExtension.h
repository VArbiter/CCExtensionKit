//
//  UISwitch+CCExtension.h
//  CCLocalLibrary
//
//  Created by ElwinFrederick on 24/04/2018.
//  Copyright © 2018 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISwitch (CCExtension)

+ (instancetype) cc_common : (CGRect) frame ;

- (instancetype) cc_defaut_on ;
- (instancetype) cc_defaut_off ;

@property (nonatomic) UIColor *on_color ;
@property (nonatomic) UIColor *off_color ;
@property (nonatomic) UIColor *thumb_color ;

- (void) cc_switch_action : (void (^)(__kindof UISwitch * sender)) block_swicth;

@end
