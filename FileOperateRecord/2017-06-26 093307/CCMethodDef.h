//
//  CCMethodDef.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/3/29.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#ifndef CCMethodDef_h
    #define CCMethodDef_h

//#pragma mark - Methods

    #define _CC_MAIN_LOOP_TIMER_ 3.5f
    #define _CC_MAIN_LOOP_MAX_SECTIONS_ 1000
    #define _CC_ALERT_DISMISS_INTERVAL_ 1.f
    #define _CC_MON_DEFAULT_BUTTON_COUNTS_ 4

    #define _CC_DEFAULT_FONT_SIZE_ 11.0f
    #define _CC_DEFAULT_FONT_TITLE_SIZE_ 13.0f
    #define _CC_SYSTEM_FONT_SIZE_ 17.0f

    #define _CC_DEFAULT_SEARCH_ITEM_COUNT_ 20

    #define _CC_GAUSSIAN_BLUR_VALUE_ .1f
    #define _CC_REQUEST_MAXIMUN_COUNT_ 5

    #define _CC_ANIMATION_COMMON_DURATION_ .3f
    #define _CC_ANIMATION_FAST_DURATION_ .05f
    #define _CC_PROGRESS_TIMER_INTERVAL_ .05f

    #define _CC_DECIMAL_POINT_POSITION_ 2

    #define _CC_TIMER_COUNT_DOWN_INTERVAL_ 1.f
    #define _CC_TIMER_COUNT_DOWN_MINUTE_ 60.f

    #define _CC_NETWORK_OVER_TIME_INTERVAL_ 30.f

    //#pragma mark - Appearance

    #define _CC_NAVIGATION_HEIGHT_ 44.0f
    #define _CC_NAVIGATION_Y_ 64.0f
    #define _CC_TABBAR_HEIGHT_ 49.f

    #define _CC_MAIN_COLOR_HEX_ 0xDC1729
    #define _CC_MAIN_COLOR_ ccHexColor(_CC_MAIN_COLOR_HEX_, 1.0f);

    /// JPEG 压缩比
    #define _CC_IMAGE_JPEG_COMPRESSION_QUALITY_ 1.f
    /// 大小限制 KB
    #define _CC_IMAGE_JPEG_COMPRESSION_QUALITY_SIZE_ 400.f
    /// 精度
    #define _CC_IMAGE_JPEG_COMPRESSION_QUALITY_SCALE_ .1f

    /// iPhone 7 Basic 1334.f * 750.f
    #define CC_DYNAMIC_WIDTH(VALUE) (((CGFloat)(VALUE)) / 750.f * [UIScreen mainScreen].bounds.size.width)
    #define CC_DYNAMIC_HEIGHT(VALUE) (((CGFloat)(VALUE)) / 1334.f * [UIScreen mainScreen].bounds.size.height)
    #define CC_DYNAMIC_NAVIGATION_BAR_ITEM_HEIGHT(VALUE) (((CGFloat)(VALUE)) / 90.f * _CC_NAVIGATION_HEIGHT_)

    #define CC_DYNAMIC_WIDTH_SCALE(VALUE) (((CGFloat)(VALUE)) / 750.f)
    #define CC_DYNAMIC_HEIGHT_SCALE(VALUE) (((CGFloat)(VALUE)) / 1334.f)


//#pragma mark - Main

    #define _CC_MAIN_COLLECTION_Y_ (SCREEN_HEIGHT * 0.044977f)

    #define _CC_IS_5_5S_SE_ ([UIScreen instancesRespondToSelector: @selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
    #define _CC_IS_6_6S_7_  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750,1334), [[UIScreen mainScreen] currentMode].size) : NO)

    static inline float _CC_MAIN_DROP_MENU_WIDTH_SCALE_() {
        if (_CC_IS_6_6S_7_) {
            return 0.548666f;
        }
        return _CC_IS_5_5S_SE_ ? 0.628666f : 0.490666f;
    }
    static inline float _CC_MAIN_SEARCH_FIELD_WIDTH_SCALE_() {
        if (_CC_IS_6_6S_7_) {
            return 0.33f;
        }
        return _CC_IS_5_5S_SE_ ? 0.25f : 0.388f;
    }

//#pragma mark - Item Detail
    static inline CGFloat _CC_ITEM_DETAIL_VC_EXTERN_HEIGHT_SCALE_() {
        if (_CC_IS_6_6S_7_) {
            return 0.0187406f;
        }
        return _CC_IS_5_5S_SE_ ? 0.038732f : 0.0145833f;
    }

    #define _CC_ITEM_DETAIL_LABEL_DEFAULT_HEIGHT_ 20.0f

#endif
