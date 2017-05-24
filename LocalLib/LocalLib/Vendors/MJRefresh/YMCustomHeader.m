//
//  YMCustomHeader.m
//  ym_sell_ios
//
//  Created by 冯明庆 on 23/05/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "YMCustomHeader.h"

#import "UIView+YMExtension.h"
#import "UILabel+YMExtension.h"
#import "YMCommonDefine.h"

@interface YMCustomHeader ()

@property (nonatomic , strong) UIActivityIndicatorView *indicatorView ;

@end

@implementation YMCustomHeader

- (void)prepare {
    [super prepare];
    
    [self addSubview:self.indicatorView];
}

- (void)placeSubviews {
    [super placeSubviews];
    
    self.indicatorView.center = self.inCenter;
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
        case MJRefreshStatePulling:{
            [self.indicatorView startAnimating];
        }break;
        case MJRefreshStateIdle:{
            [self.indicatorView stopAnimating];
        }break;
        default:{
            [self.indicatorView startAnimating];
        }break;
    }
}

#pragma mark - Getter
- (UIActivityIndicatorView *)indicatorView {
    if (_indicatorView) return _indicatorView;
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _indicatorView.color = ymHexColor(0xD82121, 1.f);
    [_indicatorView startAnimating];
    return _indicatorView;
}

@end
