//
//  NSNumber+CCChain.h
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 02/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (CCChain)

@property (nonatomic , copy , readonly) NSDecimalNumber *(^decimal)();

@end

#pragma mark - -----

@interface NSDecimalNumber (CCChain)

@property (nonatomic , copy , readonly) NSString *(^round)(); // default after two points .
@property (nonatomic , copy , readonly) NSString *(^roundAfter)(short point);
@property (nonatomic , copy , readonly) NSString *(^roundAfterM)(short point , NSRoundingMode mode);

@property (nonatomic , copy , readonly) NSDecimalNumber *(^roundD)();
@property (nonatomic , copy , readonly) NSDecimalNumber *(^roundAfterD)(short point);
@property (nonatomic , copy , readonly) NSDecimalNumber *(^roundAfterMD)(short point , NSRoundingMode mode);

@property (nonatomic , copy , readonly) NSDecimalNumber *(^multiply)(NSDecimalNumber *decimal);
@property (nonatomic , copy , readonly) NSDecimalNumber *(^devide)(NSDecimalNumber *decimal);

@end
