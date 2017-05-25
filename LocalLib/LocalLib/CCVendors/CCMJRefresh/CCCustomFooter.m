//
//  CCCustomFooter.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 10/05/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "CCCustomFooter.h"

#import "UILabel+CCExtension.h"
#import "UIView+CCExtension.h"
#import "UIImageView+CCExtension.h"
#import "CCCommonDefine.h"

@interface CCCustomFooter ()

@property (nonatomic , strong) UILabel *label;
@property (nonatomic , strong) UIImageView *imageViewAnimated ;

@end

@implementation CCCustomFooter

- (void)prepare {
    [super prepare];
    [self addSubview:self.label];
    [self addSubview:self.imageViewAnimated];
}

- (void)placeSubviews {
    [super placeSubviews];
    
    self.label.center = CGPointMake(self.inCenter.x + CC_DYNAMIC_WIDTH(22.f), self.inCenterY);
    
    self.imageViewAnimated.right = self.label.left - CC_DYNAMIC_WIDTH(22.f);
    self.imageViewAnimated.centerY = self.inCenterY;
}

#pragma mark - Moniter
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
    
}
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change {
    [super scrollViewContentSizeDidChange:change];
    
}
- (void)scrollViewPanStateDidChange:(NSDictionary *)change {
    [super scrollViewPanStateDidChange:change];
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState;
    switch (state) {
        case MJRefreshStateNoMoreData:{
            self.label.hidden = false;
            self.imageViewAnimated.hidden = false;
        }break;
        default:{
            self.label.hidden = YES;
            self.imageViewAnimated.hidden = YES;
        }break;
    }
}

#pragma mark - Getter 
- (UILabel *)label {
    if (_label) return _label ;
    _label = [UILabel ccLabelCommonSettings:CGRectZero];
    _label.textAlignment = NSTextAlignmentCenter;
    self.label.text = ccLocalize(@"_CC_HAS_NO_MORE_", "没有更多了");
    [self.label sizeToFit];
    return _label;
}
- (UIImageView *)imageViewAnimated {
    if (_imageViewAnimated) return _imageViewAnimated;
    _imageViewAnimated = [UIImageView ccCommonSettingsWithFrame:CGRectZero
                                                      withImage:ccImage(@"_CC_IMAGE_REFRESH_NO_MORE_DATA", YES)];
    _imageViewAnimated.animationDuration = .5f;
    _imageViewAnimated.animationRepeatCount = INFINITY;
    
    NSArray *array= [NSArray ccRefreshGifImageArray];
    self.imageViewAnimated.animationImages = array;
    
    [_imageViewAnimated sizeToFit];
    return _imageViewAnimated;
}

@end

