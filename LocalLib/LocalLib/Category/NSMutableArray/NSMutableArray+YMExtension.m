//
//  NSMutableArray+YMExtension.m
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/4/10.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "NSMutableArray+YMExtension.h"
#import "NSArray+YMExtension.h"

#import <objc/runtime.h>

const char * _YM_ARRAY_ASSOCIATE_KEY_;
const char * _YM_ARRAY_OBSERVER_KEY_ ;
const char * _YM_ARRAY_OPERATE_COMPLETE_KEY_ ;

@implementation NSMutableArray (YMExtension)

- (void) ymAddObject : (id) object {
    BOOL isCanAdd = false;
    if (self.stringClass) {
        isCanAdd = [object isKindOfClass:NSClassFromString(self.stringClass)];
    }
    else isCanAdd = YES;
    
    if (isCanAdd && object) {
        [self addObject:object];
        if (self.blockChange) {
            self.blockChange(object, self.count);
        }
        if (self.blockComplete) {
            self.blockComplete();
        }
    }
}
- (void) ymAddObject : (id) object
           withClass : (Class) clazz {
    BOOL isCanAdd = false;
    if (clazz) {
        isCanAdd = [object isKindOfClass:clazz];
    }
    else if (self.stringClass) {
        isCanAdd = [object isKindOfClass:NSClassFromString(self.stringClass)];
    }
    else isCanAdd = YES;
    
    if (isCanAdd && object) {
        [self addObject:object];
        if (self.blockChange) {
            self.blockChange(object, self.count);
        }
        if (self.blockComplete) {
            self.blockComplete();
        }
    }
}
- (void) ymAddObjects : (NSMutableArray *) arrayObjects
            withClass : (Class) clazz {
    if (!arrayObjects || !arrayObjects.count) return;
    
    for (id object in arrayObjects) {
        BOOL isCanAdd = false;
        if (clazz) {
            isCanAdd = [object isKindOfClass:clazz];
        }
        else if (self.stringClass) {
            isCanAdd = [object isKindOfClass:NSClassFromString(self.stringClass)];
        }
        else isCanAdd = YES;
        
        if (isCanAdd && object) {
            [self addObject:object];
            if (self.blockChange) {
                self.blockChange(arrayObjects, self.count);
            }
        }
    }
    
    if (self.blockComplete) {
        self.blockComplete();
    }
}

- (void) ymRemoveObject : (id) object
              withClass : (Class) clazz {
    BOOL isCanRemove = false;
    if (clazz) {
        isCanRemove = [object isKindOfClass:clazz];
    }
    else if (self.stringClass) {
        isCanRemove = [object isKindOfClass:NSClassFromString(self.stringClass)];
    }
    else isCanRemove = YES;
    
    if (isCanRemove) {
        if (self.count && [self containsObject:object]) {
            [self removeObject:object];
            if (self.blockChange) {
                self.blockChange(object, self.count);
            }
            if (self.blockComplete) {
                self.blockComplete();
            }
        }
    }
}

- (void) ymRemoveObject : (id) object
    withCompleteHandler : (dispatch_block_t) block {
    if (![self isKindOfClass:[NSMutableArray class]]) return;
    if (self.ymIsArrayValued) {
        if ([self containsObject:object]) {
            [self removeObject:object];
            if (block) {
                block();
            }
            if (self.blockComplete) {
                self.blockComplete();
            }
        }
    }
}

- (void) ymRemoveAllObject : (BOOL(^)(BOOL isClass , id Object)) block
                 withClass : (Class) clazz {
    if (!self.count) return;
    
    for (NSUInteger i = 0; i < self.count; i++) {
        id object = self[i];
        
        BOOL isCanRemove = false;
        if (clazz) {
            isCanRemove = [object isKindOfClass:clazz];
        }
        else if (self.stringClass) {
            isCanRemove = [object isKindOfClass:NSClassFromString(self.stringClass)];
        }
        else isCanRemove = YES;
        
        if (block) {
            if ([self containsObject:object]) {
                if (block(isCanRemove , object)) {
                    [self removeObject:object];
                    if (self.blockChange) {
                        self.blockChange(object, self.count);
                    }
                }
            }
        }
    }
    if (self.blockComplete) {
        self.blockComplete();
    }
}

- (void) ymAddObjects : (NSMutableArray *) array
  withCompleteHandler : (dispatch_block_t) block {
    [self addObjectsFromArray:array];
    if (block) {
        block();
    }
    if (self.blockComplete) {
        self.blockComplete();
    }
}

#pragma mark - Setter
- (void)setStringClass:(NSString *)stringClass {
    objc_setAssociatedObject(self, &_YM_ARRAY_ASSOCIATE_KEY_, stringClass, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)setBlockChange:(void (^)(id, NSInteger))blockChange {
    objc_setAssociatedObject(self, &_YM_ARRAY_OBSERVER_KEY_, blockChange, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)setBlockComplete:(dispatch_block_t)blockComplete {
    objc_setAssociatedObject(self, &_YM_ARRAY_OPERATE_COMPLETE_KEY_, blockComplete, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
#pragma mark - Getter
- (NSString *)stringClass {
    return objc_getAssociatedObject(self, &_YM_ARRAY_ASSOCIATE_KEY_);
}

- (void (^)(id, NSInteger))blockChange {
    return objc_getAssociatedObject(self, &_YM_ARRAY_OBSERVER_KEY_);
}

- (dispatch_block_t)blockComplete {
    return objc_getAssociatedObject(self, &_YM_ARRAY_OPERATE_COMPLETE_KEY_);
}

@end
