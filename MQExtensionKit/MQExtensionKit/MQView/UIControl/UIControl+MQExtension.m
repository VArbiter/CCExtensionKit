//
//  UIControl+MQExtension.m
//  MQExtensionKit
//
//  Created by Elwinfrederick on 08/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "UIControl+MQExtension.h"

#import <objc/runtime.h>

static const char * MQ_UICONTROL_EXTENSION_CLICK_ASSOCIATE_KEY = "MQ_UICONTROL_EXTENSION_CLICK_ASSOCIATE_KEY";
static const char * MQ_UICONTROL_EVENT_DICTIONARY_STORED_KEY = "MQ_UICONTROL_EVENT_DICTIONARY_STORED_KEY";
static const char * MQ_UICONTROL_EVENT_STORED_KEY = "MQ_UICONTROL_EVENT_STORED_KEY";

@interface UIControl (MQExtension_Assit)

- (void) mq_control_extension_action : ( __kindof UIControl *) sender ;

@property (nonatomic , strong) NSMutableDictionary *dict_events ;
@property (nonatomic , assign) UIControlEvents event_control_assist ;
- (void) mq_control_extension_event_action : (__kindof UIControl *) sender ;

@end

@implementation UIControl (MQExtension_Assit)

- (void)setDict_events:(NSMutableDictionary *)dict_events {
    objc_setAssociatedObject(self, MQ_UICONTROL_EVENT_DICTIONARY_STORED_KEY, dict_events, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSMutableDictionary *)dict_events {
    NSMutableDictionary *d = objc_getAssociatedObject(self, MQ_UICONTROL_EVENT_DICTIONARY_STORED_KEY);
    if (d) return d;
    else {
        d = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, MQ_UICONTROL_EVENT_DICTIONARY_STORED_KEY, d, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return d;
}

- (void)setEvent_control_assist:(UIControlEvents)event_control_assist {
    objc_setAssociatedObject(self, MQ_UICONTROL_EVENT_STORED_KEY, @(event_control_assist), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UIControlEvents)event_control_assist {
    return [objc_getAssociatedObject(self, MQ_UICONTROL_EVENT_STORED_KEY) unsignedIntegerValue];
}

- (void) mq_control_extension_action : ( __kindof UIControl *) sender {
    void (^t)( __kindof UIControl *) = objc_getAssociatedObject(self, MQ_UICONTROL_EXTENSION_CLICK_ASSOCIATE_KEY);
    if (t) {
        if (NSThread.isMainThread) t(sender);
        else dispatch_sync(dispatch_get_main_queue(), ^{
            t(sender);
        });
    }
}

- (void) mq_control_extension_event_action : (__kindof UIControl *) sender {
    UIControlEvents events = self.event_control_assist;
    NSString *s = @"MQ_UICONTROL_EVENT_TRIGGER_ACTION_";
    s = [s stringByAppendingString:[NSString stringWithFormat:@"%@",@(events).stringValue]];
    void (^bEvent)(__kindof UIControl *sender) = self.dict_events[s];
    if (bEvent) bEvent(self);
}

@end

#pragma mark - -----
static const char * MQ_UIVIEW_ASSOCIATE_HITTEST_TOP_KEY = "MQ_UIVIEW_ASSOCIATE_HITTEST_TOP_KEY";
static const char * MQ_UIVIEW_ASSOCIATE_HITTEST_LEFT_KEY = "MQ_UIVIEW_ASSOCIATE_HITTEST_LEFT_KEY";
static const char * MQ_UIVIEW_ASSOCIATE_HITTEST_BOTTOM_KEY = "MQ_UIVIEW_ASSOCIATE_HITTEST_BOTTOM_KEY";
static const char * MQ_UIVIEW_ASSOCIATE_HITTEST_RIGHT_KEY = "MQ_UIVIEW_ASSOCIATE_HITTEST_RIGHT_KEY";

@implementation UIControl (MQExtension)

+ (instancetype) mq_common : (CGRect) frame {
    UIControl *c = [[self alloc] initWithFrame:frame];
    c.userInteractionEnabled = YES;
    return c;
}
/// actions , default is touchUpInside
- (instancetype) mq_actions : (void (^)( __kindof UIControl *sender)) action {
    return [self mq_target:self actions:action];
}
- (instancetype) mq_target : (id) target
                   actions : (void (^)( __kindof UIControl *sender)) action {
    objc_setAssociatedObject(self, MQ_UICONTROL_EXTENSION_CLICK_ASSOCIATE_KEY, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:target
              action:@selector(mq_control_extension_action:)
    forControlEvents:UIControlEventTouchUpInside];
    return self;
}
/// custom actions .
- (instancetype) mq_target : (id) target
                  selector : (SEL) sel
                    events : (UIControlEvents) events {
    [self addTarget:(target ? target : self)
              action:sel
    forControlEvents:events];
    return self;
}
/// increase trigger rect .
- (instancetype) mq_increase : (UIEdgeInsets) insets {
    objc_setAssociatedObject(self, MQ_UIVIEW_ASSOCIATE_HITTEST_TOP_KEY,
                             @(insets.top), OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, MQ_UIVIEW_ASSOCIATE_HITTEST_LEFT_KEY,
                             @(insets.left), OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, MQ_UIVIEW_ASSOCIATE_HITTEST_BOTTOM_KEY,
                             @(insets.bottom), OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, MQ_UIVIEW_ASSOCIATE_HITTEST_RIGHT_KEY,
                             @(insets.right), OBJC_ASSOCIATION_COPY_NONATOMIC);
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    __weak typeof(self) weak_self = self;
    CGRect (^t)(void) = ^CGRect {
        __strong typeof(weak_self) strong_self = weak_self;
        NSNumber * top = objc_getAssociatedObject(strong_self,
                                                  MQ_UIVIEW_ASSOCIATE_HITTEST_TOP_KEY);
        NSNumber * left = objc_getAssociatedObject(strong_self,
                                                   MQ_UIVIEW_ASSOCIATE_HITTEST_LEFT_KEY);
        NSNumber * bottom = objc_getAssociatedObject(strong_self,
                                                     MQ_UIVIEW_ASSOCIATE_HITTEST_BOTTOM_KEY);
        NSNumber * right = objc_getAssociatedObject(strong_self,
                                                    MQ_UIVIEW_ASSOCIATE_HITTEST_RIGHT_KEY);
        if (top && left && bottom && right) {
            return CGRectMake(strong_self.bounds.origin.x - left.floatValue,
                              strong_self.bounds.origin.y - top.floatValue,
                              strong_self.bounds.size.width + left.floatValue + right.floatValue,
                              strong_self.bounds.size.height + top.floatValue + bottom.floatValue);
        }
        else return strong_self.bounds;
    };
    
    CGRect rect = t();
    if (CGRectEqualToRect(rect, self.bounds)) return [super hitTest:point withEvent:event];
    return CGRectContainsPoint(rect, point) ? self : nil;
}

- (instancetype) mq_shared_control_event : (UIControlEvents) event
                                 actions : (void (^)( __kindof UIControl *sender)) action {
    if (!action) return self;
    NSString *s = [@"MQ_UICONTROL_EVENT_TRIGGER_ACTION_" stringByAppendingString:[NSString stringWithFormat:@"%@",@(event).stringValue]];
    
    [self.dict_events setValue:action forKey:s];
    self.event_control_assist = self.event_control_assist | event;
    
    [self addTarget:self
             action:@selector(mq_control_extension_event_action:)
   forControlEvents:event];
    return self;
}

- (instancetype) mq_remove_event : (UIControlEvents) event {
    if (self.event_control_assist & event) {
        NSString *s = @"MQ_UICONTROL_EVENT_TRIGGER_ACTION_";
        NSString *ts = [s stringByAppendingString:[NSString stringWithFormat:@"%@",@(self.event_control_assist).stringValue]];
        id t = self.dict_events[ts];
        self.event_control_assist = self.event_control_assist & (~event);
        NSString *te = [s stringByAppendingString:[NSString stringWithFormat:@"%@",@(self.event_control_assist).stringValue]];
        [self.dict_events setValue:t forKey:te];
        [self removeTarget:self
                    action:@selector(mq_control_extension_event_action:)
          forControlEvents:event];
    }
    return self;
}

@end
