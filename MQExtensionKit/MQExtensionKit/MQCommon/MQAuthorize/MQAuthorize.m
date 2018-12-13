//
//  MQAuthorize.m
//  MQExtensionKit
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "MQAuthorize.h"

#import <AVFoundation/AVFoundation.h>

#ifdef __IPHONE_9_0
    #import <Photos/Photos.h>
#else
    #import <AssetsLibrary/AssetsLibrary.h>
#endif

@interface MQAuthorize () < NSCopying , NSMutableCopying >

@property (nonatomic , strong) NSDictionary *dictionary_guide ;
- (void) mq_guide_to ;

@end

static MQAuthorize *_instance = nil;

@implementation MQAuthorize

+ (MQAuthorize *)mq_shared {
    if (_instance) return _instance;
    _instance = [[MQAuthorize alloc] init];
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (_instance) return _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}

- (instancetype) mq_has_authorize : (MQSupportType) type
                          success : (void (^)(void)) success
                             fail : (BOOL (^)(void)) fail  {
    BOOL (^g)(void) = self.dictionary_guide[@(type).stringValue];
    if (g) {
        if (g()) {
            if (success) success();
        } else if (fail) {
            if (fail()) [MQAuthorize.mq_shared mq_guide_to];
        }
    }
    return self;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

- (void)mq_guide_to {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        if (UIDevice.currentDevice.systemVersion.floatValue >= 10.f) {
            [[UIApplication sharedApplication] openURL:url];
        } else {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:url
                                                   options:NSDictionary.alloc.init
                                         completionHandler:nil];
            } else {
                // Fallback on earlier versions
            }
        }
    }
}

- (NSDictionary *)dictionary_guide {
    if (_dictionary_guide) return _dictionary_guide;
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    
    [d setValue:^BOOL {
#ifdef __IPHONE_9_0
        PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
        return !(author == PHAuthorizationStatusRestricted || author == PHAuthorizationStatusDenied);
#else
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        return !(author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied) ;
#endif
    } forKey:@(MQSupportTypePhotoLibrary).stringValue];
    
    [d setValue:^BOOL {
        AVAuthorizationStatus auth_status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        return !(auth_status == AVAuthorizationStatusRestricted || auth_status == AVAuthorizationStatusDenied);
    } forKey:@(MQSupportTypeVideo).stringValue];
    
    [d setValue:^BOOL {
        AVAuthorizationStatus auth_status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
        return !(auth_status == AVAuthorizationStatusRestricted || auth_status == AVAuthorizationStatusDenied);
    } forKey:@(MQSupportTypeAudio).stringValue];
    
    _dictionary_guide = d;
    return _dictionary_guide;
}

#pragma clang diagnostic pop

@end
