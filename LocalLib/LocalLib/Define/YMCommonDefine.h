//
//  YMCommonDefine.h
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/3/28.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMMethodDef.h"

@class UIColor ;
@class UIImage ;

@interface YMCommonDefine : NSObject

#if DEBUG
    #define _YM_DEBUG_MODE_ 1
#else
    #define _YM_DEBUG_MODE_ 0
#endif

#if TARGET_IPHONE_SIMULATOR 
    #define _YM_IS_SIMULATOR_ 1
#else
    #define _YM_IS_SIMULATOR_ 0
#endif

#if 1
    #if _YM_DEBUG_MODE_
        #define YMLog(fmt , ...) NSLog((@"\n\n_YM_LOG_\n\n_YM_FILE_  %s\n_YM_METHOND_  %s\n_YM_LINE_  %d\n" fmt),__FILE__,__func__,__LINE__,##__VA_ARGS__)
    #else
        #define YMLog(fmt , ...) /* */
    #endif
#else
    #define YMLog(fmt , ...) /* */
#endif

#define _YM_DETECT_DEALLOC_ \
    - (void)dealloc { \
        YMLog(@"_YM_%@_DEALLOC_", NSStringFromClass([self class]));\
    } \

// self 弱引用
#define ymWeakSelf __weak typeof(&*self) pSelf = self

// 字符串格式化
#define ymStringFormat(...) [NSString stringWithFormat:__VA_ARGS__]
// 字符串融合 , 干掉 nil , 不能使用集合类 .
#define ymMergeObject(...) ymObjMerge(__VA_ARGS__ , nil)
// 字符串转化
#define ymStringTransfer(...) ymStringFormat(@"%@",ymMergeObject(__VA_ARGS__))
// 便捷 LOG
#define _YM_Log(...) YMLog(@"%@",ymStringTransfer(__VA_ARGS__))
/// 判断非空
#define ymIsNull(VALUE) (!VALUE || [VALUE isKindOfClass:[NSNull class]])


void _YM_Safe_Block_ (id blockNil , dispatch_block_t block) ;
void _YM_Safe_UI_Block_ (id blockNil , dispatch_block_t block) ;
void _YM_UI_Operate_block(dispatch_block_t block) ;

UIColor * ymHexColor(int intValue ,float floatAlpha) ;

UIColor *ymRGBColor(float floatR , float floatG , float floatB);
UIColor *ymRGBAColor(float floatR , float floatG , float floatB , float floatA);

NSURL * ymURL (NSString * stringURL , BOOL isLocalFile) ;

UIImage *ymImageCache(NSString *stringName);

UIImage *ymImage(NSString *stringName , BOOL isCacheInMemory);

NSString * ymLocalize(NSString * stringLocalKey , char *stringCommont);

NSString * myLocalize(NSString * stringLocalKey, NSString * stringComment);

/// 末尾需要添加 nil , C function 无法使用 NS_REQUIRES_NIL_TERMINATION , 不能使用集合类 .
NSString * ymObjMerge(id obj , ... ) ;

@end

