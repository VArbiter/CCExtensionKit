//
//  NSDate+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/11.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "NSDate+CCExtension.h"
#import "CCCommonDefine.h"

@implementation NSDate (CCExtension)

- (NSInteger)ccFirstWeekdayInThisMonth{
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

- (NSInteger)ccDay{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                                                   fromDate:self];
    return [components day];
}

- (NSInteger)ccGetDateWeekday{
    NSInteger weekDay = [self ccFirstWeekdayInThisMonth];
    NSInteger day = [self ccDay];
    
    NSInteger currentWeekNum = (day + weekDay - 1) % 7;
    if (currentWeekNum == 0) {
        currentWeekNum = 7;
    }
    return currentWeekNum;
}

- (NSString *) ccWeekDays {
    switch (self.ccGetDateWeekday) {
        case 1:{
            return ccLocalize(@"_CC_MON_", "一");
        }break;
        case 2:{
            return ccLocalize(@"_CC_TUE_", "二");
        }break;
        case 3:{
            return ccLocalize(@"_CC_WEN_", "三");
        }break;
        case 4:{
            return ccLocalize(@"_CC_THUR_", "四");
        }break;
        case 5:{
            return ccLocalize(@"_CC_FRI_", "五");
        }break;
        case 6:{
            return ccLocalize(@"_CC_SAT_", "六");
        }break;
        case 7:{
            return ccLocalize(@"_CC_SUN_", "七");
        }break;
            
        default:{
            return ccLocalize(@"_CC_MON_", "一");
        }break;
    }
}

@end
