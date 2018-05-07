//
//  NSPredicate+CCExtension.h
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSPredicate (CCExtension)

+ (instancetype) cc_common : (NSString *) sRegex ;

/// YYYY-MM-DD HH:mm:ss
+ (instancetype) cc_time ;
+ (instancetype) cc_mac_address ;
+ (instancetype) cc_web_URL ;

// only in china // 仅在中国有效

+ (instancetype) cc_cell_phone ;
+ (instancetype) cc_china_mobile ;
+ (instancetype) cc_china_unicom ;
+ (instancetype) cc_china_telecom ;

+ (instancetype) cc_email ;
+ (instancetype) cc_telephone ;

+ (instancetype) cc_chinese_identity_number ;
/// eg: 湘K-DE829 , 粤Z-J499港
+ (instancetype) cc_chinese_car_number ;
+ (instancetype) cc_chinese_character ;
+ (instancetype) cc_chinese_postal_code ;
+ (instancetype) cc_chinese_tax_number ;

- (id) cc_evalute : (id) object ;

@end

@interface NSString (CCExtension_Regex)

/// YYYY-MM-DD HH:mm:ss
- (BOOL) is_time ;
- (BOOL) is_mac_address ;
- (BOOL) is_web_URL ;

// only in china // 仅在中国有效
+ (BOOL) cc_accurate_verify_ID : (NSString *) sID;

- (BOOL) is_accurate_identity ;
- (BOOL) is_cell_phone ;
- (BOOL) is_china_mobile ;
- (BOOL) is_china_unicom ;
- (BOOL) is_china_telecom ;
- (BOOL) is_telephone ;
- (BOOL) is_email ;
- (BOOL) is_chinese_identity_number ;
- (BOOL) is_chinese_car_number ;
- (BOOL) is_chinese_character ;
- (BOOL) is_chinese_postal_code ;
- (BOOL) is_chinese_tax_number ;

@end
