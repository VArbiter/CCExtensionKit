//
//  UIResponder+MQExtension.h
//  MQExtensionKit
//
//  Created by ElwinFrederick on 07/05/2018.
//  Copyright © 2018 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (MQExtension)

/// deliver the UI messages . // 传递 UI 消息 .
/// selector is used for identifier the message to be sent . // 方法是用来标识将要被发送的消息
/// block is used for when messages responsder is found . // 当 message 的响应者被找到 , block 会执行 .
- (void) mq_deliver_message_with_sel : (SEL) selector
                               using : (void (^)(__kindof UIResponder *responder)) message_block ;

@end
