//
//  UINavigationItem+CCSpacing.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/3/31.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem (CCSpacing)

- (void) ccSetLeftButtonItem : (UIBarButtonItem *) item
                  withOffset : (NSInteger) integerOffset;
- (void) ccSetRightButtonItem : (UIBarButtonItem *) item
                   withOffset : (NSInteger) integerOffset;

#pragma mark - Not For Primary 
- (void) ccSetLeftButtonItem : (UIBarButtonItem *) item ;
- (void) ccSetRightButtonItem : (UIBarButtonItem *) item ;

@property (nonatomic , assign) NSInteger integerOffsetLeft ;
@property (nonatomic , assign) NSInteger integerOffsetRight ;

@end
