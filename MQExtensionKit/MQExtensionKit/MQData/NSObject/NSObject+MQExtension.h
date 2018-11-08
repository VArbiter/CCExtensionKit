//
//  NSObject+MQExtension.h
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/4/20.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (MQExtension)

@property (nonatomic , class , copy , readonly) NSString * s_self;
@property (nonatomic , class , readonly) Class Self;

@property (nonatomic , copy , readonly) NSString * to_string ;

@end

BOOL mq_is_string_valued(__kindof NSString * string) ;
BOOL mq_is_array_valued(__kindof NSArray * array) ;
BOOL mq_is_set_valued(__kindof NSSet * set) ;
BOOL mq_is_dictionary_valued(__kindof NSDictionary * dictionary) ;
BOOL mq_is_decimal_valued(__kindof NSDecimalNumber * decimal) ;
BOOL mq_is_null(id object) ;

NSString * mq_log_object(id object);

@interface NSObject (MQExtension_KVO)

/// a block way to manage KVO .
+ (instancetype) mq_common ;

/// default options : NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld ;
- (instancetype) mq_add_observer_for : (NSString *) s_key_path
                            observer : (void (^)(NSString * s_key_path , id object , NSDictionary * change , void * context)) block_observer ;
- (instancetype) mq_add_observer_for : (NSString *) s_key_path
                             options : (NSKeyValueObservingOptions) options
                            observer : (void (^)(NSString * s_key_path , id object , NSDictionary * change , void * context)) block_observer ;
- (instancetype) mq_add_observer_for : (NSString *) s_key_path
                             options : (NSKeyValueObservingOptions) options
                             context : (void *) context
                            observer : (void (^)(NSString * s_key_path , id object , NSDictionary * change , void * context)) block_observer ;

- (void) mq_remove_observer_for : (NSString *) s_key_path ;
- (void) mq_remove_all_observers_and_destory ;

@end
