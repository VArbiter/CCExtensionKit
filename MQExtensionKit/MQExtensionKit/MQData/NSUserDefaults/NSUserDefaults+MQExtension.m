//
//  NSUserDefaults+MQExtension.m
//  MQExtensionKit
//
//  Created by 冯明庆 on 18/11/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "NSUserDefaults+MQExtension.h"

@implementation NSUserDefaults (MQExtension)

BOOL MQ_USER_DEFAULLTS(void (^bDef)(NSUserDefaults *sender)) {
    NSUserDefaults *def = NSUserDefaults.standardUserDefaults;
    if (bDef) bDef(def);
    return def.synchronize;
}

void MQ_RESET_USER_DEFAULLTS(void) {
    [NSUserDefaults resetStandardUserDefaults];
}

BOOL MQ_USER_DEFAULTS_S(NSString *s_suite_id , void (^block_def)(NSUserDefaults *sender)) {
    NSUserDefaults *def = [[NSUserDefaults alloc] initWithSuiteName:s_suite_id];
    if (block_def) block_def(def);
    return def.synchronize;
}

@end
