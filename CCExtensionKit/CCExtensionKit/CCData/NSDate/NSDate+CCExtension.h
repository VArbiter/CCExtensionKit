//
//  NSDate+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/11.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (CCExtension)

@property (nonatomic , readonly) NSInteger firstWeekdayInThisMonth ;
@property (nonatomic , readonly) NSInteger day ;
@property (nonatomic , readonly) NSInteger dateWeekday ;
@property (nonatomic , readonly) NSString * weekday ; // returns current week days // 返回当前的日期

/// yyyy-MM-dd HH:mm
- (NSString *) ccTimeSince1970 : (NSTimeInterval) interval;


@end
