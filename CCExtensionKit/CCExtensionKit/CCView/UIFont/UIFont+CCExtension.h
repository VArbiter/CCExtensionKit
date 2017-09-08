//
//  UIFont+CCExtension.h
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 08/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (CCExtension)

/// when you determin to make a font that auto adjust it self for different screens
/// note: fill in with CCScaleH(_value_) , and if you're not sure it is .
/// use label's (also available on others) height and decrease 2 (for pixels) .

- (instancetype) ccSize : (CGFloat) fSize ;
+ (instancetype) ccSystem : (CGFloat) fSize ;
+ (instancetype) ccBold : (CGFloat) fSize ;
+ (instancetype) ccFamily : (NSString *) sFontName
                     size : (CGFloat) fSize ;

@end
