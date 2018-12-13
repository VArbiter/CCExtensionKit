//
//  MQEasyWebView.m
//  MQExtensionKit
//
//  Created by Elwinfrederick on 14/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "MQEasyWebView.h"

@interface MQEasyWebView () <WKNavigationDelegate , WKScriptMessageHandler>

@property (nonatomic , strong) WKWebViewConfiguration * config;
@property (nonatomic , strong) WKUserContentController *user_content_controller ;
@property (nonatomic , strong) MQScriptMessageDelegate *message_delegate ;

@property (nonatomic , copy) NSString *s_app_name ;
@property (nonatomic , copy) void (^challenge)(WKWebView *web_view ,
NSURLAuthenticationChallenge * challenge,
void (^completionHandler)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * credential));
@property (nonatomic , copy) void (^alert_block)(UIAlertController *controller);

@property (nonatomic , strong) NSMutableDictionary <NSString * , void (^)(WKUserContentController *, WKScriptMessage *)> *dictionary_message ;

@property (nonatomic , copy) void (^progress)(double);
@property (nonatomic , copy) WKNavigationActionPolicy (^decision)(WKNavigationAction * action);
@property (nonatomic , copy) WKNavigationResponsePolicy (^decision_block)(WKNavigationResponse *response);
@property (nonatomic , copy) void (^commit)(WKWebView *web_view , WKNavigation *navigation);
@property (nonatomic , copy) void (^start)(WKWebView *web_view , WKNavigation *navigation);
@property (nonatomic , copy) void (^provisional)(WKWebView *web_view , WKNavigation *navigation , NSError * error);
@property (nonatomic , copy) void (^redirect)(WKWebView *web_view , WKNavigation *navigation);
@property (nonatomic , copy) void (^finish)(WKWebView *web_view , WKNavigation *navigation);
@property (nonatomic , copy) void (^fail)(WKWebView *web_view , WKNavigation *navigation , NSError * error);

@end

@implementation MQEasyWebView

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.is_trust_without_any_doubt = YES;
    }
    return self;
}

- (instancetype) init : (CGRect) frame
        configuration : (WKWebViewConfiguration *) configuration {
    if ((self = [super initWithFrame:frame])) {
        self.config = configuration;
        self.is_trust_without_any_doubt = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self addSubview:self.web_view];
    [self.web_view addSubview:self.progress_view];
}

- (instancetype) mq_deal_auth_challenge : (void (^)(WKWebView *web_view , NSURLAuthenticationChallenge * challenge,
                                                 void (^completion_handler)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * credential))) challenge {
    if (challenge) self.challenge = [challenge copy];
    return self;
}

- (instancetype) mq_decided_by_user : (NSString *) s_app_name
                           alert :  (void (^)(UIAlertController *controller)) alert {
    if (alert) {
        self.s_app_name = s_app_name;
        self.alert_block = [alert copy];
    }
    return self;
}

- (instancetype) mq_policy_for_action : (WKNavigationActionPolicy(^)(WKNavigationAction * action)) decision {
    if (decision) self.decision = [decision copy];
    return self;
}
- (instancetype) mq_policy_for_response : (WKNavigationResponsePolicy(^)(WKNavigationResponse *response)) decision {
    if (decision) self.decision_block = [decision copy];
    return self;
}
- (instancetype) mq_did_commit : (void (^)(WKWebView *web_view , WKNavigation *navigation)) commit {
    if (commit) self.commit = [commit copy];
    return self;
}
- (instancetype) mq_did_start : (void (^)(WKWebView *web_view , WKNavigation *navigation)) start {
    if (start) self.start = [start copy];
    return self;
}
- (instancetype) mq_fail_provisional : (void (^)(WKWebView *web_view , WKNavigation *navigation , NSError * error)) provisional {
    if (provisional) self.provisional = [provisional copy];
    return self;
}
- (instancetype) mq_receive_redirect : (void (^)(WKWebView *web_view , WKNavigation *navigation)) redirect {
    if (redirect) self.redirect = [redirect copy];
    return self;
}
- (instancetype) mq_did_finish : (void (^)(WKWebView *web_view , WKNavigation *navigation)) finish {
    if (finish) self.finish = [finish copy];
    return self;
}
- (instancetype) mq_did_fail : (void (^)(WKWebView *web_view , WKNavigation *navigation , NSError * error)) fail {
    if (fail) self.fail = [fail copy];
    return self;
}

- (instancetype) mq_load : (NSString *) s_content
              navigation : (void (^)(WKNavigation *navigation)) navigation {
    if (s_content && s_content.length) {
        WKNavigation *n = nil;
        if ([s_content hasPrefix:@"http://"] || [s_content hasPrefix:@"https://"]) {
            n = [self.web_view loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:s_content]]];
        } else [self.web_view loadHTMLString:s_content baseURL:nil];
        if (n && navigation) navigation(n);
    }
    return self;
}

- (instancetype) mq_loading_progress : (void (^)(double progress)) progress {
    if (progress) self.progress = [progress copy];
    return self;
}

- (instancetype) mq_script : (NSString *) s_key
                   message : (void (^)(WKUserContentController * user_content_controller, WKScriptMessage *message)) message {
    if (!message && s_key && s_key.length) {
        [self.user_content_controller removeScriptMessageHandlerForName:s_key];
        [self.dictionary_message removeObjectForKey:s_key];
    }
    else if (s_key && s_key.length) {
        [self.user_content_controller addScriptMessageHandler:self.message_delegate
                                                       name:s_key];
        [self.dictionary_message setValue:message
                                  forKey:s_key];
    }
    return self;
}

#pragma mark - -----

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    /// trust without any doubt .
    
    void (^t)(void) = ^ {
        NSString *s_authentication_method = [[challenge protectionSpace] authenticationMethod];
        if ([s_authentication_method isEqualToString:NSURLAuthenticationMethodServerTrust]) {
            NSURLCredential *credential = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
        }
    };
    
    if (self.is_trust_without_any_doubt) {
        if (t) t();
        return;
    }
    
    if (self.challenge) {
        self.challenge(webView, challenge, completionHandler);
        return;
    }
    
    if (!self.alert_block) { if (t) t() ; return ; }
    
    NSString *host_name = webView.URL.host;
    NSString *s_authentication_method = [[challenge protectionSpace] authenticationMethod];
    if ([s_authentication_method isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        SecTrustRef sec_trust_ref = challenge.protectionSpace.serverTrust;
        if (sec_trust_ref != NULL) {
            SecTrustResultType result;
            OSErr er = SecTrustEvaluate(sec_trust_ref, &result);
            if (er != noErr) {
                completionHandler(NSURLSessionAuthChallengeRejectProtectionSpace,nil);
                return;
            }
            
            if (result == kSecTrustResultRecoverableTrustFailure) {
                /// certificate can't be trusted
                CFArrayRef sec_trust_properties = SecTrustCopyProperties(sec_trust_ref);
                NSArray *arr = CFBridgingRelease(sec_trust_properties);
                NSMutableString *error_str = [NSMutableString string];
                
                for (int i = 0;i < arr.count; i++){
                    NSDictionary *dic = [arr objectAtIndex:i];
                    if (i != 0) [error_str appendString:@" "];
                    [error_str appendString:(NSString *)dic[@"value"]];
                }
                SecCertificateRef cert_ref = SecTrustGetCertificateAtIndex(sec_trust_ref, 0);
                CFStringRef cf_cert_summary_ref =  SecCertificateCopySubjectSummary(cert_ref);
                NSString *cert_summary = (NSString *)CFBridgingRelease(cf_cert_summary_ref);
                NSString *title = @"This server can not be trusted.";
                
                NSString *message = [NSString stringWithFormat:@"receive a host challenge %@ from %@ , certificate summary : %@ .\n%@" , host_name , self.s_app_name , cert_summary , error_str];;
                UIAlertController *alert_controller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
                [alert_controller addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction *action) {
                                                                      completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);}]];
                
                [alert_controller addAction:[UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    NSURLCredential* credential = [NSURLCredential credentialForTrust:sec_trust_ref];
                    completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
                }]];
                
                __weak typeof(self) weak_self = self;
                dispatch_async(dispatch_get_main_queue(), ^{ // async , has to do it on main thread
                    __strong typeof(weak_self) strong_self = weak_self;
                    if (strong_self.alert_block) strong_self.alert_block(alert_controller);
                });
                return;
            }
            
            NSURLCredential* credential = [NSURLCredential credentialForTrust:sec_trust_ref];
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
    if (self.decision_block) {
        decisionHandler(self.decision_block(navigationResponse));
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
    void (^t)(WKUserContentController *, WKScriptMessage *) = self.dictionary_message[message.name];
    if (t) t(userContentController , message);
}

#pragma mark - -----

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.web_view && [keyPath isEqualToString:@"estimatedProgress"]) {
        if (self.progress) self.progress(self.web_view.estimatedProgress);
        [self.progress_view setAlpha:1.0f];
        [self.progress_view setProgress:self.web_view.estimatedProgress
                              animated:YES];
        if(self.web_view.estimatedProgress >= 1.0f)
            [UIView animateWithDuration:0.3
                                  delay:0.3
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 [self.progress_view setAlpha:0.0f];
                             } completion:^(BOOL finished) {
                                 [self.progress_view setProgress:0.0f
                                                       animated:NO];
                             }];
    }
    else [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

#pragma mark - -----
- (NSMutableDictionary<NSString *,void (^)(WKUserContentController *, WKScriptMessage *)> *)dictionary_message {
    if (_dictionary_message) return _dictionary_message;
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    _dictionary_message = d;
    return _dictionary_message;
}

- (WKWebView *)web_view{
    if (_web_view) return _web_view;
    if (!self.config) {
        WKWebViewConfiguration * c = [[WKWebViewConfiguration alloc] init];
        if (@available(iOS 9.0, *)) {
            c.allowsAirPlayForMediaPlayback = YES;
        }
        c.allowsInlineMediaPlayback = YES;
        c.selectionGranularity = YES;
        c.processPool = [[WKProcessPool alloc] init];
        c.userContentController = self.user_content_controller;
        self.config = c;
    }
    else self.config.userContentController = self.user_content_controller;
    
    WKWebView *v = [[WKWebView alloc] initWithFrame:(CGRect){0,0,self.frame.size.width,self.frame.size.height}
                                      configuration:self.config];
    v.navigationDelegate = self;
    _web_view = v;
    
    [_web_view addObserver:self
                forKeyPath:@"estimatedProgress"
                   options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                   context:nil];
    
    return _web_view;
}

- (UIProgressView *)progress_view {
    if (_progress_view) return _progress_view;
    UIProgressView *v = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    v.frame = (CGRect){0,0, self.frame.size.width , 2};
    _progress_view = v;
    return _progress_view;
}

- (WKUserContentController *)user_content_controller {
    if (_user_content_controller) return _user_content_controller;
    WKUserContentController *c = [[WKUserContentController alloc] init];
    _user_content_controller = c;
    return _user_content_controller;
}

- (MQScriptMessageDelegate *)message_delegate {
    if (_message_delegate) return _message_delegate;
    MQScriptMessageDelegate *delegate = [[MQScriptMessageDelegate alloc] init:self];
    _message_delegate = delegate;
    return _message_delegate;
}

- (void)dealloc {
#if DEBUG
    NSLog(@"\n_MQ_%@_DEALLOC_",NSStringFromClass(self.class));
#endif
    [self.web_view removeObserver:self
                       forKeyPath:@"estimatedProgress"
                          context:nil];
}

@end
