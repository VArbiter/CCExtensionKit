//
//  NSDictionary+YMExtension.m
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/4/20.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "NSDictionary+YMExtension.h"

@implementation NSDictionary (YMExtension)

- (BOOL) ymIsDictionaryValued {
    if ([self isKindOfClass:[NSDictionary class]]) {
        if (self && self.allKeys.count && self.allValues.count) {
            return YES;
        }
    }
    return false;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}



@end
