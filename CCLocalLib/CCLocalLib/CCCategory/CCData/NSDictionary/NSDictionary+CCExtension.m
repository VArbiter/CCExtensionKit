//
//  NSDictionary+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/20.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "NSDictionary+CCExtension.h"
#import "NSObject+CCExtension.h"
#import "CCCommonDefine.h"

@implementation NSDictionary (CCExtension)

+ (NSDictionary *)ccDictionaryWith : (NSString *) stringJson ; {
    if (!stringJson.isStringValued) {
        return nil;
    }
    
    NSData *dataJson = [stringJson dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *dicionary = [NSJSONSerialization JSONObjectWithData:dataJson
                                                              options:NSJSONReadingMutableContainers | NSJSONReadingAllowFragments
                                                                error:&error];
    if(error) {
        CCLog(@"\n_CC_JSON_FAIL_ \n%@",error);
        return nil;
    }
    return dicionary;
}



@end
