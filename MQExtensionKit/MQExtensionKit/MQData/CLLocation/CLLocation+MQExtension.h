//
//  CLLocation+MQExtension.h
//  MQExtension_Example
//
//  Created by ElwinFrederick on 2019/5/22.
//  Copyright © 2019 ElwinFrederick. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLLocation (MQExtension)

/**
 detect if LBS authorized . // 检测地理定位服务是否被用户授权

 @param complete decide if need go to the app settings page in "Settings" . // 决定是否需要跳转到 app 设置页面 .
 @return authorized status . // 当前地理定位服务的授权状态
 */
+ (CLAuthorizationStatus) mq_is_location_authorizated : (void (^)(BOOL is_need_guide_to_app_settings)) complete ;

/**
 calculate the distance between two locations . // 计算两个地点之间的距离

 @param location_1 location 1 // 坐标点 1
 @param location_2 location 2 // 坐标点 2
 @return lateral distance between two locations . // 两个地点之间的距离 (直线)
 */
+ (CLLocationDegrees) mq_calculate_distance_between : (CLLocation *) location_1
                                       and_location : (CLLocation *) location_2 ;

/**
 calculate the distance between two locations . // 计算两个地点之间的距离

 @param coordinate_1_lat latitude in location 1 . // 坐标 1 的纬度
 @param coordinate_1_longit longitude in location . // 坐标 1 的经度
 @param coordinate_2_lat latitude in location 2 . // 坐标 2 的纬度
 @param coordinate_2_longit longitude in location 2 . // 坐标 2 的经度
 @return lateral distance between two locations . // 两个地点之间的距离 (直线)
 */
+ (CLLocationDegrees) mq_calculate_distance_between : (CLLocationDegrees) coordinate_1_lat
                                coordinate_1_longit : (CLLocationDegrees) coordinate_1_longit
                               and_coordinate_2_lat : (CLLocationDegrees) coordinate_2_lat
                                coordinate_2_longit : (CLLocationDegrees) coordinate_2_longit ;

@end

NS_ASSUME_NONNULL_END
