//
//  NSDate+CCChain.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 01/07/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (CCChain)

@property (nonatomic , strong , readonly) NSDate *(^firstWeekDayInThisMonth)();
@property (nonatomic , strong , readonly) NSDate *(^weekDay)();
@property (nonatomic , strong , readonly) NSDate *(^day)();

@property (nonatomic , copy , readonly) NSString * toWeek;

@property (nonatomic , copy , readonly) NSString * toString;
@property (nonatomic , assign , readonly) NSUInteger toInt;

@end
