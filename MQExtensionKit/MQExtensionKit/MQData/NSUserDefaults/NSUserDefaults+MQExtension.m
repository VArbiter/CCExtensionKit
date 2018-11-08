//
//  NSUserDefaults+MQExtension.m
//  MQExtensionKit
//
//  Created by 冯明庆 on 18/11/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "NSUserDefaults+MQExtension.h"

@implementation NSUserDefaults (MQExtension)

NSUserDefaults *mq_user_defaults(void) {
    return [NSUserDefaults standardUserDefaults];
}

BOOL mq_standard_user_defaults(void (^bDef)(NSUserDefaults *sender)) {
    NSUserDefaults *def = NSUserDefaults.standardUserDefaults;
    if (bDef) bDef(def);
    return def.synchronize;
}

void mq_standard_user_defaults_reset(void) {
    [NSUserDefaults resetStandardUserDefaults];
}

BOOL mq_user_defaults_s(NSString *s_suite_id , void (^block_def)(NSUserDefaults *sender)) {
    NSUserDefaults *def = [[NSUserDefaults alloc] initWithSuiteName:s_suite_id];
    if (block_def) block_def(def);
    return def.synchronize;
}

@end
