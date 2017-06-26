//
//  NSObject+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/20.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (CCExtension)

@property (nonatomic , class , assign , readonly) NSString * stringClass ;

- (NSString *) ccStringValue ;

- (BOOL) ccIsStringValued ;
- (BOOL) ccIsArrayValued ;
- (BOOL) ccIsDecimalValued ;
- (BOOL) ccIsDictionaryValued ;
- (BOOL) ccIsNull ;

@property (nonatomic , readonly) NSString * stringValue ;

@property (nonatomic , readonly) BOOL isStringValued ;
@property (nonatomic , readonly) BOOL isArrayValued ;
@property (nonatomic , readonly) BOOL isDictionaryValued ;
@property (nonatomic , readonly) BOOL isDecimalValued ;
@property (nonatomic , readonly) BOOL isNull ;

@property (nonatomic , assign , readonly) Class clazz ;
@property (nonatomic , readonly) NSString *stringClazz ;

@end
