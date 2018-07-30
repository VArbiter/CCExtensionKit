//
//  UIAlertController+MQExtension.h
//  MQExtensionKit
//
//  Created by 冯明庆 on 26/06/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSDictionary CCAlertActionInfo;

@interface UIAlertController (MQExtension)

/// default alert // 默认 alert 样式
+ (instancetype) mq_common ;
+ (instancetype) mq_common : (UIAlertControllerStyle) style ;

- (instancetype) mq_title : (NSString *) sTitle ;
- (instancetype) mq_message : (NSString *) sMessage ;

- (instancetype) mq_action : (CCAlertActionInfo *) info
                    action : (void(^)( __kindof UIAlertAction *action)) action ;
- (instancetype) mq_action_s : (NSArray < CCAlertActionInfo *> *) array
                      action : (void(^)( __kindof UIAlertAction *action , NSUInteger index)) actionT ;

CCAlertActionInfo * CCAlertActionInfoMake(NSString * title, UIAlertActionStyle style) ;

@end

#pragma mark - -----

@interface CCAlertActionEntity : NSObject

@property (nonatomic , strong) NSString *s_title ;
@property (nonatomic , assign) UIAlertActionStyle style;
@property (nonatomic , assign) NSInteger index ;

@end

#pragma mark - -----

@interface UIAlertAction (MQExtension)

@property (nonatomic , strong) CCAlertActionEntity *action_m ;

@end
