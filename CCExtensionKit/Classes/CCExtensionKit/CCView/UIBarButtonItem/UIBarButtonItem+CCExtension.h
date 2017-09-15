//
//  UIBarButtonItem+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/26.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (CCExtension)

+ (instancetype) common ;
- (instancetype) ccTitle : (NSString *) sTitle ;
- (instancetype) ccImage : (UIImage *) image ;
- (instancetype) ccAction : (void (^)( __kindof UIBarButtonItem *sender)) action ;
- (instancetype) ccTarget : (id) target
                   action : (void (^)( __kindof UIBarButtonItem *sender)) action ;

@end
