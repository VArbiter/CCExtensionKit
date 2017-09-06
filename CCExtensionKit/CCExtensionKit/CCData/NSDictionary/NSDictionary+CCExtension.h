//
//  NSDictionary+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/20.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (CCExtension)

+ (instancetype) ccJson : (NSString *) sJson ;

@end

#pragma mark - -----

@interface NSMutableDictionary (CCExtension)

- (instancetype) ccSet : (id) key
                 value : (id) value ;

/// set key && value with observer
- (instancetype) ccSetWithObserver : (id) key
                             value : (id) value ;

- (instancetype) ccObserver : (void (^)(id key , id value)) action ;
- (instancetype) ccObserverT : (void (^)(void(^t)(id key , id value , NSArray * aAllKeys , NSArray * aAllValues))) action ;

@end
