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

@property (nonatomic , readonly , copy) NSString *(^appendPath)(NSString *string);
@property (nonatomic , readonly , copy) NSString *(^append)(NSString *string);

- (instancetype) ccAppendPath : (NSString *) string ;

- (NSDecimalNumber *) ccDecimalValue ; // 仅限数字

- (instancetype) ccTimeStick ; // yyyy-MM-dd HH:mm

- (instancetype) ccTimeStickWeekDays ; // yyyy-MM-dd HH:mm

- (instancetype) ccTimeSince1970 : (NSTimeInterval) interval ;

- (NSDate *) ccDate ;

- (NSUInteger) ccDays ;

+ (instancetype) ccMergeNeedLineBreak : (BOOL) isNeedBreak // 回车优先级最高 , 高于空格
                          needSpacing : (BOOL) isNeedSpacing
                                 with : (NSString *) string , ... NS_REQUIRES_NIL_TERMINATION;

+ (instancetype) ccMerge : (NSArray <NSString *> *) arrayStrings
           needLineBreak : (BOOL) isNeedBreak // 回车优先级最高 , 高于空格
             needSpacing : (BOOL) isNeedSpacing ;

- (instancetype) ccMD5String ;

- (NSMutableAttributedString *) ccMAttributeString ;

- (NSMutableAttributedString *) ccColor : (UIColor *) color ;

@end
