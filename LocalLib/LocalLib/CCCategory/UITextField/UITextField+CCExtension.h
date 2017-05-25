//
//  UITextField+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/5.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (CCExtension)

+ (UITextField *) ccCommonSettingsWithFrame : (CGRect) rectFrame ;
+ (UITextField *) ccCommonSettingsWithFrame : (CGRect) rectFrame
                               withDelegate : (id) delegate ;

- (void) ccSetRightViewWithImageName : (NSString *) stringImageName ;
- (BOOL) ccResignFirstResponder ;

@end
