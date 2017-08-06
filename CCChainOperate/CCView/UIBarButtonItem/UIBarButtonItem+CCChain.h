//
//  UIBarButtonItem+CCChain.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 06/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (CCChain)

@property (nonatomic , class , copy , readonly) UIBarButtonItem *(^common)();
@property (nonatomic , copy , readonly) UIBarButtonItem *(^titleS)(NSString *sTitle);
@property (nonatomic , copy , readonly) UIBarButtonItem *(^imageS)(UIImage *image);
@property (nonatomic , copy , readonly) UIBarButtonItem *(^actionS)(void (^)(UIBarButtonItem *sender));
@property (nonatomic , copy , readonly) UIBarButtonItem *(^targetS)(id target , void (^)(UIBarButtonItem *sender));

@end
