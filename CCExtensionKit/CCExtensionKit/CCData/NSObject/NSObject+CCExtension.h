//
//  NSObject+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/20.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (CCExtension)

@property (nonatomic , class , copy , readonly) NSString * sSelf;
@property (nonatomic , class , readonly) Class Self;

@property (nonatomic , copy , readonly) NSString * toString ;
@property (nonatomic , copy , readonly) NSString * getClass ;

@property (nonatomic , copy , readonly) NSString * isStringValued ;
@property (nonatomic , strong , readonly) NSArray * isArrayValued ;
@property (nonatomic , strong , readonly) NSDictionary * isDictionaryValued ;
@property (nonatomic , strong , readonly) NSDecimalNumber * isDecimalValued ;
@property (nonatomic , assign , readonly) BOOL isNull ;

@property (nonatomic , assign , readonly) BOOL isValuedString ;
@property (nonatomic , assign , readonly) BOOL isValuedArray ;
@property (nonatomic , assign , readonly) BOOL isValuedDictionary ;
@property (nonatomic , assign , readonly) BOOL isValuedDecimal ;

@end
