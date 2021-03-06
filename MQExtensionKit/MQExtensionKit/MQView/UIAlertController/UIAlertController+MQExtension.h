//
//  UIAlertController+MQExtension.h
//  MQExtensionKit
//
//  Created by 冯明庆 on 26/06/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSDictionary MQAlertActionInfo;

@interface UIAlertController (MQExtension)

/// default alert // 默认 alert 样式
+ (instancetype) mq_common ;
+ (instancetype) mq_common : (UIAlertControllerStyle) style ;

- (instancetype) mq_title : (NSString *) s_title ;
- (instancetype) mq_message : (NSString *) s_message ;

- (instancetype) mq_action : (MQAlertActionInfo *) info
                    action : (void(^)( __kindof UIAlertAction *action)) action ;
- (instancetype) mq_action_s : (NSArray < MQAlertActionInfo *> *) array
                      action : (void(^)( __kindof UIAlertAction *action , NSUInteger index)) action ;

MQAlertActionInfo * MQAlertActionInfoMake(NSString * title, UIAlertActionStyle style) ;

@end

#pragma mark - -----

@interface MQAlertActionEntity : NSObject

@property (nonatomic , strong) NSString *s_title ;
@property (nonatomic , assign) UIAlertActionStyle style;
@property (nonatomic , assign) NSInteger index ;

@end

#pragma mark - -----

@interface UIAlertAction (MQExtension)

@property (nonatomic , strong) MQAlertActionEntity *action_m ;

@end
