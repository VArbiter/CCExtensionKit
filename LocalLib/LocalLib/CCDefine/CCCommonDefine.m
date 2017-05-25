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

void _CC_Safe_Block_ (id blockNil , dispatch_block_t block) {
    if (!blockNil || !block) return;
    block();
}

void _CC_Safe_UI_Block_ (id blockNil , dispatch_block_t block) {
    if (!blockNil || !block) return;
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            block();
        });
    }
}

void _CC_UI_Operate_block(dispatch_block_t block) {
    if (!block) return;
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            block();
        });
    }
}

UIColor * ccHexColor(int intValue ,float floatAlpha){
    return [UIColor colorWithRed:((CGFloat)((intValue & 0xFF0000) >> 16)) / 255.0
                           green:((CGFloat)((intValue & 0xFF00) >> 8)) / 255.0
                            blue:((CGFloat)(intValue & 0xFF)) / 255.0
                           alpha:(CGFloat)floatAlpha];
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

NSString * ccLocalize(NSString * stringLocalKey , char *stringCommont){
    return NSLocalizedStringFromTableInBundle(stringLocalKey, @"LocalizableMain", [NSBundle mainBundle], nil);
//    return NSLocalizedString(stringLocalKey, nil);
}

NSString * myLocalize(NSString * stringLocalKey, NSString * stringComment) {
    return NSLocalizedStringFromTableInBundle(stringLocalKey, @"LocalizableMain", [NSBundle mainBundle], stringComment);
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
