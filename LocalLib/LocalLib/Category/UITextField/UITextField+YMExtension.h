//
//  UITextField+YMExtension.h
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/4/5.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (YMExtension)

+ (UITextField *) ymCommonSettingsWithFrame : (CGRect) rectFrame ;
+ (UITextField *) ymCommonSettingsWithFrame : (CGRect) rectFrame
                               withDelegate : (id) delegate ;

- (void) ymSetRightViewWithImageName : (NSString *) stringImageName ;
- (BOOL) ymResignFirstResponder ;

@end
