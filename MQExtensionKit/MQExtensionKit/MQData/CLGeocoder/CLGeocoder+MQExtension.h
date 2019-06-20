//
//  CLGeocoder+MQExtension.h
//  MQExtension_Example
//
//  Created by ElwinFrederick on 2019/5/22.
//  Copyright © 2019 ElwinFrederick. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLGeocoder (MQExtension)

/**
 detect a location if is in China . // 检测坐标是否位于中国

 @param location location // 坐标
 @param response original response that Geocoder returned . // Geocoder 的原始返回数据
 @param complete valued if no error occurs . // 如果没有错误 , 则生效
 */
- (void) mq_is_location_in_China : (CLLocation *) location
               original_response : (void(^)(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error)) response
                        complete : (void (^)(BOOL is_in_China , NSError * _Nullable error)) complete ;

/**
 detect a coordinate if is in a given country. // 检测给出的坐标是否处于给出的国家之内

 @param location location // 坐标
 @param country_code a code that used to identify a country , eg : @"CN" . // 用于辨识国家的代码
 @param response original response that Geocoder returned . // Geocoder 的原始返回数据
 @param complete valued if no error occurs . // 如果没有错误 , 则生效
 */
- (void) mq_detect_location : (CLLocation *) location
              is_in_country : (NSString *) country_code
          original_response : (void(^)(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error)) response
                   complete : (void (^)(BOOL is_in , NSError * _Nullable error)) complete ;

@end

NS_ASSUME_NONNULL_END
