//
//  NSMutableArray+YMExtension.h
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/4/10.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (YMExtension)

@property (nonatomic , strong) NSString *stringClass ;

- (void) ymAddObject : (id) object ;
- (void) ymAddObject : (id) object
           withClass : (Class) clazz;
- (void) ymAddObjects : (NSMutableArray *) arrayObjects
            withClass : (Class) clazz ;

- (void) ymRemoveObject : (id) object
              withClass : (Class) clazz ;

- (void) ymRemoveObject : (id) object
    withCompleteHandler : (dispatch_block_t) block ;


/// 针对泛型 , 多个种类的的元素不考虑 .
- (void) ymRemoveAllObject : (BOOL(^)(BOOL isClass , id object)) block
                 withClass : (Class) clazz ;

- (void) ymAddObjects : (NSMutableArray *) array
  withCompleteHandler : (dispatch_block_t) block ;

@property (nonatomic , copy) void(^blockChange)(id value , NSInteger integerTotalCount);
@property (nonatomic , copy) dispatch_block_t blockComplete;

@end
