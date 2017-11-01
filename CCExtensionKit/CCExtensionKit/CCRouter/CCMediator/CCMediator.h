//
//  CCMediator.h
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 14/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCMediator : NSObject

- (instancetype) init NS_UNAVAILABLE;

+ (id) ccPerform : (NSString *) sTarget
          action : (NSString *) sAction
      returnVale : (BOOL) isNeed
           value : (id (^)(void)) value ;

@end
