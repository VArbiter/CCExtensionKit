//
//  NSDate+MQExtension.h
//  MQExtensionKit
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
- (NSString *) mq_time_since_1970 : (NSTimeInterval) interval;
- (NSString *) mq_time_since_1970 : (NSTimeInterval) interval
                           format : (NSString *) s_format;

/// return whether if its display as 24 hours . // 决定时间是否显示为 24 小时制
+ (BOOL) mq_is_24_hours_settings ;
@property (nonatomic , readonly) BOOL is_24_hour_settings ;

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
- (NSDate *) mq_to_date_with_format : (NSString *) s_format ; /// custom format . // 自定义格式

@property (nonatomic , readonly) CCTimeStick toTimeStick;

@end

typedef NSString * CCDateFormatterTypeKey NS_EXTENSIBLE_STRING_ENUM;

FOUNDATION_EXPORT CCDateFormatterTypeKey mq_date_formatter_type_1 ; // @"yyyy-MM-dd HH:mm:ss"
FOUNDATION_EXPORT CCDateFormatterTypeKey mq_date_formatter_type_2 ; // @"yyyy-MM-dd HH:mm:ss.SSS"
FOUNDATION_EXPORT CCDateFormatterTypeKey mq_date_formatter_type_3 ; // @"yyyy-MM-dd HH:mm:ss.ssssss"
FOUNDATION_EXPORT CCDateFormatterTypeKey mq_date_formatter_type_4 ; // @"yyyy-MM-dd hh:mm:ss tt"
FOUNDATION_EXPORT CCDateFormatterTypeKey mq_date_formatter_type_5 ; // @"yyyy-MM-dd HH:mm:ss"
FOUNDATION_EXPORT CCDateFormatterTypeKey mq_date_formatter_type_6 ; // @"yyyy-MMMM-dd HH:mm:ss"
FOUNDATION_EXPORT CCDateFormatterTypeKey mq_date_formatter_type_7 ; // @"yyyy-MMM-dd HH:mm:ss"

@interface NSDateFormatter (CCExtension)

+ (instancetype) mq_common ;
+ (instancetype) mq_common_using_Asia_Shanghai ;

/// make sure you get the right format of time . // 来保证你获得的时间格式是对的
// for : user set time to 12 and you want get it with 24 . // 针对 : 用户设置时间是12小时制 , 而你想得到的是24小时制
- (instancetype) mq_set_locale_to_en_US ;

/// if user chose another calendar (not local) , use it to recorrect it .
// 如果用户选择的是不是本地的日历 , 调用此方法来纠正 .
- (void) mq_recorrect_timezone ;

/// append format from another . // 从另一个 NSDateFormatter 实例中添加
- (instancetype) mq_appending_format : (__kindof NSDateFormatter *) format
                          need_space : (BOOL) is_need ;

@end
