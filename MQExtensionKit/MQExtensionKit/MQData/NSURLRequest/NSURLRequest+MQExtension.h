//
//  NSURLRequest+MQExtension.h
//  MQExtensionKit
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest (MQExtension)

+ (instancetype) mq_request : (NSString *) s_url ;
+ (instancetype) mq_local : (NSString *) s_url ;

@end

#pragma mark - -----

@interface NSMutableURLRequest (MQExtension)

@end
