//
//  UIImageView+CCWeakNetwork.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/27.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (CCWeakNetwork)

// 弱网不下载图片 .
- (void) ccSDImageWithLink : (NSString *) stringLik
           withHolderImage : (NSString *) stringImageName ;

@end
