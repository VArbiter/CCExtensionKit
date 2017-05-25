//
//  CCCommonTools.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/3/29.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "CCCommonTools.h"
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "CCCommonDefine.h"

@interface CCCommonTools ()

@property (nonatomic , strong) dispatch_source_t timer ;
- (void) ccTimerCancelAction : (dispatch_group_t) sender ;

@property (nonatomic , copy) BOOL(^blockTimerAction)() ;
@property (nonatomic , copy) dispatch_block_t blockCancel;

@end

@implementation CCCommonTools

#pragma mark - Public

+ (BOOL) ccHasAccessToAlbum {
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    return !(author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied) ;
}

+ (void) ccGuideToCameraSettings {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

+ (BOOL) ccHasAccessToCamera {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    return !(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) ;
}

+ (instancetype) ccTimerWithInterval : (NSTimeInterval) interval
                     withTimerAction : (BOOL (^)()) blockTimerAction
                    withCancelAction : (dispatch_block_t) blockCancel {
    CCCommonTools *tools = [[CCCommonTools alloc] init];
    tools.blockTimerAction = [blockTimerAction copy];
    tools.blockCancel = [blockCancel copy];
    __block dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    tools.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(tools.timer, dispatch_walltime(NULL, 0), interval * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(tools.timer, ^{
        [tools ccTimerCancelAction:group];
    });
    dispatch_resume(tools.timer);
    return tools;
}

- (void) ccCancelTimer {
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
}

#pragma mark - Private
- (void) ccTimerCancelAction : (dispatch_group_t) sender {
    ccWeakSelf;
    dispatch_source_set_cancel_handler(self.timer, ^{
        dispatch_group_leave(sender);
        _CC_Safe_UI_Block_(pSelf.blockCancel, ^{
            pSelf.blockCancel();
        });
    });
    
    _CC_Safe_UI_Block_(self.blockTimerAction, ^{
        if (pSelf.blockTimerAction()) {
            dispatch_source_cancel(pSelf.timer);
            pSelf.timer = nil;
        }
    });
}

_CC_DETECT_DEALLOC_

@end
