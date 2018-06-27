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

typedef NSString * CCDateFormatterTypeKey NS_EXTENSIBLE_STRING_ENUM;

FOUNDATION_EXPORT CCDateFormatterTypeKey cc_date_formatter_type_1 ; // @"yyyy-MM-dd HH:mm:ss"
FOUNDATION_EXPORT CCDateFormatterTypeKey cc_date_formatter_type_2 ; // @"yyyy-MM-dd HH:mm:ss.SSS"
FOUNDATION_EXPORT CCDateFormatterTypeKey cc_date_formatter_type_3 ; // @"yyyy-MM-dd HH:mm:ss.ssssss"
FOUNDATION_EXPORT CCDateFormatterTypeKey cc_date_formatter_type_4 ; // @"yyyy-MM-dd hh:mm:ss tt"
FOUNDATION_EXPORT CCDateFormatterTypeKey cc_date_formatter_type_5 ; // @"yyyy-MM-dd HH:mm:ss"
FOUNDATION_EXPORT CCDateFormatterTypeKey cc_date_formatter_type_6 ; // @"yyyy-MMMM-dd HH:mm:ss"
FOUNDATION_EXPORT CCDateFormatterTypeKey cc_date_formatter_type_7 ; // @"yyyy-MMM-dd HH:mm:ss"

@interface NSDateFormatter (CCExtension)

+ (instancetype) cc_common ;
+ (instancetype) cc_common_using_Asia_Shanghai ;

/// if user chose another calendar (not local) , use it to recorrect it .
// 如果用户选择的是不是本地的日历 , 调用此方法来纠正 .
- (void) cc_recorrect_timezone ;

/// append format from another . // 从另一个 NSDateFormatter 实例中添加
- (instancetype) cc_appending_format : (__kindof NSDateFormatter *) format
                          need_space : (BOOL) is_need ;

@end
