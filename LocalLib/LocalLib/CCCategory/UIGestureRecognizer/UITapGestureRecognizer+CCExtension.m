//
//  UITapGestureRecognizer+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/16.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UITapGestureRecognizer+CCExtension.h"
#import "UIGestureRecognizer+CCExtension.h"

@implementation UITapGestureRecognizer (CCExtension)

- (instancetype) initWithActionBlock : (dispatch_block_t) blockClick {
    return [self initWithTaps:1
              withActionBlock:blockClick];
}

- (instancetype) initWithTaps : (NSInteger) integerTaps
              withActionBlock : (dispatch_block_t) blockClick {
    if ((self = [super init])) {
        self.numberOfTapsRequired = integerTaps;
        self.blockClick = [blockClick copy];
        [self addTarget:self
                 action:@selector(ccGestureAction:)];
    }
    return self;
}

@end
