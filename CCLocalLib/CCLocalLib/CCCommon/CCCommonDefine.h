//
//  CCCommonDefine.h
//  Pods
//
//  Created by 冯明庆 on 26/06/2017.
//
//

#import <UIKit/UIKit.h>

#ifndef CCCommonDefine_h
    #define CCCommonDefine_h

    typedef NS_ENUM(NSInteger , CCEndLoadType) {
        CCEndLoadTypeEnd = 0,
        CCEndLoadTypeNoMoreData ,
        CCEndLoadTypeEndRefresh ,
        CCEndLoadTypeManualEnd
    };

    #if DEBUG
        #define _CC_DEBUG_MODE_ 1
    #else
        #define _CC_DEBUG_MODE_ 0
    #endif

    #if TARGET_IPHONE_SIMULATOR
        #define _CC_IS_SIMULATOR_ 1
    #else
        #define _CC_IS_SIMULATOR_ 0
    #endif

    #if 1
        #if _CC_DEBUG_MODE_
            #define CCLog(fmt , ...) NSLog((@"\n\n_CC_LOG_\n\n_CC_FILE_  %s\n_CC_METHOND_  %s\n_CC_LINE_  %d\n" fmt),__FILE__,__func__,__LINE__,##__VA_ARGS__)
        #else
            #define CCLog(fmt , ...) /* */
        #endif
    #else
        #define CCLog(fmt , ...) /* */
    #endif

    #if _CC_DEBUG_MODE_
        #define _CC_DETECT_DEALLOC_ \
            - (void)dealloc { \
                CCLog(@"_CC_%@_DEALLOC_", NSStringFromClass([self class]));\
            } 
    #else
        #define _CC_DETECT_DEALLOC_ /* */
    #endif

    // self 弱引用
    #define ccWeakSelf __weak typeof(&*self) pSelf = self

    // 字符串格式化
    #define ccStringFormat(...) [NSString stringWithFormat:__VA_ARGS__]
    // 字符串融合 , 干掉 nil , 不能使用集合类 .
    #define ccMergeObject(...) ccObjMerge(__VA_ARGS__ , nil)
    // 字符串转化
    #define ccStringTransfer(...) ccStringFormat(@"%@",ccMergeObject(__VA_ARGS__))
    // 便捷 LOG
    #define CC_Log(...) CCLog(@"%@",ccStringTransfer(__VA_ARGS__))
    /// 判断非空
    #define CC_IS_NULL(VALUE) (!VALUE || [VALUE isKindOfClass:[NSNull class]])
    /// UUID
    #define _CC_UUID_ [UIDevice currentDevice].identifierForVendor.UUIDString

    /// iPhone 7 Basic 1334.f * 750.f
    #define CC_DYNAMIC_WIDTH(VALUE) (((CGFloat)(VALUE)) / 750.f * [UIScreen mainScreen].bounds.size.width)
    #define CC_DYNAMIC_HEIGHT(VALUE) (((CGFloat)(VALUE)) / 1334.f * [UIScreen mainScreen].bounds.size.height)
    #define CC_DYNAMIC_NAVIGATION_BAR_ITEM_HEIGHT(VALUE) (((CGFloat)(VALUE)) / 90.f * _CC_NAVIGATION_HEIGHT_)

    #define CC_DYNAMIC_WIDTH_SCALE(VALUE) (((CGFloat)(VALUE)) / 750.f)
    #define CC_DYNAMIC_HEIGHT_SCALE(VALUE) (((CGFloat)(VALUE)) / 1334.f)

//#pragma mark - Appearance

    #define _CC_NAVIGATION_HEIGHT_ 44.0f
    #define _CC_NAVIGATION_Y_ 64.0f
    #define _CC_TABBAR_HEIGHT_ 49.f

    /// JPEG 压缩比
    #define _CC_IMAGE_JPEG_COMPRESSION_QUALITY_ 1.f
    /// 大小限制 KB
    #define _CC_IMAGE_JPEG_COMPRESSION_QUALITY_SIZE_ 400.f
    /// 精度
    #define _CC_IMAGE_JPEG_COMPRESSION_QUALITY_SCALE_ .1f

    #define _CC_DEFAULT_FONT_SIZE_ 11.0f
    #define _CC_DEFAULT_FONT_TITLE_SIZE_ 13.0f
    #define _CC_SYSTEM_FONT_SIZE_ 17.0f

    #define _CC_GAUSSIAN_BLUR_VALUE_ .1f
    #define _CC_GAUSSIAN_BLUR_TINT_ALPHA_ .25f

    #define _CC_REQUEST_MAXIMUN_COUNT_ 5

    #define _CC_ANIMATION_COMMON_DURATION_ .3f
    #define _CC_ANIMATION_FAST_DURATION_ .05f
    #define _CC_PROGRESS_TIMER_INTERVAL_ .05f
    #define _CC_ALERT_DISSMISS_COMMON_DURATION_ 2.0

    #define _CC_DECIMAL_POINT_POSITION_ 2

    #define _CC_TIMER_COUNT_DOWN_INTERVAL_ 1.f
    #define _CC_TIMER_COUNT_DOWN_MINUTE_ 60.f

    #define _CC_NETWORK_OVER_TIME_INTERVAL_ 30.f

    #define _CC_IS_5_5S_SE_ ([UIScreen instancesRespondToSelector: @selector(currentMode)] ? \
        CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
    #define _CC_IS_6_6S_7_  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
        CGSizeEqualToSize(CGSizeMake(750,1334), [[UIScreen mainScreen] currentMode].size) : NO)


#endif /* CCCommonDefine_h */
