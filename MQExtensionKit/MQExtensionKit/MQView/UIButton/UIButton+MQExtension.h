//
//  UIButton+MQExtension.h
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/4/6.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (MQExtension)

/// default type is custom // 默认是 custom 类型
+ (instancetype) mq_common ;
+ (instancetype) mq_common : (UIButtonType) type ;

/// titles && images // title 和 images
- (instancetype) mq_title : (NSString *) sTitle
                    state : (UIControlState) state ;
- (instancetype) mq_image : (UIImage *) image
                    state : (UIControlState) state ;

/// actions , default is touchUpInside // 动作  默认 touchUpInside
- (instancetype) mq_action : (void (^)( __kindof UIButton *sender)) action ;
- (instancetype) mq_target : (id) target
                    action : (void (^)( __kindof UIButton *sender)) action ;

/// custom actions . // 自定义动作
- (instancetype) mq_custom : (id) target
                       sel : (SEL) sel
                    events : (UIControlEvents) events ;

@end
