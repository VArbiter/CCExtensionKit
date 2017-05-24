//
//  UIGestureRecognizer+YMExtension.h
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/4/16.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIGestureRecognizer (YMExtension)

@property (nonatomic , copy) dispatch_block_t blockClick ;
- (void) ymGestureAction : (UITapGestureRecognizer *) sender ;

@end
