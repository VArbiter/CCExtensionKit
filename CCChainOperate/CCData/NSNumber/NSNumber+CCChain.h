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
