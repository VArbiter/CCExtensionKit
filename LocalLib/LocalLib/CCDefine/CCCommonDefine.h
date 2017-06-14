//
//  CCCommonDefine.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/3/28.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCMethodDef.h"
#import "NSObject+CCExtension.h"

@class UIColor ;
@class UIImage ;

@interface CCCommonDefine : NSObject

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

#define _CC_DETECT_DEALLOC_ \
    - (void)dealloc { \
        CCLog(@"_CC_%@_DEALLOC_", NSStringFromClass([self class]));\
    } \

// self 弱引用
#define ccWeakSelf __weak typeof(&*self) pSelf = self

// 字符串格式化
#define ccStringFormat(...) [NSString stringWithFormat:__VA_ARGS__]
// 字符串融合 , 干掉 nil , 不能使用集合类 .
#define ccMergeObject(...) ccObjMerge(__VA_ARGS__ , nil)
// 字符串转化
#define ccStringTransfer(...) ccStringFormat(@"%@",ccMergeObject(__VA_ARGS__))
// 便捷 LOG
#define _CC_Log(...) CCLog(@"%@",ccStringTransfer(__VA_ARGS__))
/// 判断非空
#define ccIsNull(VALUE) (!VALUE || [VALUE isKindOfClass:[NSNull class]])


void _CC_Safe_Block_ (id blockNil , dispatch_block_t block) ;
void _CC_Safe_UI_Block_ (id blockNil , dispatch_block_t block) ;
void _CC_UI_Operate_block(dispatch_block_t block) ;

UIColor * ccHexColor(int intValue ,float floatAlpha) ;

UIColor *ccRGBColor(float floatR , float floatG , float floatB);
UIColor *ccRGBAColor(float floatR , float floatG , float floatB , float floatA);

NSURL * ccURL (NSString * stringURL , BOOL isLocalFile) ;

UIImage *ccImageCache(NSString *stringName);

UIImage *ccImage(NSString *stringName , BOOL isCacheInMemory);

NSString * ccLocalize(NSString * stringLocalKey , char *stringCommont);

/// 末尾需要添加 nil , C function 无法使用 NS_REQUIRES_NIL_TERMINATION , 不能使用集合类 .
NSString * ccObjMerge(id obj , ... ) ;

@end

