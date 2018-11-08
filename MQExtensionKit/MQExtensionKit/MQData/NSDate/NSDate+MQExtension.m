//
//  NSDate+MQExtension.m
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/4/11.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "NSDate+MQExtension.h"
#import "NSObject+MQExtension.h"

@implementation NSDate (MQExtension)

- (NSInteger)first_weekday_in_this_month {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                         fromDate:self];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday
                                                  inUnit:NSCalendarUnitWeekOfMonth
                                                 forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}
- (NSInteger)day {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                                                   fromDate:self];
    return [components day];
}
- (NSInteger)to_date_weekday {
    NSInteger currentWeekNum = (self.day + self.first_weekday_in_this_month - 1) % 7;
    if (currentWeekNum == 0) {
        currentWeekNum = 7;
    }
    return currentWeekNum;
}

- (MQWeekType)to_weekday {
    switch (self.to_date_weekday) {
        case 1:{
            return MQWeekType_Monday;
        }break;
        case 2:{
            return MQWeekType_Tuesday;
        }break;
        case 3:{
            return MQWeekType_Wednesday;
        }break;
        case 4:{
            return MQWeekType_Thursday;
        }break;
        case 5:{
            return MQWeekType_Friday;
        }break;
        case 6:{
            return MQWeekType_Saturday;
        }break;
        case 7:{
            return MQWeekType_Sunday;
        }break;
            
        default:{
            return MQWeekType_Unknow;
        }break;
    }
}

- (NSTimeInterval)to_timestick_interval {
    return self.timeIntervalSinceReferenceDate ;
}

- (NSString *) mq_time_since_1970 : (NSTimeInterval) interval {
    return [self mq_time_since_1970:interval
                             format:@"yyyy-MM-dd HH:mm"];
}

- (NSString *) mq_time_since_1970 : (NSTimeInterval) interval
                           format : (NSString *) s_format {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = s_format;
    NSString *string = [formatter stringFromDate:date];
    return string;
}

+ (BOOL) mq_is_24_hours_settings {
    return NSDate.date.is_24_hour_settings;
}

- (BOOL)is_24_hour_settings {
    BOOL is_24_hours = YES;
    NSString *s_date = [self descriptionWithLocale:NSLocale.currentLocale];
    NSArray  *t_symbols = @[NSCalendar.currentCalendar.AMSymbol ,
                            NSCalendar.currentCalendar.PMSymbol];
    for (NSString *s_symbol in t_symbols) {
        if ([s_date rangeOfString:s_symbol].location != NSNotFound) {
            is_24_hours = NO;
            break;
        }
    }
    return is_24_hours;
}

@end

@implementation NSString (MQExtension_String_Convert)

- (NSDate *)to_date {
    if (!mq_is_string_valued(self)) return [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [formatter dateFromString:self] ;
    if (date) return date;
    
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    date = [formatter dateFromString:self] ;
    if (date) return date;
    
    formatter.dateFormat = @"yyyy-MM-dd HH";
    date = [formatter dateFromString:self] ;
    if (date) return date;
    
    formatter.dateFormat = @"yyyy-MM-dd";
    date = [formatter dateFromString:self] ;
    if (date) return date;
    
    formatter.dateFormat = @"yyyy-MM";
    date = [formatter dateFromString:self] ;
    if (date) return date;
    
    formatter.dateFormat = @"yyyy";
    date = [formatter dateFromString:self] ;
    if (date) return date;
    
    return nil;
}

- (NSDate *) mq_to_date_with_format : (NSString *) s_format {
    if (!mq_is_string_valued(self)) return [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = s_format;
    return [formatter dateFromString:self] ;
}

- (MQTimeStick)to_timestick {
    NSDate *date = self.to_date;
    if (!date)
        return MQTimeStick_Error;
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:date]; // the specific time point until now (in seconds) / 距离现在到过去特定时间点的秒数
    NSTimeInterval interval_seconds_judge = timeInterval / 60 ; // minute / 分钟
    NSTimeInterval interval_day_judge = timeInterval / (60 * 60) ; // hours / 小时
    NSTimeInterval interval_week_judge = timeInterval / (60 * 60 * 24); // days / 天
    NSTimeInterval interval_month_judge = timeInterval / (60 * 60 * 24 * 30); // months / 月
    
    if (interval_seconds_judge <= 1)
        return MQTimeStick_Seconds_Ago ;
    if (interval_seconds_judge > 1 && interval_seconds_judge < 60)
        return MQTimeStick_Minutes_Ago;
    if (interval_day_judge <= 24)
        return MQTimeStick_Today;
    if (interval_week_judge > 1 && interval_week_judge < 2)
        return MQTimeStick_Yesterday;
    if (interval_week_judge > 2 && interval_week_judge <= 7)
        return MQTimeStick_This_Week;
    if (interval_month_judge <= 1)
        return MQTimeStick_This_Month;
    if (interval_month_judge > 1)
        return MQTimeStick_Earlier ;
    return MQTimeStick_Error;
}

@end

#pragma mark - -----

MQDateFormatterTypeKey mq_date_formatter_type_1 = @"yyyy-MM-dd HH:mm:ss" ;
MQDateFormatterTypeKey mq_date_formatter_type_2 = @"yyyy-MM-dd HH:mm:ss.SSS";
MQDateFormatterTypeKey mq_date_formatter_type_3 = @"yyyy-MM-dd HH:mm:ss.ssssss";
MQDateFormatterTypeKey mq_date_formatter_type_4 = @"yyyy-MM-dd hh:mm:ss tt";
MQDateFormatterTypeKey mq_date_formatter_type_5 = @"yyyy-MM-dd HH:mm:ss";
MQDateFormatterTypeKey mq_date_formatter_type_6 = @"yyyy-MMMM-dd HH:mm:ss";
MQDateFormatterTypeKey mq_date_formatter_type_7 = @"yyyy-MMM-dd HH:mm:ss";

@implementation NSDateFormatter (MQExtension)

+ (instancetype) mq_common {
    return [[self alloc] init];
}
+ (instancetype) mq_common_using_Asia_Shanghai {
    NSDateFormatter *format = [self mq_common];
    [format setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    return format;
}

- (instancetype) mq_set_locale_to_en_US {
    [self setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    return self;
}

- (void) mq_recorrect_timezone {
    [self setCalendar:[[NSCalendar alloc]
                       initWithCalendarIdentifier:NSCalendarIdentifierGregorian]];
}
- (instancetype) mq_appending_format : (__kindof NSDateFormatter *) format
                          need_space : (BOOL) is_need {
    NSString *s_format = format.dateFormat;
    if (!s_format || !s_format.length) return self;
    NSString *s = (self.dateFormat && self.dateFormat.length) ? self.dateFormat : @"" ;
    if (is_need) {
        [[s stringByAppendingString:@" "] stringByAppendingString:s_format];
    }
    else {
        [s stringByAppendingString:s_format];
    }
    
    [self setDateFormat:s];
    return self;
}

@end

