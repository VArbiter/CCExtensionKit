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

- (instancetype) ccResource : (NSString *) sName
                  extension : (NSString *) sExtension
                     action : (void(^)(NSString *sPath)) action {
    return [self ccResource:sName
                  extension:sExtension
                    subPath:nil
                     action:action];
}

- (instancetype) ccResource : (NSString *) sName
                  extension : (NSString *) sExtension
                    subPath : (NSString *) sSubPath
                     action : (void(^)(NSString *sPath)) action {
    if (action) action([self pathForResource:sName
                                      ofType:sExtension
                                 inDirectory:sSubPath]);
    return self;
}

- (instancetype) ccResource : (NSString *) sExtension
                    subPath : (NSString *) sSubPath
                     action : (void(^)(NSArray <NSString *> *sPath)) action {
    if (action) action([self pathsForResourcesOfType:sExtension
                                         inDirectory:sSubPath]);
    return self;
}

@end
