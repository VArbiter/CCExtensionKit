//
//  UIGestureRecognizer+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/16.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIGestureRecognizer (CCExtension)

@property (nonatomic , copy) dispatch_block_t blockClick ;
- (void) ccGestureAction : (UITapGestureRecognizer *) sender ;

@end
