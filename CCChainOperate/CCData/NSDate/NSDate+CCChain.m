//
//  NSDate+CCChain.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 01/07/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "NSDate+CCChain.h"
#import "CCCommonDefine.h"
#import "CCCommonTools.h"

#import "NSObject+CCChain.h"

@implementation NSDate (CCChain)

- (NSDate *(^)())firstWeekDayInThisMonth {
    ccWeakSelf;
    return ^NSDate *() {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
        NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                             fromDate:self];
        [comp setDay:1];
        NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
        
        pSelf.bridge = ^id{
            return calendar;
        };
        
        return firstDayOfMonthDate;
    };
}

- (NSDate *(^)())weekDay {
    ccWeakSelf;
    return ^NSDate *() {
        pSelf.bridge = ^id{
            return @((pSelf.firstWeekDayInThisMonth().toInt + pSelf.day().toInt - 1) % 7);
        };
        return pSelf;
    };
}

- (NSDate *(^)())day {
    ccWeakSelf;
    return ^NSDate *() {
        pSelf.bridge = ^id{
            return [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                                   fromDate:pSelf];
        };
        return pSelf;
    };
}

- (NSString *)toWeek {
    switch (self.weekDay().toInt) {
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

- (NSUInteger) toInt {
    id value = nil;
    if (self.bridge) {
        value = self.bridge();
    }
    
    if ([value isKindOfClass:NSCalendar.class]) {
        NSUInteger firstWeekday = [(NSCalendar *)value ordinalityOfUnit:NSCalendarUnitWeekday
                                                                 inUnit:NSCalendarUnitWeekOfMonth
                                                                forDate:self];
        return firstWeekday - 1;
    }
    if ([value isKindOfClass:NSDateComponents.class]) {
        return [(NSDateComponents *)value day];
    }
    if ([value isKindOfClass:NSNumber.class]) {
        return [value integerValue];
    }
    
    return -1;
}

- (NSString *)toString {
    return ccStringFormat(@"%@",self);
}

@end
