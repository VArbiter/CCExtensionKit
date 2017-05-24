//
//  YMCommonTools.m
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/3/29.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "YMCommonTools.h"
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "YMCommonDefine.h"

@interface YMCommonTools ()

@property (nonatomic , strong) dispatch_source_t timer ;
- (void) ymTimerCancelAction : (dispatch_group_t) sender ;

@property (nonatomic , copy) BOOL(^blockTimerAction)() ;
@property (nonatomic , copy) dispatch_block_t blockCancel;

@end

@implementation YMCommonTools

#pragma mark - Public

+ (BOOL) ymHasAccessToAlbum {
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    return !(author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied) ;
}

+ (void) ymGuideToCameraSettings {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

+ (BOOL) ymHasAccessToCamera {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    return !(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) ;
}

+ (instancetype) ymTimerWithInterval : (NSTimeInterval) interval
                     withTimerAction : (BOOL (^)()) blockTimerAction
                    withCancelAction : (dispatch_block_t) blockCancel {
    YMCommonTools *tools = [[YMCommonTools alloc] init];
    tools.blockTimerAction = [blockTimerAction copy];
    tools.blockCancel = [blockCancel copy];
    __block dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    tools.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(tools.timer, dispatch_walltime(NULL, 0), interval * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(tools.timer, ^{
        [tools ymTimerCancelAction:group];
    });
    dispatch_resume(tools.timer);
    return tools;
}

- (void) ymCancelTimer {
    if (self.timer) {
#warning TODO >>> ??? // MIGHT HAVE VERIFY BUTTON STATUS SHOWN ERROR
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
}

#pragma mark - Private
- (void) ymTimerCancelAction : (dispatch_group_t) sender {
    ymWeakSelf;
    dispatch_source_set_cancel_handler(self.timer, ^{
        dispatch_group_leave(sender);
        _YM_Safe_UI_Block_(pSelf.blockCancel, ^{
            pSelf.blockCancel();
        });
    });
    
    _YM_Safe_UI_Block_(self.blockTimerAction, ^{
        if (pSelf.blockTimerAction()) {
            dispatch_source_cancel(pSelf.timer);
            pSelf.timer = nil;
        }
    });
}

_YM_DETECT_DEALLOC_

@end
