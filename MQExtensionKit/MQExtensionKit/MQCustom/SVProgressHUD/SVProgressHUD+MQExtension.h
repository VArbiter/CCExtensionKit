//
//  SVProgressHUD+MQExtension.h
//  MQExtensionKit
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

/// not singleton , not in the stack of original SVProgressHUD , but can be customize without affect others.
/// be sure to dismiss it .
// 非单例 , 不会进入到 SVProgressHUD 的原始栈中 . 但是可以单独设置且不影响到其它 .
// 要保证它会被 dismiss 掉 .
+ (instancetype) mq_instance ;

/// these methods below only works for instances , not the SVProgressHUD singleton .
// 下面方法只针对 实体 , 不对 SVProgressHUD 的 单例起效 .

- (instancetype) mq_show ;

- (instancetype) mq_show_with_status : (NSString *) status ;

- (instancetype) mq_show_progress : (float) f_progress ;
- (instancetype) mq_show_progress : (float) f_progress
                           status : (NSString *) status ;

- (instancetype) mq_set_status : (NSString *) status ;

- (instancetype) mq_show_info : (NSString *) status ;
- (instancetype) mq_show_success : (NSString *) status ;
- (instancetype) mq_show_error : (NSString *) status ;

- (instancetype) mq_show_image : (UIImage *) image
                        status : (NSString *) status ;

- (instancetype) mq_dismiss ;
- (instancetype) mq_dismiss_delay : (NSTimeInterval) f_delay ;
- (instancetype) mq_dismiss_completion : (SVProgressHUDDismissCompletion) completion ;
- (instancetype) mq_dismiss_delay : (NSTimeInterval) f_delay
                       completion : (SVProgressHUDDismissCompletion) completion ;

- (BOOL) mq_is_visible ;

@end

#endif
