//
//  NSDictionary+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/20.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "NSDictionary+CCExtension.h"
#import "CCCommonDefine.h"

@implementation NSDictionary (CCExtension)

+ (NSDictionary *)ccdictionaryWithJsonString : (NSString *) stringJson {
    if (stringJson.ccIsArrayValued) {
        return nil;
    }
    
    NSData *dataJson = [stringJson dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:dataJson
                                                        options:NSJSONReadingMutableContainers
                                                          error:&error];
    if(error) {
        CCLog(@"\n_CC_JSON_FAIL_ \n",error);
        return nil;
    }
    return dic;
}



@end
