//
//  NSObject+CCProtocol.h
//  RisSubModule
//
//  Created by Elwinfrederick on 16/08/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CCExtensionProtocol < NSObject >

- (instancetype) cc ;

/// make sure that when blocks is deploy ,
/// the object in blocks , was never can't be nil
/// use CC_TYPE(_type_ , sameObject) to force 'sameObject' with aspecific value .
- (instancetype) cc : (id (^)(id same_object)) sameObject;

/// intialize a value that definitly can't be nil
+ (instancetype) CC_NON_NULL : (void(^)(id value)) setting;
/// c function type , same as + (instancetype)CC_Non_NULL:
id CC_NON_NULL(Class clazz , void (^setting)(id value));

+ (void) cc_end ;
- (void) cc_end ;

@end

@interface NSObject (CCProtocol) < CCExtensionProtocol >

@end
