//
//  NSMutableAttributedString+YMExtension.h
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/4/24.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (YMExtension)

+ (instancetype) ymAttributeWithColor : (UIColor *) color
                           withString : (NSString *) string ;

- (instancetype) ymAppend : (NSMutableAttributedString *) attributeString ;

@end
