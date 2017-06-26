//
//  UIBarButtonItem+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/26.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (CCExtension)

+ (instancetype) ccInitByImage : (NSString *) stringImageName
                         click : (void(^)(UIBarButtonItem *sender)) blockClick;
+ (instancetype) ccInitByImage : (NSString *) stringImageName
                         style : (UIBarButtonItemStyle) style
                         click : (void(^)(UIBarButtonItem *sender)) blockClick;

+ (instancetype) ccInitByImage : (NSString *) stringImageName
                        target : (id) target
                      selector : (SEL) selector ;
+ (instancetype) ccInitByImage : (NSString *) stringImageName
                         style : (UIBarButtonItemStyle) style
                        target : (id) target
                      selector : (SEL) selector ;

@property (nonatomic , copy) void(^blockClick)(UIBarButtonItem *sender) ;


#pragma mark - NOT FOR PRIMARY 

- (void) ccBarButtonAction : (UIBarButtonItem *) sender ;

@end
