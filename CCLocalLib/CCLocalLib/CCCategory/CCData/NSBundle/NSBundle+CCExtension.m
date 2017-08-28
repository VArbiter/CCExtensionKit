//
//  NSBundle+CCExtension.m
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 28/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "NSBundle+CCExtension.h"

@implementation NSBundle (CCExtension)

+ (instancetype) ccBundleFor : (Class) clazz {
    if (clazz) {
        return [NSBundle bundleForClass:clazz];
    }
    return [NSBundle mainBundle];
}

@end
