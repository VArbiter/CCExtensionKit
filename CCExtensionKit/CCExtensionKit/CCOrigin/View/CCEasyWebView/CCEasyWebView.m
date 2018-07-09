//
//  CCEasyWebView.m
//  CCExtensionKit
//
//  Created by Elwinfrederick on 14/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "CCEasyWebView.h"

@interface CCEasyWebView () <WKNavigationDelegate , WKScriptMessageHandler>

@property (nonatomic , strong) WKWebViewConfiguration * config;
@property (nonatomic , assign) CGRect frame ;
@property (nonatomic , strong) WKUserContentController *userContentController ;
@property (nonatomic , strong) CCScriptMessageDelegate *messageDelegate ;

@property (nonatomic , copy) NSString *sAppName ;
@property (nonatomic , assign) BOOL isTrustWithoutAnyDoubt;
@property (nonatomic , copy) void (^challenge)(WKWebView *webView ,
NSURLAuthenticationChallenge * challenge,
void (^completionHandler)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * credential));
@property (nonatomic , copy) void (^alertS)(UIAlertController *controller);

@property (nonatomic , strong) NSMutableDictionary <NSString * , void (^)(WKUserContentController *, WKScriptMessage *)> *dictionaryMessage ;

- (instancetype) init : (CGRect) frame ;

- (instancetype) init : (CGRect) frame
        configuration : (WKWebViewConfiguration *) configuration NS_DESIGNATED_INITIALIZER;

@property (nonatomic , copy) void (^progress)(double);
@property (nonatomic , copy) WKNavigationActionPolicy (^decision)(WKNavigationAction * action);
@property (nonatomic , copy) WKNavigationResponsePolicy (^decisionR)(WKNavigationResponse *response);
@property (nonatomic , copy) void (^commit)(WKWebView *webView , WKNavigation *navigation);
@property (nonatomic , copy) void (^start)(WKWebView *webView , WKNavigation *navigation);
@property (nonatomic , copy) void (^provisional)(WKWebView *webView , WKNavigation *navigation , NSError * error);
@property (nonatomic , copy) void (^redirect)(WKWebView *webView , WKNavigation *navigation);
@property (nonatomic , copy) void (^finish)(WKWebView *webView , WKNavigation *navigation);
@property (nonatomic , copy) void (^fail)(WKWebView *webView , WKNavigation *navigation , NSError * error);

@end

@implementation CCEasyWebView

+ (instancetype) cc_common : (CGRect) frame {
    return [self cc_common:frame configuration:nil];
}
+ (instancetype) cc_common : (CGRect) frame
             configuration : (WKWebViewConfiguration *) configuration {
    return [[self alloc] init:frame configuration:configuration];
}

- (instancetype) init : (CGRect) frame {
    return [self init:frame configuration:nil];
}

- (instancetype) init : (CGRect) frame
        configuration : (WKWebViewConfiguration *) configuration {
    if ((self = [super init])) {
        self.frame = frame;
        self.config = configuration;
        self.isTrustWithoutAnyDoubt = YES;
        [self.webView addSubview:self.progressView];
    }
    return self;
}

- (instancetype) cc_auth_challenge : (BOOL) isWithoutAnyDoubt {
    self.isTrustWithoutAnyDoubt = isWithoutAnyDoubt;
    return self;
}

- (instancetype) cc_deal_auth_challenge : (void (^)(WKWebView *webView , NSURLAuthenticationChallenge * challenge,
                                                 void (^completionHandler)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * credential))) challenge {
    if (challenge) self.challenge = [challenge copy];
    return self;
}

- (instancetype) cc_decided_by_user : (NSString *) sAppName
                           alert :  (void (^)(UIAlertController *controller)) alert {
    if (alert) {
        self.sAppName = sAppName;
        self.alertS = [alert copy];
    }
    return self;
}

- (instancetype) cc_policy_for_action : (WKNavigationActionPolicy(^)(WKNavigationAction * action)) decision {
    if (decision) self.decision = [decision copy];
    return self;
}
- (instancetype) cc_policy_for_response : (WKNavigationResponsePolicy(^)(WKNavigationResponse *response)) decision {
    if (decision) self.decisionR = [decision copy];
    return self;
}
- (instancetype) cc_did_commit : (void (^)(WKWebView *webView , WKNavigation *navigation)) commit {
    if (commit) self.commit = [commit copy];
    return self;
}
- (instancetype) cc_did_start : (void (^)(WKWebView *webView , WKNavigation *navigation)) start {
    if (start) self.start = [start copy];
    return self;
}
- (instancetype) cc_fail_provisional : (void (^)(WKWebView *webView , WKNavigation *navigation , NSError * error)) provisional {
    if (provisional) self.provisional = [provisional copy];
    return self;
}
- (instancetype) cc_receive_redirect : (void (^)(WKWebView *webView , WKNavigation *navigation)) redirect {
    if (redirect) self.redirect = [redirect copy];
    return self;
}
- (instancetype) cc_did_finish : (void (^)(WKWebView *webView , WKNavigation *navigation)) finish {
    if (finish) self.finish = [finish copy];
    return self;
}
- (instancetype) cc_did_fail : (void (^)(WKWebView *webView , WKNavigation *navigation , NSError * error)) fail {
    if (fail) self.fail = [fail copy];
    return self;
}

- (instancetype) cc_load : (NSString *) sContent
              navigation : (void (^)(WKNavigation *navigation)) navigation {
    if (sContent && sContent.length) {
        WKNavigation *n = nil;
        if ([sContent hasPrefix:@"http://"] || [sContent hasPrefix:@"https://"]) {
            n = [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:sContent]]];
        } else [self.webView loadHTMLString:sContent baseURL:nil];
        if (n && navigation) navigation(n);
    }
    return self;
}

- (instancetype) cc_loading_progress : (void (^)(double progress)) progress {
    if (progress) self.progress = [progress copy];
    return self;
}

- (instancetype) cc_script : (NSString *) sKey
                   message : (void (^)(WKUserContentController * userContentController, WKScriptMessage *message)) message {
    if (sKey && sKey.length) {
        [self.userContentController addScriptMessageHandler:self.messageDelegate
                                                       name:sKey];
        [self.dictionaryMessage setValue:message
                                  forKey:sKey];
    }
    else if (!message && sKey && sKey.length) {
        [self.userContentController removeScriptMessageHandlerForName:sKey];
        [self.dictionaryMessage removeObjectForKey:sKey];
    }
    return self;
}

#pragma mark - -----

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    /// trust without any doubt .
    
    void (^t)(void) = ^ {
        NSString *stringAuthenticationMethod = [[challenge protectionSpace] authenticationMethod];
        if ([stringAuthenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
            NSURLCredential *credential = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
        }
    };
    
    if (self.isTrustWithoutAnyDoubt) {
        if (t) t();
        return;
    }
    
    if (self.challenge) {
        self.challenge(webView, challenge, completionHandler);
        return;
    }
    
    if (!self.alertS) { if (t) t() ; return ; }
    
    NSString *hostName = webView.URL.host;
    NSString *authenticationMethod = [[challenge protectionSpace] authenticationMethod];
    if ([authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        SecTrustRef secTrustRef = challenge.protectionSpace.serverTrust;
        if (secTrustRef != NULL) {
            SecTrustResultType result;
            OSErr er = SecTrustEvaluate(secTrustRef, &result);
            if (er != noErr) {
                completionHandler(NSURLSessionAuthChallengeRejectProtectionSpace,nil);
                return;
            }
            
            if (result == kSecTrustResultRecoverableTrustFailure) {
                /// certificate can't be trusted
                CFArrayRef secTrustProperties = SecTrustCopyProperties(secTrustRef);
                NSArray *arr = CFBridgingRelease(secTrustProperties);
                NSMutableString *errorStr = [NSMutableString string];
                
                for (int i = 0;i < arr.count; i++){
                    NSDictionary *dic = [arr objectAtIndex:i];
                    if (i != 0) [errorStr appendString:@" "];
                    [errorStr appendString:(NSString *)dic[@"value"]];
                }
                SecCertificateRef certRef = SecTrustGetCertificateAtIndex(secTrustRef, 0);
                CFStringRef cfCertSummaryRef =  SecCertificateCopySubjectSummary(certRef);
                NSString *certSummary = (NSString *)CFBridgingRelease(cfCertSummaryRef);
                NSString *title = @"This server can not be trusted.";
                
                NSString *message = [NSString stringWithFormat:@"receive a host challenge %@ from %@ , certificate summary : %@ .\n%@" , hostName , self.sAppName , certSummary , errorStr];;
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction *action) {
                                                                      completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);}]];
                
                [alertController addAction:[UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    NSURLCredential* credential = [NSURLCredential credentialForTrust:secTrustRef];
                    completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
                }]];
                
                __weak typeof(self) pSelf = self;
                dispatch_async(dispatch_get_main_queue(), ^{ // async , has to do it on main thread
                    if (pSelf.alertS) pSelf.alertS(alertController);
                });
                return;
            }
            
            NSURLCredential* credential = [NSURLCredential credentialForTrust:secTrustRef];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
            return;
        }
        completionHandler(NSURLSessionAuthChallengeRejectProtectionSpace, nil);
    }
    else completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if (self.decision) {
        decisionHandler(self.decision(navigationAction));
    } else decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    if (self.decisionR) {
        decisionHandler(self.decisionR(navigationResponse));
    } else decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    if (self.commit) self.commit(webView, navigation);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    if (self.start) self.start(webView, navigation);
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    if (self.provisional) self.provisional(webView, navigation, error);
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    if (self.redirect) self.redirect(webView, navigation);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    if (self.finish) self.finish(webView, navigation);
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    if (self.fail) self.fail(webView, navigation, error);
}

#pragma mark - -----
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    void (^t)(WKUserContentController *, WKScriptMessage *) = self.dictionaryMessage[message.name];
    if (t) t(userContentController , message);
}

#pragma mark - -----

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        if (self.progress) self.progress(self.webView.estimatedProgress);
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:self.webView.estimatedProgress
                              animated:YES];
        if(self.webView.estimatedProgress >= 1.0f)
            [UIView animateWithDuration:0.3
                                  delay:0.3
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 [self.progressView setAlpha:0.0f];
                             } completion:^(BOOL finished) {
                                 [self.progressView setProgress:0.0f
                                                       animated:NO];
                             }];
    }
    else [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

#pragma mark - -----
- (NSMutableDictionary<NSString *,void (^)(WKUserContentController *, WKScriptMessage *)> *)dictionaryMessage {
    if (_dictionaryMessage) return _dictionaryMessage;
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    _dictionaryMessage = d;
    return _dictionaryMessage;
}

- (WKWebView *)webView{
    if (_webView) return _webView;
    if (!self.config) {
        WKWebViewConfiguration * c = [[WKWebViewConfiguration alloc] init];
        if (UIDevice.currentDevice.systemVersion.floatValue >= 9.f) {
            c.allowsAirPlayForMediaPlayback = YES;
        }
        c.allowsInlineMediaPlayback = YES;
        c.selectionGranularity = YES;
        c.processPool = [[WKProcessPool alloc] init];
        c.userContentController = self.userContentController;
        self.config = c;
    }
    else self.config.userContentController = self.userContentController;
    
    WKWebView *v = [[WKWebView alloc] initWithFrame:(CGRect){0,0,self.frame.size.width,self.frame.size.height}
                                      configuration:self.config];
    v.navigationDelegate = self;
    _webView = v;
    
    [_webView addObserver:self
               forKeyPath:@"estimatedProgress"
                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                  context:nil];
    
    return _webView;
}

- (UIProgressView *)progressView {
    if (_progressView) return _progressView;
    UIProgressView *v = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    v.frame = (CGRect){0,0, self.frame.size.width , 2};
    _progressView = v;
    return _progressView;
}

- (WKUserContentController *)userContentController {
    if (_userContentController) return _userContentController;
    WKUserContentController *c = [[WKUserContentController alloc] init];
    _userContentController = c;
    return _userContentController;
}

- (CCScriptMessageDelegate *)messageDelegate {
    if (_messageDelegate) return _messageDelegate;
    CCScriptMessageDelegate *delegate = [[CCScriptMessageDelegate alloc] init:self];
    _messageDelegate = delegate;
    return _messageDelegate;
}

- (void)dealloc {
#if DEBUG
    NSLog(@"\n_CC_%@_DEALLOC_",NSStringFromClass(self.class));
#endif
    [self.webView removeObserver:self
                      forKeyPath:@"estimatedProgress"
                         context:nil];
}

@end
