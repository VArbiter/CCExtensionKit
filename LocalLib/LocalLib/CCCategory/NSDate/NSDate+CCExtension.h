//
//  NSDate+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/11.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (CCExtension)

- (NSInteger) ccFirstWeekdayInThisMonth ;

- (NSInteger) ccDay ;

- (NSInteger) ccGetDateWeekday ;

- (NSString *) ccWeekDays ; // 返回当前是周几

@end
