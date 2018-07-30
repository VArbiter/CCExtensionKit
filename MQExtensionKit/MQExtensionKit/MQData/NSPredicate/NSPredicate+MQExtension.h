//
//  NSPredicate+MQExtension.h
//  MQExtensionKit
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSPredicate (CCExtension)

+ (instancetype) mq_common : (NSString *) sRegex ;

/// YYYY-MM-DD HH:mm:ss
+ (instancetype) mq_time ;
+ (instancetype) mq_mac_address ;
+ (instancetype) mq_web_URL ;

// only in china // 仅在中国有效

+ (instancetype) mq_cell_phone ;
+ (instancetype) mq_china_mobile ;
+ (instancetype) mq_china_unicom ;
+ (instancetype) mq_china_telecom ;

+ (instancetype) mq_email ;
+ (instancetype) mq_telephone ;

+ (instancetype) mq_chinese_identity_number ;
/// eg: 湘K-DE829 , 粤Z-J499港
+ (instancetype) mq_chinese_car_number ;
+ (instancetype) mq_chinese_character ;
+ (instancetype) mq_chinese_postal_code ;
+ (instancetype) mq_chinese_tax_number ;

- (id) mq_evalute : (id) object ;

@end

@interface NSString (CCExtension_Regex)

/// YYYY-MM-DD HH:mm:ss
- (BOOL) is_time ;
- (BOOL) is_mac_address ;
- (BOOL) is_web_URL ;

// only in china // 仅在中国有效
+ (BOOL) mq_accurate_verify_ID : (NSString *) sID;

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
