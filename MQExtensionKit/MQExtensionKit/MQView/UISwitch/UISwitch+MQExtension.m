//
//  UISwitch+MQExtension.m
//  MQExtensionKit
//
//  Created by ElwinFrederick on 24/04/2018.
//  Copyright © 2018 冯明庆. All rights reserved.
//

#import "UISwitch+MQExtension.h"

#import <objc/runtime.h>

@interface UISwitch (CCExtension_Assist)

- (void) mq_switch_holder_action : (UISwitch *) sender ;

@end

@implementation UISwitch (CCExtension_Assist)

- (void) mq_switch_holder_action : (UISwitch *) sender {
    void (^mq_switch_block)(UISwitch *) = objc_getAssociatedObject(self, "CC_UISWITCH_ACTION_ASSOCIATE_KEY");
    if (mq_switch_block) mq_switch_block(self);
}

@end

@implementation UISwitch (CCExtension)

+ (instancetype) mq_common : (CGRect) frame {
    return [[self alloc] initWithFrame:frame];
}

- (instancetype) mq_defaut_on {
    self.on = YES;
    return self;
}
- (instancetype) mq_defaut_off {
    self.on = false;
    return self;
}

- (void)setOn_color:(UIColor *)on_color {
    self.onTintColor = on_color;
}
- (UIColor *)on_color {
    return self.onTintColor;
}

- (void)setOff_color:(UIColor *)off_color {
    self.tintColor = off_color;
}
- (UIColor *)off_color {
    return self.tintColor;
}

- (void)setThumb_color:(UIColor *)thumb_color {
    self.thumbTintColor = thumb_color;
}
- (UIColor *)thumb_color {
    return self.thumbTintColor;
}

- (void) mq_switch_action : (void (^)(__kindof UISwitch * sender)) block_swicth {
    [self addTarget:self
             action:@selector(mq_switch_holder_action:)
   forControlEvents:UIControlEventValueChanged];
    
    if (block_swicth)
        objc_setAssociatedObject(self,
                                 "CC_UISWITCH_ACTION_ASSOCIATE_KEY",
                                 block_swicth,
                                 OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
