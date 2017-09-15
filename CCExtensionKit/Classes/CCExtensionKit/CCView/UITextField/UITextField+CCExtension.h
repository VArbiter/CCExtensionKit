//
//  UITextField+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/5.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (CCExtension)

+ (instancetype) common : (CGRect) frame ;
- (instancetype) ccDelegateT : (id <UITextFieldDelegate>) delegete ;
- (instancetype) ccPlaceHolder : (NSDictionary <NSString * , id> *) dAttributes
                        string : (NSString *) string ;

/// default with a image View that already size-to-fit with original image .
- (instancetype) ccLeftView : (UIImage *) image
                       mode : (UITextFieldViewMode) mode ;
- (instancetype) ccRightView : (UIImage *) image
                        mode : (UITextFieldViewMode) mode ;

@property (nonatomic , readonly) BOOL resignFirstResponderT;

@end
