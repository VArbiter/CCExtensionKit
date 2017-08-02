//
//  NSString+CCChain.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 01/07/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIColor;

@interface NSString (CCChain)

@property (nonatomic , copy , readonly) NSString *(^s)(id value) ;
@property (nonatomic , copy , readonly) NSString *(^p)(id value) ;
@property (nonatomic , copy , readonly) NSString *(^timeSince1970)(NSTimeInterval interval); // yyyy-MM-dd HH:mm

/// break has the topest priority .
@property (nonatomic , copy , readonly) NSString *(^merge)(BOOL isBreak , BOOL isSpace , NSArray <NSString *> * array) ;
@property (nonatomic , copy , readonly) NSString *(^mergeR)(BOOL isBreak , BOOL isSpace , NSString * string , ...);

@property (nonatomic , copy , readonly) NSMutableAttributedString *(^colorAttribute)(UIColor *color);

@property (nonatomic , assign , readonly) NSInteger toInteger ;
@property (nonatomic , assign , readonly) long long toLonglong ;
@property (nonatomic , assign , readonly) int toInt;
@property (nonatomic , assign , readonly) BOOL toBool ;
@property (nonatomic , assign , readonly) float toFloat ;
@property (nonatomic , assign , readonly) double toDouble ;

@property (nonatomic , strong , readonly) NSDecimalNumber * toDecimal; // only numbers .
@property (nonatomic , strong , readonly) NSMutableAttributedString * toAttribute;
@property (nonatomic , strong , readonly) NSDate * toDate; // yyyy-MM-dd HH:mm

@property (nonatomic , copy , readonly) NSString *(^timeStick)(BOOL isNeedSpace) ;
@property (nonatomic , copy , readonly) NSString *timeStickP ; // yyyy-MM-dd HH:mm
@property (nonatomic , copy , readonly) NSString *md5 ;

@end
