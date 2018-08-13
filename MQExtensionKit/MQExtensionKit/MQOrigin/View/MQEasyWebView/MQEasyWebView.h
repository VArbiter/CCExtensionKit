//
//  MQEasyWebView.h
//  MQExtensionKit
//
//  Created by Elwinfrederick on 14/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "WKWebView+MQExtension.h"

@interface MQEasyWebView : UIView

- (instancetype) init : (CGRect) frame
        configuration : (WKWebViewConfiguration *) configuration;

@property (nonatomic , strong) WKWebView *webView ;

/// (CGRect){0,0,Screen Width , 2} , superview : webView // 坐标是 webView 的 0,0 屏宽 , 高度为 2 .
/// alpha will be .0 when progress reach 1.f
@property (nonatomic , strong) UIProgressView *progressView;

// a chain bridge for WKNavigationDelegate // 用来桥接 WKNavigationDelegate

/// default is YES , allow all challenges . // 默认为 YES , 允许所有验证
@property (nonatomic , assign) BOOL isTrustWithoutAnyDoubt;

/// if webview receive a auth challenge // 如果 webView 收到一个验证
/// note : if not implemented 'mq_deal_auth_challenge' , // 如果没有实现 'mq_deal_auth_challenge'
/// webview will trust certificate without any doubt . (non process will be done) // webView 将会无条件信任这个证书
- (instancetype) mq_deal_auth_challenge : (void (^)(WKWebView *webView , NSURLAuthenticationChallenge * challenge,
                                                    void (^completionHandler)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * credential))) challenge ;

/// if decidedByUser was implemented . // 如果实现了 decidedByUser
/// then the choice of whether trust a certificate or not , was decided by users . // 用户将有权决定是否信任这个证书
/// note : use modal to presented a UIAlertController . // 使用 模态来展示 UIAlertController
- (instancetype) mq_decided_by_user : (NSString *) sAppName
                              alert :  (void (^)(UIAlertController *controller)) alert ;

- (instancetype) mq_policy_for_action : (WKNavigationActionPolicy(^)(WKNavigationAction * action)) decision ;
- (instancetype) mq_policy_for_response : (WKNavigationResponsePolicy(^)(WKNavigationResponse *response)) decision ;
- (instancetype) mq_did_commit : (void (^)(WKWebView *webView , WKNavigation *navigation)) commit ;
- (instancetype) mq_did_start : (void (^)(WKWebView *webView , WKNavigation *navigation)) start ;
- (instancetype) mq_fail_provisional : (void (^)(WKWebView *webView , WKNavigation *navigation , NSError * error)) provisional ;
- (instancetype) mq_receive_redirect : (void (^)(WKWebView *webView , WKNavigation *navigation)) redirect ;
- (instancetype) mq_did_finish : (void (^)(WKWebView *webView , WKNavigation *navigation)) finish ;
- (instancetype) mq_did_fail : (void (^)(WKWebView *webView , WKNavigation *navigation , NSError * error)) fail ;

// chain for loading , only "http://" && "https://" will be loaded online // 用来加载 , 只有 http:// 和 https:// 将会被用于线上
// others will be loaded as html content . // 其它的会被当做是 html 文本来加载
// nil to do nothing // nil 什么也不做

- (instancetype) mq_load : (NSString *) sContent
              navigation : (void (^)(WKNavigation *navigation)) navigation ;

/// pushing the loading progress of current page . // 推送当前页面加载进度
- (instancetype) mq_loading_progress : (void (^)(double progress)) progress ;

// simple two-ways interact with JaveScript && Native in webview. // 简易的 webView 双向加载 (JaveScript <-> Native)

/// Can invoke it for muti times . // 可以多次调用
/// invoke nil for message block to unregist a recall // 对 message block 传 nil 去取消一个注册
- (instancetype) mq_script : (NSString *) sKey
                   message : (void (^)(WKUserContentController * userContentController, WKScriptMessage *message)) message ;

@end
