//
//  CCGradientLayerView.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 18/11/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCGradientLayerView : UIView

- (void) ccBeginWith : (CGPoint) pBegin // the point that gradient begins . (CGPoint){[0,1],[0,1]}
                 end : (CGPoint) pEnd // the point that gradient ends . (CGPoint){[0,1],[0,1]}
              colors : (NSArray <UIColor *> *(^)(void)) colors // colors that uses for gradient .
        eachPercents : (NSArray <NSNumber *> *(^)(void)) percents ;// each color holds the percent of the gradient area . [0..1]

// note : the count of 'colors' and 'percents' must compare to each others .

@end
