//
//  WKWebView+YMExtension.m
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "WKWebView+YMExtension.h"

#import "NSString+YMExtension.h"

#import "YMCommonDefine.h"

@implementation WKWebView (YMExtension)

+ (instancetype) ymInitWithFrame : (CGRect) rectFrame {
    return [self ymInitWithFrame:rectFrame withDelegate:nil];
}

+ (instancetype) ymInitWithFrame : (CGRect)rectFrame
                    withDelegate : (id) delegate {
    return [self ymInitWithFrame:rectFrame withConfiguration:nil withDelegate:delegate];
}

+ (instancetype) ymInitWithFrame : (CGRect)rectFrame
               withConfiguration : (WKWebViewConfiguration *) configuration
                    withDelegate : (id) delegate {
    WKWebView *webView = nil;
    if (configuration) {
        webView = [[WKWebView alloc] initWithFrame:rectFrame
                                     configuration:configuration];
    } else webView = [[WKWebView alloc] initWithFrame:rectFrame];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    webView.autoresizesSubviews = YES;
    webView.allowsBackForwardNavigationGestures = YES;
    webView.scrollView.alwaysBounceVertical = YES;
    webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    if (delegate) {
        webView.navigationDelegate = delegate;
    }
    return webView;
}

- (WKNavigation *) ymLoadRequest : (NSString *) stringRequest {
    return [self loadRequest:[NSURLRequest requestWithURL:ymURL(stringRequest, false)]];
}

- (WKNavigation *) ymLoadHTMLString : (NSString *) stringHTML {
    if ([stringHTML isKindOfClass:[NSString class]])
        if (stringHTML.ymIsStringValued)
            return [self loadHTMLString:stringHTML
                                baseURL:nil];
    return nil;
}

@end
