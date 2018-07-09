//
//  NSBundle+CCExtension.m
//  CCExtensionKit
//
//  Created by Elwinfrederick on 28/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "NSBundle+CCExtension.h"

@implementation NSBundle (CCExtension)

+ (instancetype) cc_bundle_for : (Class) clazz {
    if (clazz) {
        return [NSBundle bundleForClass:clazz];
    }
    return [NSBundle mainBundle];
}

- (instancetype) cc_resource : (NSString *) sName
                   extension : (NSString *) sExtension
                      action : (void(^)(NSString *sPath)) action {
    return [self cc_resource:sName
                   extension:sExtension
                    sub_path:nil
                      action:action];
}

- (instancetype) cc_resource : (NSString *) sName
                   extension : (NSString *) sExtension
                    sub_path : (NSString *) sSubPath
                      action : (void(^)(NSString *sPath)) action {
    if (action) action([self pathForResource:sName
                                      ofType:sExtension
                                 inDirectory:sSubPath]);
    return self;
}

- (instancetype) cc_resource : (NSString *) sExtension
                    sub_path : (NSString *) sSubPath
                      action : (void(^)(NSArray <NSString *> *sPath)) action {
    if (action) action([self pathsForResourcesOfType:sExtension
                                         inDirectory:sSubPath]);
    return self;
}

+ (NSString *) cc_bundle_name {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
}
+ (NSString *) cc_bundle_identifier {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}
+ (NSString *) cc_app_build_version {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}
+ (NSString *) cc_app_version {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

@end
