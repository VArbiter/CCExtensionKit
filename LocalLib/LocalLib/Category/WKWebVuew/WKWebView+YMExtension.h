//
//  WKWebView+YMExtension.h
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface WKWebView (YMExtension)

+ (instancetype) ymInitWithFrame : (CGRect) rectFrame ;

+ (instancetype) ymInitWithFrame : (CGRect)rectFrame
                    withDelegate : (id) delegate ;

+ (instancetype) ymInitWithFrame : (CGRect)rectFrame
               withConfiguration : (WKWebViewConfiguration *) configuration
                    withDelegate : (id) delegate;

- (WKNavigation *) ymLoadRequest : (NSString *) stringRequest ;

- (WKNavigation *) ymLoadHTMLString : (NSString *) stringHTML ;

@end
