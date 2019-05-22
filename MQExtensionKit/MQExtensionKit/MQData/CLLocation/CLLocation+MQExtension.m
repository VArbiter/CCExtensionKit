//
//  CLLocation+MQExtension.m
//  MQExtension_Example
//
//  Created by ElwinFrederick on 2019/5/22.
//  Copyright © 2019 ElwinFrederick. All rights reserved.
//

#import "CLLocation+MQExtension.h"

@implementation CLLocation (MQExtension)

+ (CLAuthorizationStatus) mq_is_location_authorizated : (void (^)(BOOL is_need_guide_to_app_settings)) complete {
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (!(status == kCLAuthorizationStatusAuthorizedAlways
          || status == kCLAuthorizationStatusAuthorizedWhenInUse)) {
        if (complete) complete(false);
    }
    else if (complete) complete(YES);
    
    return status;
}

+ (CLLocationDegrees) mq_calculate_distance_between : (CLLocation *) location_1
                                       and_location : (CLLocation *) location_2 {
    return [location_1 distanceFromLocation:location_2];
}

+ (CLLocationDegrees) mq_calculate_distance_between : (CLLocationDegrees) coordinate_1_lat
                                coordinate_1_longit : (CLLocationDegrees) coordinate_1_longit
                               and_coordinate_2_lat : (CLLocationDegrees) coordinate_2_lat
                                coordinate_2_longit : (CLLocationDegrees) coordinate_2_longit {
    CLLocation *location_1 = [[CLLocation alloc] initWithLatitude:coordinate_1_lat
                                                        longitude:coordinate_1_longit];
    CLLocation *location_2 = [[CLLocation alloc] initWithLatitude:coordinate_2_lat
                                                        longitude:coordinate_2_longit];
    
    return [location_1 distanceFromLocation:location_2];
}

@end
