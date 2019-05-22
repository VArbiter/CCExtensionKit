//
//  CLGeocoder+MQExtension.m
//  MQExtension_Example
//
//  Created by ElwinFrederick on 2019/5/22.
//  Copyright © 2019 ElwinFrederick. All rights reserved.
//

#import "CLGeocoder+MQExtension.h"

@implementation CLGeocoder (MQExtension)

- (void) mq_is_location_in_China : (CLLocation *) location
               original_response : (void(^)(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error)) response
                        complete : (void (^)(BOOL is_in_China , NSError * _Nullable error)) complete {
    [self mq_detect_location:location
               is_in_country:@"CN"
           original_response:response
                    complete:complete];
}

- (void) mq_detect_location : (CLLocation *) location
              is_in_country : (NSString *) country_code
          original_response : (void(^)(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error)) response
                   complete : (void (^)(BOOL is_in , NSError * _Nullable error)) complete {
    
    [self reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (response) response(placemarks , error);
        
        if (error || !placemarks.count) {
            if (complete) complete(false , error);
        }
        else {
            CLPlacemark * placemark = placemarks.firstObject;
            if ([placemark.ISOcountryCode isEqualToString:country_code]) {
                if (complete) complete(YES , error);
            }
            else if (complete) complete(false , error);
        }
    }];
}

@end
