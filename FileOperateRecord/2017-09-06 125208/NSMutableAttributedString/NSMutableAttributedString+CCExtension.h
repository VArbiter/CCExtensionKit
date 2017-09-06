//
//  NSMutableAttributedString+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/24.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSMutableAttributedString (CCExtension)

+ (instancetype) ccAttribute : (UIColor *) color
                        with : (NSString *) string ;

- (instancetype) ccAppend : (NSMutableAttributedString *) attributeString ;

@end
