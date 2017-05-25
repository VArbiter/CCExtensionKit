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

@end
