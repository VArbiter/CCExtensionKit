//
//  NSObject+CCProtocol.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 02/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCChainOperateProtocol.h"

@interface NSObject (CCProtocol) < CCChainOperateProtocol >
@end

#pragma mark - DATA

@interface NSNumber (CCProtocol) < CCChainOperateProtocol >
@end

@interface NSDictionary (CCProtocol) < CCChainOperateProtocol >
@end

@interface NSMutableDictionary (CCProtocol) < CCChainOperateProtocol >
@end

@interface NSArray (CCProtocol) < CCChainOperateProtocol >
@end

@interface NSMutableArray (CCProtocol) < CCChainOperateProtocol >
@end

@interface NSDate (CCProtocol) < CCChainOperateProtocol >
@end

@interface NSAttributedString (CCProtocol) < CCChainOperateProtocol >
@end

@interface NSMutableAttributedString (CCProtocol) < CCChainOperateProtocol >
@end

@interface NSPredicate (CCProtocol) < CCChainOperateProtocol >
@end

@interface NSString (CCProtocol) < CCChainOperateProtocol >
@end

#pragma mark - VIEW
#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface UIView (CCProtocol) < CCChainOperateProtocol >
@end

@interface UIGestureRecognizer (CCProtocol) < CCChainOperateProtocol >
@end

@interface UITapGestureRecognizer (CCProtocol) < CCChainOperateProtocol >
@end

@interface UILongPressGestureRecognizer (CCProtocol) < CCChainOperateProtocol >
@end

@interface MBProgressHUD (CCProtocol) < CCChainOperateProtocol >
@end

@interface UIAlertController (CCProtocol) < CCChainOperateProtocol >
@end
