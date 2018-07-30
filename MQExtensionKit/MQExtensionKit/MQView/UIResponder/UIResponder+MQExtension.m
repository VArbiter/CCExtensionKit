//
//  UIResponder+MQExtension.m
//  MQExtensionKit
//
//  Created by ElwinFrederick on 07/05/2018.
//  Copyright © 2018 冯明庆. All rights reserved.
//

#import "UIResponder+MQExtension.h"

@implementation UIResponder (MQExtension)

- (void) mq_deliver_message_with_sel : (SEL) selector
                               using : (void (^)(__kindof UIResponder *responder)) message_block {
    if (!selector || !message_block) return ;
    
    UIResponder *next_responder = [self nextResponder];
    do {
        if ([next_responder respondsToSelector:selector]) {
            if (message_block) message_block(next_responder);
        }
        next_responder = [next_responder nextResponder];
    } while (next_responder != nil);
}

@end
