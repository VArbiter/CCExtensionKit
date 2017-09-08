//
//  UILabel+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (CCExtension)

+ (instancetype) common : (CGRect) frame;

/// auto fit with text || attributed Text ,
/// params fEstimate that determins if the height after calculate ,  was lesser than original .
/// note: ignores text-indent , attributed text's level will be higher than others
- (instancetype) ccAutoHeight : (CGFloat) fEstimate ;
- (instancetype) ccAttributedTextHeight : (CGFloat) fEstimate ;
- (instancetype) ccTextHeight : (CGFloat) fEstimate ;

@end
