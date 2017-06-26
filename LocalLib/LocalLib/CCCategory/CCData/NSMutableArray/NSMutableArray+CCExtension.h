//
//  NSMutableArray+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/10.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (CCExtension)

@property (nonatomic , strong) NSString *stringClass ;

- (void) ccAddObject : (id) object ;
- (void) ccAddObject : (id) object
                with : (Class) clazz;
- (void) ccAddObjects : (NSMutableArray *) arrayObjects
                 with : (Class) clazz ;

- (void) ccRemoveObject : (id) object
                   with : (Class) clazz ;

- (void) ccRemoveObject : (id) object
               complete : (dispatch_block_t) block ;

/// 针对泛型 , 多个种类的的元素不考虑 .
- (void) ccRemoveAllObject : (BOOL(^)(BOOL isClass , id object)) block
                      with : (Class) clazz ;

- (void) ccAddObjects : (NSMutableArray *) array
             complete : (dispatch_block_t) block ;

@property (nonatomic , copy) void(^blockChange)(id value , NSInteger iCountTotal);
@property (nonatomic , copy) dispatch_block_t blockComplete;

@end
