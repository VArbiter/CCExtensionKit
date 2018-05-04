//
//  NSDate+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/11.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger , CCWeekType) {
    CCWeekType_Unknow = 0,
    CCWeekType_Monday ,
    CCWeekType_Tuesday ,
    CCWeekType_Wednesday ,
    CCWeekType_Thursday ,
    CCWeekType_Friday ,
    CCWeekType_Saturday ,
    CCWeekType_Sunday
};

@interface NSDate (CCExtension)

@property (nonatomic , readonly) NSInteger firstWeekdayInThisMonth ;
@property (nonatomic , readonly) NSInteger day ;
@property (nonatomic , readonly) NSInteger toDateWeekday ;
@property (nonatomic , readonly) CCWeekType toWeekday ; // returns current week days // 返回当前的日期
@property (nonatomic , readonly) NSTimeInterval toTimeStickInterval ; // get time stick since refrence date . // 从公元 0 年开始计算 .

/// default @"yyyy-MM-dd HH:mm"
- (NSString *) cc_time_since_1970 : (NSTimeInterval) interval;
- (NSString *) cc_time_since_1970 : (NSTimeInterval) interval
                           format : (NSString *) s_format;

@end

typedef NS_ENUM(NSInteger , CCTimeStick) {
    CCTimeStick_Error = 0 ,
    CCTimeStick_Seconds_Ago ,
    CCTimeStick_Minutes_Ago ,
    CCTimeStick_Today ,
    CCTimeStick_Yesterday ,
    CCTimeStick_This_Week ,
    CCTimeStick_This_Month ,
    CCTimeStick_Earlier ,
};

@interface NSString (CCExtension_String_Convert)

/// eg: @"2018-03-28 15:31:42" , @"2018-03-28 15:31" , @"2018-03-28"
@property (nonatomic , readonly) NSDate *toDate;
- (NSDate *) cc_to_date_with_format : (NSString *) s_format ; /// custom format . // 自定义格式

@property (nonatomic , readonly) CCTimeStick toTimeStick;

@end
