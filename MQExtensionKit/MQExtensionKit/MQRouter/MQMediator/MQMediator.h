//
//  MQMediator.h
//  MQExtensionKit
//
//  Created by Elwinfrederick on 14/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString * MQMediatorOperateKey NS_EXTENSIBLE_STRING_ENUM;

@interface MQMediator : NSObject

- (instancetype) init NS_UNAVAILABLE;

+ (id) mq_perform : (NSString *) s_target
           action : (NSString *) s_action
     return_value : (BOOL) is_need
            value : (id (^)(void)) value ;

@end
