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
#import "CCCommonTools.h"

@interface CCCustomFooter ()

@property (nonatomic , strong) UILabel *label;

@end

@implementation CCCustomFooter

- (void)prepare {
    [super prepare];
    [self addSubview:self.label];

}

- (void)placeSubviews {
    [super placeSubviews];
    
    self.label.center = CGPointMake(self.inCenter.x + CC_DYNAMIC_WIDTH(22.f), self.inCenterY);
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
        }break;
        default:{
            self.label.hidden = YES;
        }break;
    }
}

#pragma mark - Getter 
- (UILabel *)label {
    if (_label) return _label ;
    _label = [UILabel ccCommon:CGRectZero];
    _label.textAlignment = NSTextAlignmentCenter;
    self.label.text = ccLocalize(@"_CC_HAS_NO_MORE_", "没有更多了");
    [self.label sizeToFit];
    return _label;
}

@end

