//
//  WKWebView+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <WebKit/WebKit.h>

@class  CCScriptMessageDelegate;

@interface WKWebView (CCExtension)

+ (instancetype) common : (CGRect) frame;
+ (instancetype) common : (CGRect) frame
          configuration : (WKWebViewConfiguration *) configuration ;
- (instancetype) ccNavigationDelegate : (id <WKNavigationDelegate>) delegate ;
- (instancetype) ccScript : (CCScriptMessageDelegate *) delegate
                      key : (NSString *) sKey;

/// Only "http://" && "https://" will be loaded online . // 只有 "http://" && "https://" 会被当做网址
/// others will be loading as HTML content . // 其它的会被当做 HTML 文本
- (instancetype) ccLoading : (NSString *) sLink
                navigation : (void (^)(WKNavigation *navigation)) navigation ;
/// loading as links // 使用 网页加载
- (instancetype) ccRequest : (NSString *) sLink
                navigation : (void (^)(WKNavigation *navigation)) navigation ;
/// loading as HTML content // 使用 HTML 文本加载
- (instancetype) ccContent : (NSString *) content
                navigation : (void (^)(WKNavigation *navigation)) navigation ;

@end

#pragma mark - -----

@interface CCScriptMessageDelegate : NSObject < WKScriptMessageHandler >

@property (nonatomic , assign) id < WKScriptMessageHandler > scriptDelegate;

- (instancetype) init:(id < WKScriptMessageHandler > ) scriptDelegate;

@end
