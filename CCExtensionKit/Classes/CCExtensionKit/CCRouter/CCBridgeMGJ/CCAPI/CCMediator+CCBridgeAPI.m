//
//  CCMediator+CCBridgeAPI.m
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 15/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "CCMediator+CCBridgeAPI.h"

#if __has_include(<MGJRouter/MGJRouter.h>)

@implementation CCMediator (CCBridgeAPI)

+ (void) ccFallBack : (void (^)()) fallBack {
    [CCBridgeWrapper.shared ccFallBack:fallBack];
}
+ (void) ccRegist : (NSString *) sURL
           action : (void(^)(NSDictionary *)) action {
    [CCBridgeWrapper.shared ccRegist:sURL
                              action:action];
}
+ (void) ccCall : (NSString *) sURL
       fallBack : (void(^)()) fallback {
    [CCBridgeWrapper.shared ccCall:sURL
                          fallBack:fallback];
}
+ (void) ccCall : (NSString *) sURL
       userInfo : (id) userInfo
       fallBack : (void(^)()) fallback {
    [CCBridgeWrapper.shared ccCall:sURL
                          userInfo:userInfo
                          fallBack:fallback];
}
+ (void) ccObject : (NSString *) sURL
            value : (id(^)()) value {
    [CCBridgeWrapper.shared ccObject:sURL
                               value:value];
}
+ (id) ccGet : (NSString *) sURL
    fallBack : (void(^)()) fallback {
    return [CCBridgeWrapper.shared ccGet:sURL
                                fallBack:fallback];
}
+ (id) ccGet : (NSString *) sURL
    userInfo : (id) userInfo
    fallBack : (void(^)()) fallback {
    return [CCBridgeWrapper.shared ccGet:sURL
                                userInfo:userInfo
                                fallBack:fallback];
}

@end

#endif
