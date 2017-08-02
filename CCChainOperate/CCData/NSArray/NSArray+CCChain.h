//
//  NSArray+CCChain.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 01/07/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (CCChain)

@property (nonatomic , copy , readonly) id (^valueAt)(NSInteger index) ;

@end


#pragma mark - -----------------------------------------------------------------

typedef NS_ENUM(NSInteger, CCArrayChangeType) {
    CCArrayChangeTypeNone = 0 ,
    CCArrayChangeTypeAppend ,
    CCArrayChangeTypeRemoved
};

struct CCArrayChangeInfo {
    CCArrayChangeType type ;
    long long count ;
};
typedef struct CCArrayChangeInfo CCArrayChangeInfo;

@interface NSMutableArray (CCChain)

@property (nonatomic , copy , readonly) NSMutableArray *(^type)(NSString *clazz);
@property (nonatomic , copy , readonly) NSMutableArray *(^append)(id value);
@property (nonatomic , copy , readonly) NSMutableArray *(^appendE)(id value , BOOL isExpand);
@property (nonatomic , copy , readonly) NSMutableArray *(^remove)(id value);
@property (nonatomic , copy , readonly) NSMutableArray *(^removeAll)(BOOL (^t)(BOOL isCompare , id obj));

/// Observers , like all observers , need added before it used .
@property (nonatomic , copy , readonly) NSMutableArray *(^change)(void (^t)(id value , CCArrayChangeInfo type));
@property (nonatomic , copy , readonly) NSMutableArray *(^complete)(void (^r)(CCArrayChangeInfo type));

@end
