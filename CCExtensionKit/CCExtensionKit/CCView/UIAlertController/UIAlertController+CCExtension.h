//
//  UIAlertController+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 26/06/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSDictionary CCAlertActionInfo;

@interface UIAlertController (CCExtension)

/// default alert // 默认 alert 样式
+ (instancetype) cc_common ;
+ (instancetype) cc_common : (UIAlertControllerStyle) style ;

- (instancetype) cc_title : (NSString *) sTitle ;
- (instancetype) cc_message : (NSString *) sMessage ;

- (instancetype) cc_action : (CCAlertActionInfo *) info
                    action : (void(^)( __kindof UIAlertAction *action)) action ;
- (instancetype) cc_action_s : (NSArray < CCAlertActionInfo *> *) array
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

@interface UIAlertAction (CCExtension)

@property (nonatomic , strong) CCAlertActionEntity *action_m ;

@end
