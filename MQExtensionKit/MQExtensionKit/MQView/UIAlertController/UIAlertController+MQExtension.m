//
//  UIAlertController+MQExtension.m
//  MQExtensionKit
//
//  Created by 冯明庆 on 26/06/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "UIAlertController+MQExtension.h"
#import <objc/runtime.h>

@implementation UIAlertController (CCExtension)

+ (instancetype) mq_common {
    return [self mq_common:UIAlertControllerStyleAlert];
}
+ (instancetype) mq_common : (UIAlertControllerStyle) style {
    return [UIAlertController alertControllerWithTitle:nil
                                               message:nil
                                        preferredStyle:style];
}

- (instancetype) mq_title : (NSString *) sTitle {
    self.title = sTitle;
    return self;
}
- (instancetype) mq_message : (NSString *) sMessage {
    self.message = sMessage;
    return self;
}

- (instancetype) mq_action : (CCAlertActionInfo *) info
                    action : (void(^)( __kindof UIAlertAction *action)) action {
    CCAlertActionEntity *m = [[CCAlertActionEntity alloc] init];
    m.s_title = info[@"title"];
    m.style = (UIAlertActionStyle)[info[@"style"] integerValue];
    
    UIAlertAction *a = [UIAlertAction actionWithTitle:m.s_title
                                                style:m.style
                                              handler:action];
    a.action_m = m;
    if (a) [self addAction:a];
    return self;
}
- (instancetype) mq_action_s : (NSArray < CCAlertActionInfo *> *) array
                      action : (void(^)( __kindof UIAlertAction *action , NSUInteger index)) actionT {
    __weak typeof(self) pSelf = self;
    [array enumerateObjectsUsingBlock:^(CCAlertActionInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CCAlertActionEntity *m = [[CCAlertActionEntity alloc] init];
        m.s_title = obj[@"title"];
        m.style = (UIAlertActionStyle)[obj[@"style"] integerValue];
        
        UIAlertAction *a = [UIAlertAction actionWithTitle:m.s_title
                                                    style:m.style
                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                      if (actionT) actionT(action , idx);
                                                  }];
        a.action_m = m;
        if (a) [pSelf addAction:a];
    }];
    return pSelf;
}

CCAlertActionInfo * CCAlertActionInfoMake(NSString * title, UIAlertActionStyle style) {
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    [d setValue:title forKey:@"title"];
    [d setValue:@(style) forKey:@"style"];
    return d;
}

@end

#pragma mark - -----

@implementation CCAlertActionEntity
@end

#pragma mark - -----

@implementation UIAlertAction (CCExtension)

- (void)setAction_m:(CCAlertActionEntity *)action_m {
    objc_setAssociatedObject(self, @selector(action_m), action_m, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CCAlertActionEntity *)action_m {
    return objc_getAssociatedObject(self, _cmd);
}

@end
