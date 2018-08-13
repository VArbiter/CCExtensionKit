//
//  NSError+MQExtension.h
//  MQExtension_Example
//
//  Created by ElwinFrederick on 2018/8/13.
//  Copyright © 2018 ElwinFrederick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (MQExtension)

+ (instancetype) mq_error_with_code : (NSInteger) i_code
                        description : (NSString *) s_description ;

@end
