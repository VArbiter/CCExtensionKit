//
//  SVProgressHUD+MQExtension.h
//  MQExtension_Example
//
//  Created by ElwinFrederick on 2018/8/1.
//  Copyright © 2018 ElwinFrederick. All rights reserved.
//

#if __has_include(<SVProgressHUD/SVProgressHUD.h>)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"
    @import SVProgressHUD;
#pragma clang diagnostic pop

@interface SVProgressHUD (MQExtension)

/// adding notification for SVProgressHUD using blocks . // 使用 block 给 SVProgressHUD 添加通知
+ (void) mq_notification : (void(^)(NSNotification *sender ,
                                    NSString * s_notification_name ,
                                    id user_info)) mq_notification_block
                 for_key : (NSString *) s_key ;

/// be sure to remove the block when dealloc (like normal notifications) .
// 一定记得 在 dealloc 的时候 remove 掉 这个 . (像普通的通知一样)
+ (void) mq_notification_remove_for_key : (NSString *) s_key ;
/// remove all notifications . // 移除所有的通知.
+ (void) mq_notification_remove_all ;

@end

#endif
