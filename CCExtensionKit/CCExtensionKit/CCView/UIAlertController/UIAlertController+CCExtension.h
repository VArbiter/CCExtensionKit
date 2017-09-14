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

/// default alert
+ (instancetype) common ;
+ (instancetype) common : (UIAlertControllerStyle) style ;

- (instancetype) ccTitle : (NSString *) sTitle ;
- (instancetype) ccMessage : (NSString *) sMessage ;

- (instancetype) ccAction : (CCAlertActionInfo *) info
                   action : (void(^)( __kindof UIAlertAction *action)) action ;
- (instancetype) ccActions : (NSArray < CCAlertActionInfo *> *) array
                    action : (void(^)( __kindof UIAlertAction *action , NSUInteger index)) actionT ;

CCAlertActionInfo * CCAlertActionInfoMake(NSString * title, UIAlertActionStyle style) ;

@end

#pragma mark - -----

@interface CCAlertActionEntity : NSObject

@property (nonatomic , strong) NSString *sTitle ;
@property (nonatomic , assign) UIAlertActionStyle style;
@property (nonatomic , assign) NSInteger index ;

@end

#pragma mark - -----

@interface UIAlertAction (CCExtension)

@property (nonatomic , strong) CCAlertActionEntity *actionM ;

@end