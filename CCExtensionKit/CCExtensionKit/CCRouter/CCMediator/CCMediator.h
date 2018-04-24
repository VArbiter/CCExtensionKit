//
//  CCMediator.h
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 14/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString * CCMediatorOperateKey NS_EXTENSIBLE_STRING_ENUM;

@interface CCMediator : NSObject

- (instancetype) init NS_UNAVAILABLE;

+ (id) cc_perform : (NSString *) sTarget
           action : (NSString *) sAction
     return_value : (BOOL) isNeed
            value : (id (^)(void)) value ;

@end
