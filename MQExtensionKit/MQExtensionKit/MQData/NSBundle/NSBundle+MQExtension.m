//
//  NSBundle+MQExtension.m
//  MQExtensionKit
//
//  Created by Elwinfrederick on 28/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "NSBundle+MQExtension.h"

@implementation NSBundle (CCExtension)

+ (instancetype) mq_bundle_for : (Class) clazz {
    if (clazz) {
        return [NSBundle bundleForClass:clazz];
    }
    return [NSBundle mainBundle];
}

- (instancetype) mq_resource : (NSString *) sName
                   extension : (NSString *) sExtension
                      action : (void(^)(NSString *sPath)) action {
    return [self mq_resource:sName
                   extension:sExtension
                    sub_path:nil
                      action:action];
}

- (instancetype) mq_resource : (NSString *) sName
                   extension : (NSString *) sExtension
                    sub_path : (NSString *) sSubPath
                      action : (void(^)(NSString *sPath)) action {
    if (action) action([self pathForResource:sName
                                      ofType:sExtension
                                 inDirectory:sSubPath]);
    return self;
}

- (instancetype) mq_resource : (NSString *) sExtension
                    sub_path : (NSString *) sSubPath
                      action : (void(^)(NSArray <NSString *> *sPath)) action {
    if (action) action([self pathsForResourcesOfType:sExtension
                                         inDirectory:sSubPath]);
    return self;
}

+ (NSString *) mq_bundle_name {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
}
+ (NSString *) mq_bundle_identifier {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}
+ (NSString *) mq_app_build_version {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}
+ (NSString *) mq_app_version {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

@end
