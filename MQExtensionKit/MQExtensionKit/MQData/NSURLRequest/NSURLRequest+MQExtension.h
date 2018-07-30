//
//  NSURLRequest+MQExtension.h
//  MQExtensionKit
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest (CCExtension)

+ (instancetype) mq_request : (NSString *) sURL ;
+ (instancetype) mq_local : (NSString *) sURL ;

@end

#pragma mark - -----

@interface NSMutableURLRequest (CCExtension)

@end
