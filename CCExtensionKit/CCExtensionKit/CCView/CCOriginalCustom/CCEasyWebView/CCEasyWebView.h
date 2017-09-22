//
//  CCEasyWebView.h
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 14/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "WKWebView+CCExtension.h"

@interface CCEasyWebView : NSObject

- (instancetype) init NS_UNAVAILABLE ;

+ (instancetype) common : (CGRect) frame ;
+ (instancetype) common : (CGRect) frame
          configuration : (WKWebViewConfiguration *) configuration ;

@property (nonatomic , strong) WKWebView *webView ;

/// (CGRect){0,0,Screen Width , 2} , superview : webView
/// alpha will be .0 when progress reach 1.f
@property (nonatomic , strong) UIProgressView *progressView;

// a chain bridge for WKNavigationDelegate

/// default is YES , allow all challenges .
- (instancetype) ccAuthChallenge : (BOOL) isWithoutAnyDoubt ;

/// if webview receive a auth challenge
/// note : if not implemented 'ccDealAuthChallenge' ,
/// webview will trust certificate without any doubt . (non process will be done)
- (instancetype) ccDealAuthChallenge : (void (^)(WKWebView *webView , NSURLAuthenticationChallenge * challenge,
                                                 void (^completionHandler)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * credential))) challenge ;

/// if decidedByUser was implemented .
/// then the choice of whether trust a certificate or not , was decided by users .
/// note : use modal to presented a alertcontroller .
- (instancetype) ccDecidedByUser : (NSString *) sAppName
                           alert :  (void (^)(UIAlertController *controller)) alert ;

- (instancetype) ccPolicyForAction : (WKNavigationActionPolicy(^)(WKNavigationAction * action)) decision ;
- (instancetype) ccPolicyForResponse : (WKNavigationResponsePolicy(^)(WKNavigationResponse *response)) decision ;
- (instancetype) ccDidCommit : (void (^)(WKWebView *webView , WKNavigation *navigation)) commit ;
- (instancetype) ccDidStart : (void (^)(WKWebView *webView , WKNavigation *navigation)) start ;
- (instancetype) ccFailProvisional : (void (^)(WKWebView *webView , WKNavigation *navigation , NSError * error)) provisional ;
- (instancetype) ccReceiveRedirect : (void (^)(WKWebView *webView , WKNavigation *navigation)) redirect ;
- (instancetype) ccDidFinish : (void (^)(WKWebView *webView , WKNavigation *navigation)) finish ;
- (instancetype) ccDidFail : (void (^)(WKWebView *webView , WKNavigation *navigation , NSError * error)) fail ;

// chain for loading , only "http://" && "https://" will be loaded online
// others will be loaded as html content .
// nil to do nothing

- (instancetype) ccLoad : (NSString *) sContent
             navigation : (void (^)(WKNavigation *navigation)) navigation ;

/// pushing the loading progress of current page .
- (instancetype) ccLoadingProgress : (void (^)(double progress)) progress ;

// simple two-ways interact with JaveScript && Native in webview.

/// Can deploy it for muti times .
/// deploy nil for message block to unregist a recall
- (instancetype) ccScript : (NSString *) sKey
                  message : (void (^)(WKUserContentController * userContentController, WKScriptMessage *message)) message ;

@end
