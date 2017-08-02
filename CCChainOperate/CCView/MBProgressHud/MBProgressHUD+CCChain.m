//
//  MBProgressHUD+CCChain.m
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 02/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "MBProgressHUD+CCChain.h"

@implementation MBProgressHUD (CCChain)

- (MBProgressHUD *(^)())enable {
    __weak typeof(self) pSelf = self;
    return ^MBProgressHUD * {
        pSelf.userInteractionEnabled = false;
        return pSelf;
    };
}

- (MBProgressHUD *(^)())disable {
    __weak typeof(self) pSelf = self;
    return ^MBProgressHUD * {
        pSelf.userInteractionEnabled = YES;
        return pSelf;
    };
}

@end
