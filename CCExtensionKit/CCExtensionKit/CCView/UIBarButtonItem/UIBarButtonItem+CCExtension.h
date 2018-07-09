//
//  UIBarButtonItem+CCExtension.h
//  CCExtensionKit
//
//  Created by 冯明庆 on 2017/4/26.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (CCExtension)

+ (instancetype) cc_common ;
- (instancetype) cc_title : (NSString *) sTitle ;
- (instancetype) cc_image : (UIImage *) image ;
- (instancetype) cc_action : (void (^)( __kindof UIBarButtonItem *sender)) action ;
- (instancetype) cc_target : (id) target
                    action : (void (^)( __kindof UIBarButtonItem *sender)) action ;

@end
