//
//  NSUserDefaults+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 18/11/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (CCExtension)

/// an easy way to do 'standardUserDefaults' && 'synchronize'
BOOL CC_USER_DEFAULLTS(void (^bDef)(NSUserDefaults *sender)) ;

/// reset standard userDefaults .
void CC_RESET_USER_DEFAULLTS(void) ;

@end
