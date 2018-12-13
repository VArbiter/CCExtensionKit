//
//  UIAlertController+MQExtension.m
//  MQExtensionKit
//
//  Created by 冯明庆 on 26/06/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "UIAlertController+MQExtension.h"
#import <objc/runtime.h>

@implementation UIAlertController (MQExtension)

+ (instancetype) mq_common {
    return [self mq_common:UIAlertControllerStyleAlert];
}
+ (instancetype) mq_common : (UIAlertControllerStyle) style {
    return [UIAlertController alertControllerWithTitle:nil
                                               message:nil
                                        preferredStyle:style];
}

- (instancetype) mq_title : (NSString *) s_title {
    self.title = s_title;
    return self;
}
- (instancetype) mq_message : (NSString *) s_message {
    self.message = s_message;
    return self;
}

- (instancetype) mq_action : (MQAlertActionInfo *) info
                    action : (void(^)( __kindof UIAlertAction *action)) action {
    MQAlertActionEntity *m = [[MQAlertActionEntity alloc] init];
    m.s_title = info[@"title"];
    m.style = (UIAlertActionStyle)[info[@"style"] integerValue];
    
    UIAlertAction *a = [UIAlertAction actionWithTitle:m.s_title
                                                style:m.style
                                              handler:action];
    a.action_m = m;
    if (a) [self addAction:a];
    return self;
}
- (instancetype) mq_action_s : (NSArray < MQAlertActionInfo *> *) array
                      action : (void(^)( __kindof UIAlertAction *action , NSUInteger index)) action {
    __weak typeof(self) weak_self = self;
    [array enumerateObjectsUsingBlock:^(MQAlertActionInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(weak_self) strong_self = weak_self;
        MQAlertActionEntity *m = [[MQAlertActionEntity alloc] init];
        m.s_title = obj[@"title"];
        m.style = (UIAlertActionStyle)[obj[@"style"] integerValue];
        
        UIAlertAction *a = [UIAlertAction actionWithTitle:m.s_title
                                                    style:m.style
                                                  handler:^(UIAlertAction * _Nonnull action_t) {
                                                      if (action) action(action_t , idx);
                                                  }];
        a.action_m = m;
        if (a) [strong_self addAction:a];
    }];
    return self;
}

MQAlertActionInfo * MQAlertActionInfoMake(NSString * title, UIAlertActionStyle style) {
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    [d setValue:title forKey:@"title"];
    [d setValue:@(style) forKey:@"style"];
    return d;
}

@end

#pragma mark - -----

@implementation MQAlertActionEntity
@end

#pragma mark - -----

@implementation UIAlertAction (MQExtension)

- (void)setAction_m:(MQAlertActionEntity *)action_m {
    objc_setAssociatedObject(self, @selector(action_m), action_m, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (MQAlertActionEntity *)action_m {
    return objc_getAssociatedObject(self, _cmd);
}

@end
