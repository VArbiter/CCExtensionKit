//
//  UINavigationItem+CCSpacing.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/3/31.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem (CCSpacing)

- (void) ccLeft : (UIBarButtonItem *) item
         offset : (NSInteger) integerOffset;
- (void) ccRight : (UIBarButtonItem *) item
          offset : (NSInteger) integerOffset;

#pragma mark - Not For Primary 
- (void) ccLeft : (UIBarButtonItem *) item ;
- (void) ccRight : (UIBarButtonItem *) item ;

@property (nonatomic , assign) NSInteger iOffsetLeft ;
@property (nonatomic , assign) NSInteger iOffsetRight ;

@end
