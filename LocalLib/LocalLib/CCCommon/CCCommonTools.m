//
//  CCCommonTools.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/3/29.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "CCCommonTools.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

#import "CCCommonDefine.h"
#import "NSString+CCExtension.h"

@interface CCCommonTools ()

@property (nonatomic , strong) dispatch_source_t timer ;
- (void) ccTimerCancelAction : (dispatch_group_t) sender ;

@property (nonatomic , copy) BOOL(^blockTimerAction)() ;
@property (nonatomic , copy) dispatch_block_t blockCancel;

@end

@implementation CCCommonTools

#pragma mark - Public

+ (BOOL) ccHasAccessToAlbum {
    if (CC_Available(9.0)) {
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        return !(author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied) ;
    } else {
        PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
        return !(author == PHAuthorizationStatusRestricted || author == PHAuthorizationStatusDenied) ;
    }
}

+ (void) ccGuideToCameraSettings {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        if (CC_Available(10.0)) {
            [[UIApplication sharedApplication] openURL:url];
        } else {
            [[UIApplication sharedApplication] openURL:url
                                               options:NSDictionary.alloc.init
                                     completionHandler:nil];
        }
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
        CC_Safe_UI_Operation(pSelf.blockCancel, ^{
            pSelf.blockCancel();
        });
    });
    
    CC_Safe_UI_Operation(self.blockTimerAction, ^{
        if (pSelf.blockTimerAction()) {
            dispatch_source_cancel(pSelf.timer);
            pSelf.timer = nil;
        }
    });
}

#pragma mark -- Functions

BOOL CC_Available(double version) {
    return UIDevice.currentDevice.systemVersion.floatValue >= version;
}

void CC_Safe_Operation(id blockNil , dispatch_block_t block) {
    if (!blockNil || !block) return;
    block();
}
void CC_Safe_UI_Operation(id blockNil , dispatch_block_t block) {
    if (!blockNil || !block) return;
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            block();
        });
    }
}
void CC_Main_Queue_Operation(dispatch_block_t block) {
    if (!block) return;
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            block();
        });
    }
}

void CC_Debug_Operation(dispatch_block_t block) {
    if (_CC_DEBUG_MODE_) {
        if (block) block();
    }
}


UIColor * ccHexColor(int intValue ,float floatAlpha){
    return [UIColor colorWithRed:( (CGFloat) ( (intValue & 0xFF0000) >> 16) ) / 255.0
                           green:( (CGFloat) ( (intValue & 0xFF00) >> 8) ) / 255.0
                            blue:( (CGFloat) (intValue & 0xFF) ) / 255.0
                           alpha:floatAlpha];
}

UIColor *ccRGBColor(float floatR , float floatG , float floatB){
    return ccRGBAColor(floatR, floatG, floatB, 1.0f);
}
UIColor *ccRGBAColor(float floatR , float floatG , float floatB , float floatA) {
    return [UIColor colorWithRed:floatR / 255.0f
                           green:floatG / 255.0f
                            blue:floatB / 255.0f
                           alpha:floatA];
}

NSURL * ccURL (NSString * stringURL , BOOL isLocalFile) {
    return isLocalFile ? [NSURL fileURLWithPath:stringURL] : [NSURL URLWithString:stringURL];
}

UIImage *ccImageCache(NSString *stringName){
    return ccImage(stringName, YES);
}

UIImage *ccImage(NSString *stringName , BOOL isCacheInMemory){
    return isCacheInMemory ? [UIImage imageNamed:stringName] : [UIImage imageWithContentsOfFile:stringName];
}

NSString * ccLocalize(NSString * stringLocalKey , ...){
    return ccBundleLocalize(stringLocalKey, NSBundle.mainBundle , "");
}

NSString * ccBundleLocalize(NSString * stringLocalKey , NSBundle * bundle , ... ){
    return NSLocalizedStringFromTableInBundle(stringLocalKey, @"LocalizableMain", bundle, nil);
}

NSString * ccObjMerge(id obj , ... ) {
    NSMutableArray *arrayStrings = [NSMutableArray array];
    NSString *stringTemp;
    va_list argumentList;
    if (obj) {
        if ([obj isKindOfClass:[NSString class]]) {
            [arrayStrings addObject:obj];
        } else [arrayStrings addObject:ccStringFormat(@"%@",obj)];
        va_start(argumentList, obj);
        while ((stringTemp = va_arg(argumentList, id))) {
            if ([stringTemp isKindOfClass:[NSString class]]) {
                [arrayStrings addObject:stringTemp];
            } else [arrayStrings addObject:ccStringFormat(@"%@",stringTemp)] ;
        }
        va_end(argumentList);
    }
    return [NSString ccMerge:arrayStrings
               needLineBreak:false
                 needSpacing:false];
}

_CC_DETECT_DEALLOC_

@end
