//
//  WKWebView+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface WKWebView (CCExtension)

+ (instancetype) ccCommon : (CGRect) rectFrame ;

+ (instancetype) ccCommon : (CGRect)rectFrame
                 delegate : (id) delegate ;

+ (instancetype) ccCommon : (CGRect)rectFrame
            configuration : (WKWebViewConfiguration *) configuration
                 delegate : (id) delegate;

- (WKNavigation *) ccLoad : (NSString *) string ;

#pragma mark - Not For Primary
- (WKNavigation *) ccLoadRequest : (NSString *) stringRequest ;
- (WKNavigation *) ccLoadHTMLString : (NSString *) stringHTML ;

@end
