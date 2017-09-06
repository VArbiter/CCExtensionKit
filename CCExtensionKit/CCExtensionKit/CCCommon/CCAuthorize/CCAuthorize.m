//
//  CCAuthorize.m
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "CCAuthorize.h"

#import <AVFoundation/AVFoundation.h>

#ifdef __IPHONE_9_0
    #import <Photos/Photos.h>
#else
    #import <AssetsLibrary/AssetsLibrary.h>
#endif

@interface CCAuthorize () < NSCopying , NSMutableCopying >

@property (nonatomic , strong) NSDictionary *dictionaryGuide ;
- (void) ccGuideTo ;

@end

static CCAuthorize *_instance = nil;

@implementation CCAuthorize

+ (CCAuthorize *)shared {
    if (_instance) return _instance;
    _instance = [[CCAuthorize alloc] init];
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

- (instancetype) ccHasAuthorize : (CCSupportType) type
                        success : (void (^)()) success
                           fail : (BOOL (^)()) fail  {
    BOOL (^g)() = self.dictionaryGuide[@(type).stringValue];
    if (g) {
        if (g()) {
            if (success) success();
        } else if (fail) {
            if (fail()) [CCAuthorize.shared ccGuideTo];
        }
    }
    return self;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

- (void)ccGuideTo {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        if (UIDevice.currentDevice.systemVersion.floatValue >= 10.f) {
            [[UIApplication sharedApplication] openURL:url];
        } else {
            [[UIApplication sharedApplication] openURL:url
                                               options:NSDictionary.alloc.init
                                     completionHandler:nil];
        }
    }
}

- (NSDictionary *)dictionaryGuide {
    if (_dictionaryGuide) return _dictionaryGuide;
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    
    [d setValue:^BOOL {
#ifdef __IPHONE_9_0
        PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
        return !(author == PHAuthorizationStatusRestricted || author == PHAuthorizationStatusDenied);
#else
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        return !(author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied) ;
#endif
    } forKey:@(CCSupportTypePhotoLibrary).stringValue];
    
    [d setValue:^BOOL {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        return !(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied);
    } forKey:@(CCSupportTypeVideo).stringValue];
    
    [d setValue:^BOOL {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
        return !(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied);
    } forKey:@(CCSupportTypeAudio).stringValue];
    
    _dictionaryGuide = d;
    return _dictionaryGuide;
}

#pragma clang diagnostic pop

@end
