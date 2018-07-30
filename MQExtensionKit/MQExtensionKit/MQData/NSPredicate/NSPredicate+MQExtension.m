//
//  NSPredicate+MQExtension.m
//  MQExtensionKit
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "NSPredicate+MQExtension.h"

@implementation NSPredicate (CCExtension)

+ (instancetype) mq_common : (NSString *) sRegex {
    if ([sRegex isKindOfClass:NSString.class] && sRegex && sRegex.length) {
        return [NSPredicate predicateWithFormat:sRegex];
    }
    return [NSPredicate predicateWithFormat:@""];
}

+ (instancetype) mq_time {
    return [NSPredicate mq_common:@"^(?:(?!0000)[0-9]{4}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-8])|(?:0[13-9]|1[0-2])-(?:29|30)|(?:0[13578]|1[02])-31)|(?:[0-9]{2}(?:0[48]|[2468][048]|[13579][26])|(?:0[48]|[2468][048]|[13579][26])00)-02-29)\\s+([01][0-9]|2[0-3]):[0-5][0-9]$"];
}
+ (instancetype) mq_mac_address {
    return [NSPredicate mq_common:@"([A-Fa-f\\d]{2}:){5}[A-Fa-f\\d]{2}"];
}
+ (instancetype) mq_web_URL {
    return [NSPredicate mq_common:@"^((http)|(https))+:[^\\s]+\\.[^\\s]*$"];
}

+ (instancetype) mq_cell_phone {
    return [NSPredicate mq_common:@"^1((3//d|5[0-35-9]|8[025-9])//d|70[059])\\d{7}$"];
}
+ (instancetype) mq_china_mobile {
    return [NSPredicate mq_common:@"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d|705)\\d{7}$"];
}
+ (instancetype) mq_china_unicom {
    return [NSPredicate mq_common:@"^1((3[0-2]|5[256]|8[56])\\d|709)\\d{7}$"];
}
+ (instancetype) mq_china_telecom {
    return [NSPredicate mq_common:@"^1((33|53|8[09])\\d|349|700)\\d{7}$"];
}

+ (instancetype) mq_email {
    return [NSPredicate mq_common:@"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"];
}
+ (instancetype) mq_telephone {
    return [NSPredicate mq_common:@"^0(10|2[0-5789]|\\d{3})\\d{7,8}$"];
}

+ (instancetype) mq_chinese_identity_number {
    return [NSPredicate mq_common:@"^(\\d{14}|\\d{17})(\\d|[xX])$"];
}
+ (instancetype) mq_chinese_car_number {
    // \u4e00-\u9fa5 indicates that's a encoded unicode , \u9fa5-\u9fff reserve for future addition .
    // \u4e00-\u9fa5 判断是否是 unicode 编码 , \u9fa5-\u9fff 为未来添加所保留
    return [NSPredicate mq_common:@"^[\u4e00-\u9fff]{1}[a-zA-Z]{1}[-][a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fff]$"];
}
+ (instancetype) mq_chinese_character {
    return [NSPredicate mq_common:@"^[\u4e00-\u9fa5]+$"];
}
+ (instancetype) mq_chinese_postal_code {
    return [NSPredicate mq_common:@"^[0-8]\\d{5}(?!\\d)$"];
}
+ (instancetype) mq_chinese_tax_number {
    return [NSPredicate mq_common:@"[0-9]\\d{13}([0-9]|X)$"];
}

- (id) mq_evalute : (id) object {
    if ([self evaluateWithObject:object]) {
        return object;
    }
    return nil;
}

@end

#pragma mark - -----

@implementation NSString (CCExtension_Regex)

- (BOOL) is_time {
    return [NSPredicate.mq_time mq_evalute:self] ? YES : false;
}
- (BOOL) is_mac_address {
    return [NSPredicate.mq_mac_address mq_evalute:self] ? YES : false;
}
- (BOOL) is_web_URL {
    return [NSPredicate.mq_web_URL mq_evalute:self] ? YES : false;
}

// only in china
+ (BOOL) mq_accurate_verify_ID : (NSString *) sID {
    NSString *value = [sID stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    int length =0;
    if (!value || !value.length) return NO;
    else {
        length = (int)value.length;
        if (length !=15 && length !=18) return NO;
    }
    // for province // 省份
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag =NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    if (!areaFlag) return false;
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    int year =0;
    switch (length) {
        case 15:{
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            if (year % 4 ==0 || (year % 100 == 0 && year % 4 ==0)) {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil]; // if birthDay legal // 生日是否有效
            } else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil]; // if birthDay legal // 生日是否有效
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            if(numberofMatch >0) return YES;
            else return NO;
        }break;
            
        case 18:{
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year % 4 ==0 || (year % 100 == 0 && year % 4 ==0)) {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil]; // if birthDay legal // 生日是否有效
            } else {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil]; // if birthDay legal
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            if(numberofMatch >0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue
                         + [value substringWithRange:NSMakeRange(10,1)].intValue) * 7
                + ([value substringWithRange:NSMakeRange(1,1)].intValue
                   + [value substringWithRange:NSMakeRange(11,1)].intValue) * 9
                + ([value substringWithRange:NSMakeRange(2,1)].intValue
                   + [value substringWithRange:NSMakeRange(12,1)].intValue) * 10
                + ([value substringWithRange:NSMakeRange(3,1)].intValue
                   + [value substringWithRange:NSMakeRange(13,1)].intValue) * 5
                + ([value substringWithRange:NSMakeRange(4,1)].intValue
                   + [value substringWithRange:NSMakeRange(14,1)].intValue) * 8
                + ([value substringWithRange:NSMakeRange(5,1)].intValue
                   + [value substringWithRange:NSMakeRange(15,1)].intValue) * 4
                + ([value substringWithRange:NSMakeRange(6,1)].intValue
                   + [value substringWithRange:NSMakeRange(16,1)].intValue) * 2
                + [value substringWithRange:NSMakeRange(7,1)].intValue * 1
                + [value substringWithRange:NSMakeRange(8,1)].intValue * 6
                + [value substringWithRange:NSMakeRange(9,1)].intValue * 3;
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)]; // if checking numebr valued
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) return YES; // if id number valued
                else return NO;
            } else return NO;
        }break;
        default:
            return NO;
    }

}

- (BOOL) is_accurate_identity {
    return [NSString mq_accurate_verify_ID:self] ? YES : false;
}
- (BOOL) is_cell_phone {
    return [NSPredicate.mq_cell_phone mq_evalute:self] ? YES : false;
}
- (BOOL) is_china_mobile {
    return [NSPredicate.mq_china_mobile mq_evalute:self] ? YES : false;
}
- (BOOL) is_china_unicom {
    return [NSPredicate.mq_china_unicom mq_evalute:self] ? YES : false;
}
- (BOOL) is_china_telecom {
    return [NSPredicate.mq_china_telecom mq_evalute:self] ? YES : false;
}
- (BOOL) is_telephone {
    return [NSPredicate.mq_telephone mq_evalute:self] ? YES : false;
}
- (BOOL) is_email {
    return [NSPredicate.mq_email mq_evalute:self] ? YES : false;
}
- (BOOL) is_chinese_identity_number {
    return [NSPredicate.mq_chinese_identity_number mq_evalute:self] ? YES : false;
}
- (BOOL) is_chinese_car_number {
    return [NSPredicate.mq_chinese_car_number mq_evalute:self] ? YES : false;
}
- (BOOL) is_chinese_character {
    return [NSPredicate.mq_chinese_character mq_evalute:self] ? YES : false;
}
- (BOOL) is_chinese_postal_code {
    return [NSPredicate.mq_chinese_postal_code mq_evalute:self] ? YES : false;
}
- (BOOL) is_chinese_tax_number {
    return [NSPredicate.mq_chinese_tax_number mq_evalute:self] ? YES : false;
}

@end
