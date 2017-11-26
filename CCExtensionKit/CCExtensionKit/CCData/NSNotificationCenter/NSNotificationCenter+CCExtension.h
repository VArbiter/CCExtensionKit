//
//  NSNotificationCenter+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 23/11/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNotificationCenter (CCExtension)

/// euqals NSNotificationCenter.defaultCenter
+ (instancetype) common ;
/// an easy way to post a notification object : nil , userInfo : nil
+ (instancetype) ccPost : (NSNotificationName) sNotification ;
+ (instancetype) ccPostT : (NSNotification *) notification ;

/// note : when post using method below ,
/// note : the receiver will do the operations on the thread the poster in .
+ (instancetype) ccAsyncPostOnQueue : (dispatch_queue_t) queue
                       notification : (NSNotificationName) sNofification ;

/// note : if queue == main queue ,
/// note : once receive the notification , observer will deploy it immediately on main queue .
/// note : recommended to use it for large process tasks .
/// note : if on sub thread , using some actions that might operate the UI , be sure to get it on main queue .
+ (instancetype) ccAsyncObserverTarget : (id) target
                                 queue : (dispatch_queue_t) queue
                                   sel : (SEL) selector
                          notification : (NSNotificationName) sNotificationName
                                   obj : (id) object ;

@end

#pragma mark - -----

@interface NSNotification (CCExtension_Notification)

/// note : need deploy && execute .
/// note : if muti receiver execute the block ,
/// note : it will run muti times just as the receiver executed times .
@property (nonatomic , copy) void (^bExecute)(__kindof NSNotification *sender);

@end
