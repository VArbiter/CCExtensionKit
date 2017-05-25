//
//  NSMutableAttributedString+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/24.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (CCExtension)

+ (instancetype) ccAttributeWithColor : (UIColor *) color
                           withString : (NSString *) string ;

- (instancetype) ccAppend : (NSMutableAttributedString *) attributeString ;

@end
