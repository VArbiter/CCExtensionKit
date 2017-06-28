//
//  NSString+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/11.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (CCExtension)

@property (nonatomic , readonly) NSDecimalNumber *decimalValue ;

@property (nonatomic , readonly) NSString * timeStick ;
@property (nonatomic , readonly) NSString * timeStickWeekDays ;
@property (nonatomic , readonly) NSDate * date;
@property (nonatomic , readonly) NSUInteger days;

@property (nonatomic , readonly) NSString * md5Value ;

@property (nonatomic , readonly) NSMutableAttributedString *attributeValue ;

- (NSString *) ccAppendPath : (NSString *) string ;

- (NSDecimalNumber *) ccDecimalValue ; // 仅限数字

- (NSString *) ccTimeStick ; // yyyy-MM-dd HH:mm

- (NSString *) ccTimeStickWeekDays ; // yyyy-MM-dd HH:mm

- (NSString *) ccTimeSince1970 : (NSTimeInterval) interval ;

- (NSDate *) ccDate ;

- (NSUInteger) ccDays ;

+ (NSString *) ccMergeNeedLineBreak : (BOOL) isNeedBreak // 回车优先级最高 , 高于空格
                        needSpacing : (BOOL) isNeedSpacing
                               with : (NSString *) string , ... NS_REQUIRES_NIL_TERMINATION;

+ (NSString *) ccMerge : (NSArray <NSString *> *) arrayStrings
         needLineBreak : (BOOL) isNeedBreak // 回车优先级最高 , 高于空格
           needSpacing : (BOOL) isNeedSpacing ;

- (NSString *) ccMD5String ;

- (NSMutableAttributedString *) ccMAttributeString ;

- (NSMutableAttributedString *) ccColor : (UIColor *) color ;

@end
