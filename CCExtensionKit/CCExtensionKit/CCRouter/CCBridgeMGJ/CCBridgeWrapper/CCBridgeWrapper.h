//
//  CCBridgeWrapper.h
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 14/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include(<MGJRouter/MGJRouter.h>)

@import MGJRouter;

@interface CCBridgeWrapper : NSObject

+ (instancetype) shared ;

- (instancetype) ccFallBack : (void (^)()) fallBack ;
- (instancetype) ccRegist : (NSString *) sURL
                   action : (void(^)(NSDictionary *)) action ;
- (instancetype) ccCall : (NSString *) sURL
               fallBack : (void(^)()) fallback ;
- (instancetype) ccCall : (NSString *) sURL
               userInfo : (id) userInfo
               fallBack : (void(^)()) fallback ;
- (instancetype) ccObject : (NSString *) sURL
                    value : (id(^)()) value ;
- (id) ccGet : (NSString *) sURL
    fallBack : (void(^)()) fallback ;
- (id) ccGet : (NSString *) sURL
    userInfo : (id) userInfo
    fallBack : (void(^)()) fallback ;

FOUNDATION_EXPORT NSString * const _CC_ROUTER_PARAMS_URL_;
FOUNDATION_EXPORT NSString * const _CC_ROUTER_PARAMS_COMPLETION_;
FOUNDATION_EXPORT NSString * const _CC_ROUTER_PARAMS_USER_INFO_;
FOUNDATION_EXPORT NSString * const _CC_ROUTER_FALL_BACK_URL_ ;

@end

#endif
