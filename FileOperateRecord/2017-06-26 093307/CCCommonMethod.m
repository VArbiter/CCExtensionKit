//
//  CCCommonDefine.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/3/28.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "CCCommonDefine.h"
#import <UIKit/UIKit.h>
#import "NSString+CCExtension.h"

@interface CCCommonDefine ()

@end

@implementation CCCommonDefine

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
    return [NSString ccMergeWithStringArray:arrayStrings
                          withNeedLineBreak:false
                            withNeedSpacing:false];
}

@end
