//
//  CCCommon.h
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

/// if is simulator .
#ifndef _CC_IS_SIMULATOR_
    #if TARGET_IPHONE_SIMULATOR
        #define _CC_IS_SIMULATOR_ 1
    #else
        #define _CC_IS_SIMULATOR_ 0
    #endif
#endif

/// formatStrings.
#ifndef ccStringFormat
    #define ccStringFormat(...) [NSString stringWithFormat:__VA_ARGS__]
#endif
#ifndef ccString
    #define ccString(_value_) [NSString stringWithFormat:@"%@",(_value_)]
#endif

/// manually control debug mode .
/// returns 1 if debug , 0 if release.
#ifndef _CC_DEBUG_MODE_
    #if DEBUG
        #define _CC_DEBUG_MODE_ 1
    #else
        #define _CC_DEBUG_MODE_ 0
    #endif
#endif

/// detect if an nil in chain has occur .
/// set to 1 to enable  , 0 for mute .
/// default is 1 (in DEBUG MODE) (enable) .
#ifndef _CC_NIL_ASSERT_ENABLE_
    #if _CC_DEBUG_MODE_
        #define _CC_NIL_ASSERT_ENABLE_ 1
    #else
        #define _CC_NIL_ASSERT_ENABLE_ 0
    #endif
#endif

/// console debug logging
#ifndef CCLog
    #if _CC_DEBUG_MODE_
        #define CCLog(fmt , ...) \
            NSLog((@"\n\n_CC_LOG_\n\n_CC_FILE_  %s\n_CC_METHOND_  %s\n_CC_LINE_  %d\n" fmt),__FILE__,__func__,__LINE__,##__VA_ARGS__)
    #else
        #define CCLog(fmt , ...) /* */
    #endif
#endif

/// returns another same value
#ifndef CC_SAME
    #define CC_SAME(_value_) typeof(_value_) sameT##_value_ = _value_
#endif

/// weak instance on arc
#ifndef CC_WEAK_INSTANCE
    #define CC_WEAK_INSTANCE(_value_) __unsafe_unretained typeof(_value_) weakT##_value_ = _value_
#endif

/// shortcut to weak self .
#ifndef CC_WEAK_SELF
    #define CC_WEAK_SELF __weak typeof(&*self) pSelf = self
#endif

/// transfer to a specific type by force.
#ifndef CC_TYPE
    #define CC_TYPE(_type_ , _value_) ((_type_)_value_)
#endif

/// prevent if an nil occur and caused blocks crash
/// note : if blocks was used by nil , app will went crash (EXC_BAD_ACCESS)
/// note : USE this macro CC_IN_METHOD(_value_) in methods impls
/// to ensure non blocks will used by nil .
#ifndef CC
    #if _CC_DEBUG_MODE_
        #define CC(_value_) \
            if (_CC_NIL_ASSERT_ENABLE_) { \
                CCLog(@"_CC_NIL_TERMINATION_\n instance that used in CCChain Kit can't be nil. \n"); \
                NSAssert(_value_ != nil , @"instance can't be nil"); \
            } \
            if (_value_ && [_value_ conformsToProtocol:@protocol(CCChainOperateProtocol)]) ([_value_ cc])
    #else
        #define CC(_value_) \
            if (_value_ && [_value_ conformsToProtocol:@protocol(CCChainOperateProtocol)]) ([_value_ cc])
    #endif
#endif

#ifndef _CC_DETECT_DEALLOC_
    #if _CC_DEBUG_MODE_
        #define _CC_DETECT_DEALLOC_ \
            - (void)dealloc { \
                CCLog(@"_CC_%@_DEALLOC_", NSStringFromClass([self class])); \
            }
    #else
        #define _CC_DETECT_DEALLOC_ /* */
    #endif
#endif

/// returns uuid
static NSString * _CC_UUID_;

/// returns fitable values related (by system origin , not custom)
/// for annoying iPhone X =.=
static CGRect _CC_STATUS_BAR_FRAME_ ;
static CGFloat _CC_STATUS_BAR_HEIGHT_ ;
static CGFloat _CC_STATUS_BAR_BOTTOM_ ; // may not equals to the navigation top on iPhone X
static CGFloat _CC_NAVIGATION_HEIGHT_ ;
static CGFloat _CC_NAVIGATION_BOTTOM_ ;
static CGFloat _CC_TABBAR_HEIGHT_ ;
static CGFloat _CC_TABBAR_TOP_ ;

@interface CCCommon : NSObject

- (instancetype) init NS_UNAVAILABLE;

/// notify you whether this operation was excuted on main thread .
/// returns if this operation was excuted on main thread .
BOOL CC_IS_MAIN_QUEUE(void);

/// sometimes you have to fit muti versions of iOS system
/// eg : CC_Available_C(10.0)
/// returns YES (and recall s) if system version was at least 10.0
/// retunrns NO (and recall f) if not .
BOOL CC_Available_C(double version);
void CC_Available_S(double version , void(^s)(void) , void(^f)(void));

/// if not in the main thread, operation will sync to it.
void CC_Main_Thread_Sync(void (^)(void));
/// if not in the main thread, operation will async to it.
void CC_Main_Thread_Async(void (^)(void));

/// operation for debug and release
void CC_DEBUG(void (^debug)(void) , void (^release)(void));

/// operation for debug and release , also , can be controlled manually
/// -1 DEBUG , 0 auto , 1 release
void CC_DEBUG_M(int mark , void (^debug)(void) , void (^release)(void));

/// if is SIMULATOR
/// recall y if is  , recall n if not .
void CC_DETECT_SIMULATOR(void (^y)(void) , void (^n)(void));

/// make sure that if a chain has started ,
/// non 'nil' return for next chain actions . (if does , system will crash immediately) .
void CC_SAFED_CHAIN(id object , void (^safe)(id object));

@end
