//
//  NSUserDefaults+MQExtension.h
//  MQExtensionKit
//
//  Created by 冯明庆 on 18/11/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (MQExtension)

NSUserDefaults * mq_user_defaults(void);

/// an easy way to do 'standardUserDefaults' && 'synchronize' // 一个简便的方式去调用 standardUserDefaults 和 synchronize
BOOL mq_standard_user_defaults(void (^block_def)(NSUserDefaults *sender)) ;

/// reset standard userDefaults . // 重置 standardUserDefaults
void mq_standard_user_defaults_reset(void) ;

/// share the data with other app that under your company || yourself . // 和公司 或 自己共享数据
/// only for the same suite name . // 只在同一个 suite 下生效 .
BOOL mq_user_defaults_s(NSString *s_suite_id , void (^block_def)(NSUserDefaults *sender)) ;

@end
