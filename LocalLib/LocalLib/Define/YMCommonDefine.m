//
//  YMCommonDefine.m
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/3/28.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "YMCommonDefine.h"
#import <UIKit/UIKit.h>
#import "NSString+YMExtension.h"

@interface YMCommonDefine ()

@end

@implementation YMCommonDefine

void _YM_Safe_Block_ (id blockNil , dispatch_block_t block) {
    if (!blockNil || !block) return;
    block();
}

void _YM_Safe_UI_Block_ (id blockNil , dispatch_block_t block) {
    if (!blockNil || !block) return;
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            block();
        });
    }
}

void _YM_UI_Operate_block(dispatch_block_t block) {
    if (!block) return;
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            block();
        });
    }
}

UIColor * ymHexColor(int intValue ,float floatAlpha){
    return [UIColor colorWithRed:((CGFloat)((intValue & 0xFF0000) >> 16)) / 255.0
                           green:((CGFloat)((intValue & 0xFF00) >> 8)) / 255.0
                            blue:((CGFloat)(intValue & 0xFF)) / 255.0
                           alpha:(CGFloat)floatAlpha];
}

UIColor *ymRGBColor(float floatR , float floatG , float floatB){
    return ymRGBAColor(floatR, floatG, floatB, 1.0f);
}
UIColor *ymRGBAColor(float floatR , float floatG , float floatB , float floatA) {
    return [UIColor colorWithRed:floatR / 255.0f
                           green:floatG / 255.0f
                            blue:floatB / 255.0f
                           alpha:floatA];
}

NSURL * ymURL (NSString * stringURL , BOOL isLocalFile) {
    return isLocalFile ? [NSURL fileURLWithPath:stringURL] : [NSURL URLWithString:stringURL];
}

UIImage *ymImageCache(NSString *stringName){
    return ymImage(stringName, YES);
}

UIImage *ymImage(NSString *stringName , BOOL isCacheInMemory){
    return isCacheInMemory ? [UIImage imageNamed:stringName] : [UIImage imageWithContentsOfFile:stringName];
}

NSString * ymLocalize(NSString * stringLocalKey , char *stringCommont){
    return NSLocalizedStringFromTableInBundle(stringLocalKey, @"LocalizableMain", [NSBundle mainBundle], nil);
//    return NSLocalizedString(stringLocalKey, nil);
}

NSString * myLocalize(NSString * stringLocalKey, NSString * stringComment) {
    return NSLocalizedStringFromTableInBundle(stringLocalKey, @"LocalizableMain", [NSBundle mainBundle], stringComment);
}

NSString * ymObjMerge(id obj , ... ) {
    NSMutableArray *arrayStrings = [NSMutableArray array];
    NSString *stringTemp;
    va_list argumentList;
    if (obj) {
        if ([obj isKindOfClass:[NSString class]]) {
            [arrayStrings addObject:obj];
        } else [arrayStrings addObject:ymStringFormat(@"%@",obj)];
        va_start(argumentList, obj);
        while ((stringTemp = va_arg(argumentList, id))) {
            if ([stringTemp isKindOfClass:[NSString class]]) {
                [arrayStrings addObject:stringTemp];
            } else [arrayStrings addObject:ymStringFormat(@"%@",stringTemp)] ;
        }
        va_end(argumentList);
    }
    return [NSString ymMergeWithStringArray:arrayStrings
                          withNeedLineBreak:false
                            withNeedSpacing:false];
}

@end
