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

void CC_Safe_Operation(id blockNil ,
                       dispatch_block_t block) ;
void CC_Safe_UI_Operation(id blockNil ,
                          dispatch_block_t block) ;
void CC_Main_Queue_Operation(dispatch_block_t block) ;
void CC_Debug_Operation(dispatch_block_t block) ;

UIColor * ccHexColor(int intValue ,
                     float floatAlpha) ;

UIColor *ccRGBColor(float floatR ,
                    float floatG ,
                    float floatB);
UIColor *ccRGBAColor(float floatR ,
                     float floatG ,
                     float floatB ,
                     float floatA);

NSURL * ccURL (NSString * stringURL ,
               BOOL isLocalFile) ;

UIImage *ccImageCache(NSString *stringName);

UIImage *ccImage(NSString *stringName ,
                 BOOL isCacheInMemory);

NSString * ccLocalize(NSString * stringLocalKey , ...); // Default Main

NSString * ccBundleLocalize(NSString * stringLocalKey , NSBundle * bundle , ... ); // Default @"LocalizableMain.strings"

/// 末尾需要添加 nil , C function 无法使用 NS_REQUIRES_NIL_TERMINATION , 不能使用集合类 .
NSString * ccObjMerge(id obj , ... ) ;

@end

