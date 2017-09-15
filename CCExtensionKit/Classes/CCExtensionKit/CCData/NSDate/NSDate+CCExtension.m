//
//  NSDate+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/11.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "NSDate+CCExtension.h"

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
- (NSInteger)dateWeekday {
    NSInteger currentWeekNum = (self.day + self.firstWeekdayInThisMonth - 1) % 7;
    if (currentWeekNum == 0) {
        currentWeekNum = 7;
    }
    return currentWeekNum;
}

- (NSString *)weekday {
    switch (self.dateWeekday) {
        case 1:{
            return @"1";
        }break;
        case 2:{
            return @"2";
        }break;
        case 3:{
            return @"3";
        }break;
        case 4:{
            return @"4";
        }break;
        case 5:{
            return @"5";
        }break;
        case 6:{
            return @"6";
        }break;
        case 7:{
            return @"7";
        }break;
            
        default:{
            return @"";
        }break;
    }
}

- (NSString *) ccTimeSince1970 : (NSTimeInterval) interval {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *string = [formatter stringFromDate:date];
    return string;
}

@end
