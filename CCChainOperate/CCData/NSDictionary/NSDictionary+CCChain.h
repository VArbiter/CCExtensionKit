//
//  NSDictionary+CCChain.h
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 02/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (CCChain)

@end

@interface NSMutableDictionary (CCChain)

@property (nonatomic , copy , readonly) NSMutableDictionary *(^set)(id key , id value);
@property (nonatomic , copy , readonly) NSMutableDictionary *(^setO)(id key , id value);
@property (nonatomic , copy , readonly) NSMutableDictionary *(^observerS)(void(^t)(id key , id value));
@property (nonatomic , copy , readonly) NSMutableDictionary *(^observerT)(void(^t)(id key , id value , NSArray * arrayAllKeys , NSArray * arrayAllValues));

@end
