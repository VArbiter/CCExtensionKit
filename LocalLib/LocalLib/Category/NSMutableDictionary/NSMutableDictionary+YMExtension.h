//
//  NSMutableDictionary+YMExtension.h
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/4/17.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (YMExtension)

- (void) ymSetValue:(id)value forKey:(NSString *)key;
@property (nonatomic , copy) void(^blockChangeAll)(id key , id value , NSArray * arrayAllKeys , NSArray * arrayAllValues);
@property (nonatomic , copy) void(^blockChange)(id key , id value);

@end
