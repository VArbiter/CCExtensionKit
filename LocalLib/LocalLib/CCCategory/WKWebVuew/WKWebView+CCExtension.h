//
//  WKWebView+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface WKWebView (CCExtension)

+ (instancetype) ccInitWithFrame : (CGRect) rectFrame ;

+ (instancetype) ccInitWithFrame : (CGRect)rectFrame
                    withDelegate : (id) delegate ;

+ (instancetype) ccInitWithFrame : (CGRect)rectFrame
               withConfiguration : (WKWebViewConfiguration *) configuration
                    withDelegate : (id) delegate;

- (WKNavigation *) ccLoadRequest : (NSString *) stringRequest ;

- (WKNavigation *) ccLoadHTMLString : (NSString *) stringHTML ;

@end
