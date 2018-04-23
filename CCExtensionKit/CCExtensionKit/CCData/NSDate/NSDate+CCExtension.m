//
//  NSDate+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/11.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "NSDate+CCExtension.h"
#import "NSObject+CCExtension.h"

@implementation NSDate (CCExtension)

- (NSInteger)firstWeekdayInThisMonth {
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
- (NSInteger)toDateWeekday {
    NSInteger currentWeekNum = (self.day + self.firstWeekdayInThisMonth - 1) % 7;
    if (currentWeekNum == 0) {
        currentWeekNum = 7;
    }
    return currentWeekNum;
}

- (CCWeekType)toWeekday {
    switch (self.toDateWeekday) {
        case 1:{
            return CCWeekType_Monday;
        }break;
        case 2:{
            return CCWeekType_Tuesday;
        }break;
        case 3:{
            return CCWeekType_Wednesday;
        }break;
        case 4:{
            return CCWeekType_Thursday;
        }break;
        case 5:{
            return CCWeekType_Friday;
        }break;
        case 6:{
            return CCWeekType_Saturday;
        }break;
        case 7:{
            return CCWeekType_Sunday;
        }break;
            
        default:{
            return CCWeekType_Unknow;
        }break;
    }
}

- (NSString *) cc_time_since_1970 : (NSTimeInterval) interval {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *string = [formatter stringFromDate:date];
    return string;
}

@end

@implementation NSString (CCExtension_String_Convert)

- (NSDate *)toDate {
    if (!CC_IS_STRING_VALUED(self)) return [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [formatter dateFromString:self];
}

- (CCTimeStick)toTimeStick {
    NSDate *date = self.toDate;
    if (!date)
        return CCTimeStick_Error;
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:date]; // the specific time point until now (in seconds) / 距离现在到过去特定时间点的秒数
    NSTimeInterval interval_seconds_judge = timeInterval / 60 ; // minute / 分钟
    NSTimeInterval interval_day_judge = timeInterval / (60 * 60) ; // hours / 小时
    NSTimeInterval interval_week_judge = timeInterval / (60 * 60 * 24); // days / 天
    NSTimeInterval interval_month_judge = timeInterval / (60 * 60 * 24 * 30); // months / 月
    
    if (interval_seconds_judge <= 1)
        return CCTimeStick_Seconds_Ago ;
    if (interval_seconds_judge > 1 && interval_seconds_judge < 60)
        return CCTimeStick_Minutes_Ago;
    if (interval_day_judge <= 24)
        return CCTimeStick_Today;
    if (interval_week_judge > 1 && interval_week_judge < 2)
        return CCTimeStick_Yesterday;
    if (interval_week_judge > 2 && interval_week_judge <= 7)
        return CCTimeStick_This_Week;
    if (interval_month_judge <= 1)
        return CCTimeStick_This_Month;
    if (interval_month_judge > 1)
        return CCTimeStick_Earlier ;
    return CCTimeStick_Error;
}

@end
