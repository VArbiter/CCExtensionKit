//
//  UIBarButtonItem+MQExtension.h
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/4/26.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (MQExtension)

+ (instancetype) mq_common ;
- (instancetype) mq_title : (NSString *) s_title ;
- (instancetype) mq_image : (UIImage *) image ;
- (instancetype) mq_action : (void (^)( __kindof UIBarButtonItem *sender)) action ;
- (instancetype) mq_target : (id) target
                    action : (void (^)( __kindof UIBarButtonItem *sender)) action ;

@end
