//
//  NSPredicate+CCChain.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 01/07/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSPredicate (CCChain)

@property (nonatomic , class , copy , readonly) NSPredicate *(^common)(NSString *regex);
@property (nonatomic , class , copy , readonly) NSPredicate *(^time)(); // YYYY-MM-DD HH:mm:ss
@property (nonatomic , copy , readonly) id (^evaluate)(id object) ;

@end
