//
//  CCMediator+CCBridgeAPI.h
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 15/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "CCMediator.h"

#if __has_include(<MGJRouter/MGJRouter.h>)

#import "CCBridgeWrapper.h"

@interface CCMediator (CCBridgeAPI)

+ (void) ccFallBack : (void (^)(void)) fallBack ;
+ (void) ccRegist : (NSString *) sURL
           action : (void(^)(NSDictionary *)) action ;
+ (void) ccCall : (NSString *) sURL
       fallBack : (void(^)(void)) fallback ;
+ (void) ccCall : (NSString *) sURL
       userInfo : (id) userInfo
       fallBack : (void(^)(void)) fallback ;
+ (void) ccObject : (NSString *) sURL
            value : (id(^)(id value)) value ;
+ (id) ccGet : (NSString *) sURL
    fallBack : (void(^)(void)) fallback ;
+ (id) ccGet : (NSString *) sURL
    userInfo : (id) userInfo
    fallBack : (void(^)(void)) fallback ;

@end

#endif
