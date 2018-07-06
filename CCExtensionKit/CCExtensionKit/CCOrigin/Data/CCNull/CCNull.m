//
//  CCNull.m
//  CCLocalLibrary
//
//  Created by ElwinFrederick on 2018/7/5.
//  Copyright © 2018 冯明庆. All rights reserved.
//

#import "CCNull.h"

static NSMutableArray * __unknow_message_post_as_objects = nil;

@interface CCForwardingUnknowMessage : NSObject

+ (void) cc_regist_class : (Class) clz ;

+ (NSArray *) cc_class_objects ;

@end

@implementation CCForwardingUnknowMessage

+ (void)initialize {
    if (self == [CCForwardingUnknowMessage class]) {
        NSMutableArray *t = [NSMutableArray array];
        [t addObject:NSString.class];
        [t addObject:NSNumber.class];
        [t addObject:NSArray.class];
        [t addObject:NSDictionary.class];
        [t addObject:NSSet.class];
        
        __unknow_message_post_as_objects = t;
    }
}

+ (void) cc_regist_class : (Class) clz {
    if (clz) {
        if (![__unknow_message_post_as_objects containsObject:clz]) {
            [__unknow_message_post_as_objects addObject:clz];
        }
    }
    else {
        [NSException raise:@"CCExtensionKit.CCForwardingUnknowMessage : InvalidArgumentException"
                    format:@"class can't be nil"];
    }
}

+ (NSArray *) cc_class_objects {
    return __unknow_message_post_as_objects;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    [anInvocation invokeWithTarget:nil];
}

+ (id)objectRespondToSelector:(SEL)aSelector {
    NSArray *cc_default_classes = [self cc_class_objects];
    for (Class t_default_class in cc_default_classes) {
        if ([t_default_class instancesRespondToSelector:aSelector]) {
            return t_default_class;
        }
    }
    
    return nil;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [[self class] instanceMethodSignatureForSelector:aSelector];
}

+ (NSMethodSignature *)instanceMethodSignatureForSelector:(SEL)aSelector {
    return [[self objectRespondToSelector:aSelector] instanceMethodSignatureForSelector:aSelector];
}

@end

#pragma mark - -----

@interface CCNull ()

@end

@implementation CCNull

@end
