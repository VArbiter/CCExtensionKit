//
//  CCBridgeWrapper.h
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 14/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCBridgeWrapper : NSObject

+ (instancetype) shared ;

- (instancetype) ccFallBack : (void (^)()) fallBack ;


@end
