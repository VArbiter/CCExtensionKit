//
//  NSDate+YMExtension.m
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/4/11.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "NSDate+YMExtension.h"

@implementation NSDate (YMExtension)

- (NSInteger)ymFirstWeekdayInThisMonth{
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

- (NSInteger)ymDay{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                                                   fromDate:self];
    return [components day];
}

- (NSInteger)ymGetDateWeekday{
    NSInteger weekDay = [self ymFirstWeekdayInThisMonth];
    NSInteger day = [self ymDay];
    
    NSInteger currentWeekNum = (day + weekDay - 1) % 7;
    if (currentWeekNum == 0) {
        currentWeekNum = 7;
    }
    return currentWeekNum;
}

- (NSString *) ymWeekDays {
    switch (self.ymGetDateWeekday) {
        case 1:{
            return ccLocalize(@"_YM_MON_", "一");
        }break;
        case 2:{
            return ccLocalize(@"_YM_TUE_", "二");
        }break;
        case 3:{
            return ccLocalize(@"_YM_WEN_", "三");
        }break;
        case 4:{
            return ccLocalize(@"_YM_THUR_", "四");
        }break;
        case 5:{
            return ccLocalize(@"_YM_FRI_", "五");
        }break;
        case 6:{
            return ccLocalize(@"_YM_SAT_", "六");
        }break;
        case 7:{
            return ccLocalize(@"_YM_SUN_", "七");
        }break;
            
        default:{
            return ccLocalize(@"_YM_MON_", "一");
        }break;
    }
}

NSString * ccLocalize(NSString *stringLocalKey , char *c) {
    return NSLocalizedStringFromTableInBundle(stringLocalKey, @"LocalizableMain", [NSBundle mainBundle], nil);
}

@end
