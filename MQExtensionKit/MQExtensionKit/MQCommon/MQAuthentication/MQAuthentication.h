//
//  CCAuthentication.h
//  MQExtensionKit
//
//  Created by ElwinFrederick on 24/04/2018.
//  Copyright © 2018 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LAContext ;

@interface CCAuthentication : NSObject

/// beware ,under 'LAPolicyDeviceOwnerAuthenticationWithBiometrics' , 'input password' won't have any effect .// 注意 , 在 LAPolicyDeviceOwnerAuthenticationWithBiometrics 下 , "输入密码" 按钮不会有任何效果
/// if retried over 5 times . fall back block won't have any effect . // 如果尝试超过五次 , 回调 block 不会有任何效果 .

/// remember to add 'NSFaceIDUsageDescription' to your info plist if you are using face ID . // 若使用 face ID , 添加 "NSFaceIDUsageDescription" 到 info plist 文件中 .

- (instancetype) init_with_reason : (NSString *) s_authentication_reason
        show_password_if_bio_fail : (NSString *) s_show ; // input @"" to hide "input password" button // 输入 @"" 隐藏 "输入密码" 按钮
@property (nonatomic , copy , readonly) NSString * s_authentication_reason ;
@property (nonatomic , copy , readonly) NSString * s_show ;
@property (nonatomic , strong , readonly) LAContext *context ;

- (instancetype) mq_start_authentication : (void(^)(void)) success_block
                                    fail : (void(^)(NSError * error)) fail_block ;

- (instancetype) mq_start_authentication_face_id : (void (^)(void))success_block
                                             fail:(void (^)(NSError * error))fail_block ;
- (instancetype) mq_start_authentication_touch_id : (void (^)(void))success_block
                                              fail:(void (^)(NSError * error))fail_block ;

/// if the system version is under iOS 9 , then it can only verify with Touch ID . // 如果手机系统低于 9.0 , 那么只能用 Touch ID 验证.
- (instancetype) mq_start_authentication_password : (void (^)(void))success_block
                                                fail:(void (^)(NSError * error))fail_block ;

@end
