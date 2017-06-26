//
//  NSNumber+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/20.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (CCExtension)

@property (nonatomic , readonly) NSDecimalNumber * decimalValue ;

- (NSDecimalNumber *) ccDecimalValue ;

@end
