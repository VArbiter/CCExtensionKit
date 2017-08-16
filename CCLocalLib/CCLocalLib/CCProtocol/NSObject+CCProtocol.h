//
//  NSObject+CCProtocol.h
//  RisSubModule
//
//  Created by Elwinfrederick on 16/08/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CCRememberProtocol < NSObject >

- (instancetype) cc ;

@end

@interface NSObject (CCProtocol) < CCRememberProtocol >

@end
