//
//  NSUserDefaults+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 18/11/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "NSUserDefaults+CCExtension.h"

@implementation NSUserDefaults (CCExtension)

BOOL CC_USER_DEFAULLTS(void (^bDef)(NSUserDefaults *sender)) {
    NSUserDefaults *def = NSUserDefaults.standardUserDefaults;
    if (bDef) bDef(def);
    return def.synchronize;
}

void CC_RESET_USER_DEFAULLTS(void) {
    [NSUserDefaults resetStandardUserDefaults];
}

@end
