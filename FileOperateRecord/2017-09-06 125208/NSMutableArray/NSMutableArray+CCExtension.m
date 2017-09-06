//
//  NSMutableArray+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/10.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "NSMutableArray+CCExtension.h"
#import "NSArray+CCExtension.h"

#import "NSObject+CCExtension.h"
#import <objc/runtime.h>

@implementation NSMutableArray (CCExtension)

- (void) ccAddObject : (id) object {
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
- (void) ccAddObject : (id) object
                with : (Class) clazz {
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
- (void) ccAddObjects : (NSMutableArray *) arrayObjects
                 with : (Class) clazz {
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

- (void) ccRemoveObject : (id) object
                   with : (Class) clazz {
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

- (void) ccRemoveObject : (id) object
               complete : (dispatch_block_t) block {
    if (![self isKindOfClass:[NSMutableArray class]]) return;
    if (self.isArrayValued) {
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

- (void) ccRemoveAllObject : (BOOL(^)(BOOL isClass , id Object)) block
                      with : (Class) clazz {
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

- (void) ccAddObjects : (NSMutableArray *) array
             complete : (dispatch_block_t) block {
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
    objc_setAssociatedObject(self, @selector(stringClass), stringClass, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)setBlockChange:(void (^)(id, NSInteger))blockChange {
    objc_setAssociatedObject(self, @selector(blockChange), blockChange, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)setBlockComplete:(dispatch_block_t)blockComplete {
    objc_setAssociatedObject(self, @selector(blockComplete), blockComplete, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
#pragma mark - Getter
- (NSString *)stringClass {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(id, NSInteger))blockChange {
    return objc_getAssociatedObject(self, _cmd);
}

- (dispatch_block_t)blockComplete {
    return objc_getAssociatedObject(self, _cmd);
}

@end
