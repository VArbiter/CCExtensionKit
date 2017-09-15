//
//  UIFont+CCExtension.m
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 08/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "UIFont+CCExtension.h"

@implementation UIFont (CCExtension)

- (instancetype) ccSize : (CGFloat) fSize {
    return [self fontWithSize:fSize];
}
+ (instancetype) ccSystem : (CGFloat) fSize {
    return [UIFont systemFontOfSize:fSize];
}
+ (instancetype) ccBold : (CGFloat) fSize {
    return [UIFont boldSystemFontOfSize:fSize];
}
+ (instancetype) ccFamily : (NSString *) sFontName
                     size : (CGFloat) fSize {
    if ([sFontName isKindOfClass:NSString.class] && sFontName && sFontName.length) {
        return [UIFont fontWithName:sFontName size:fSize];
    }
    return [self ccSystem:fSize];
}

@end
