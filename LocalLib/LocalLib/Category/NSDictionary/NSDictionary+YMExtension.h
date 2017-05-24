//
//  NSDictionary+YMExtension.h
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/4/20.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (YMExtension)

- (BOOL) ymIsDictionaryValued ;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString ;

@end
