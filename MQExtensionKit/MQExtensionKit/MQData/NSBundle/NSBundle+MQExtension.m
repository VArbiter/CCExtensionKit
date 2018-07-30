//
//  NSBundle+MQExtension.m
//  MQExtensionKit
//
//  Created by Elwinfrederick on 28/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "NSBundle+MQExtension.h"

@implementation NSBundle (MQExtension)

+ (instancetype) mq_bundle_for : (Class) clazz {
    if (clazz) {
        return [NSBundle bundleForClass:clazz];
    }
    return [NSBundle mainBundle];
}

- (instancetype) mq_resource : (NSString *) s_name
                   extension : (NSString *) s_extension
                      action : (void(^)(NSString *s_path)) action {
    return [self mq_resource:s_name
                   extension:s_extension
                    sub_path:nil
                      action:action];
}

- (instancetype) mq_resource : (NSString *) s_name
                   extension : (NSString *) s_extension
                    sub_path : (NSString *) s_sub_path
                      action : (void(^)(NSString *s_path)) action {
    if (action) action([self pathForResource:s_name
                                      ofType:s_extension
                                 inDirectory:s_sub_path]);
    return self;
}

- (instancetype) mq_resource : (NSString *) s_extension
                    sub_path : (NSString *) s_sub_path
                      action : (void(^)(NSArray <NSString *> *s_path)) action {
    if (action) action([self pathsForResourcesOfType:s_extension
                                         inDirectory:s_sub_path]);
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
