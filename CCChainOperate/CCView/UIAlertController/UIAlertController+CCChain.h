//
//  UIAlertController+CCChain.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 06/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSDictionary CCAlertActionInfo;

@interface UIAlertController (CCChain)

/// init
@property (nonatomic , class , copy , readonly) UIAlertController *(^common)(); // default alert
@property (nonatomic , class , copy , readonly) UIAlertController *(^commonS)(UIAlertControllerStyle style);

@property (nonatomic , copy , readonly) UIAlertController *(^titleS)(NSString *sTitle);
@property (nonatomic , copy , readonly) UIAlertController *(^messageS)(NSString *sMessage);
@property (nonatomic , copy , readonly) UIAlertController *(^actionS)(CCAlertActionInfo *d , void(^)(UIAlertAction *action));
@property (nonatomic , copy , readonly) UIAlertController *(^actionA)(NSArray < CCAlertActionInfo *> *a , void(^)(UIAlertAction *action , NSUInteger index));

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
