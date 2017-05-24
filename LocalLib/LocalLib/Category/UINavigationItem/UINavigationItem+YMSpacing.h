//
//  UINavigationItem+YMSpacing.h
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/3/31.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem (YMSpacing)

- (void) ymSetLeftButtonItem : (UIBarButtonItem *) item
                  withOffset : (NSInteger) integerOffset;
- (void) ymSetRightButtonItem : (UIBarButtonItem *) item
                   withOffset : (NSInteger) integerOffset;

#pragma mark - Not For Primary 
- (void) ymSetLeftButtonItem : (UIBarButtonItem *) item ;
- (void) ymSetRightButtonItem : (UIBarButtonItem *) item ;

@property (nonatomic , assign) NSInteger integerOffsetLeft ;
@property (nonatomic , assign) NSInteger integerOffsetRight ;

@end
