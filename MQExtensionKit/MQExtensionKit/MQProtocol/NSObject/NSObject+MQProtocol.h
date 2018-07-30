//
//  NSObject+MQProtocol.h
//  RisSubModule
//
//  Created by Elwinfrederick on 16/08/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MQExtensionProtocol < NSObject >

- (instancetype) mq ;

/// make sure that when blocks is invoked ,
/// the object in blocks , was never can't be nil
/// use MQ_TYPE(_type_ , sameObject) to force 'sameObject' with aspecific value .
- (instancetype) mq : (id (^)(id same_object)) sameObject;

/// intialize a value that definitly can't be nil
+ (instancetype) MQ_NON_NULL : (void(^)(id value)) setting;
/// c function type , same as + (instancetype)MQ_Non_NULL:
id MQ_NON_NULL(Class clazz , void (^setting)(id value));

+ (void) mq_end ;
- (void) mq_end ;

@end

@interface NSObject (MQProtocol) < MQExtensionProtocol >

@end
