//
//  UIControl+CCExtension.m
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 08/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "UIControl+CCExtension.h"

#import <objc/runtime.h>

static const char * _CC_UICONTROL_EXTENSION_CLICK_ASSOCIATE_KEY_ = "CC_UICONTROL_EXTENSION_CLICK_ASSOCIATE_KEY";
static const char * _CC_UICONTROL_EVENT_DICTIONARY_STORED_KEY_ = "CC_UICONTROL_EVENT_DICTIONARY_STORED_KEY";
static const char * _CC_UICONTROL_EVENT_STORED_KEY_ = "CC_UICONTROL_EVENT_STORED_KEY";

@interface UIControl (CCExtension_Assit)

- (void) ccControlExtensionAction : ( __kindof UIControl *) sender ;

@property (nonatomic , strong) NSMutableDictionary *dEvent ;
@property (nonatomic , assign) UIControlEvents eventControlAssist ;
- (void) ccControlExtensionEventAction : (__kindof UIControl *) sender ;

@end

@implementation UIControl (CCExtension_Assit)

- (void)setDEvent:(NSMutableDictionary *)dEvent {
    objc_setAssociatedObject(self, _CC_UICONTROL_EVENT_DICTIONARY_STORED_KEY_, dEvent, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSMutableDictionary *)dEvent {
    NSMutableDictionary *d = objc_getAssociatedObject(self, _CC_UICONTROL_EVENT_DICTIONARY_STORED_KEY_);
    if (d) return d;
    else {
        d = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, _CC_UICONTROL_EVENT_DICTIONARY_STORED_KEY_, d, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return d;
}

- (void)setEventControlAssist:(UIControlEvents)eventControlAssist {
    objc_setAssociatedObject(self, _CC_UICONTROL_EVENT_STORED_KEY_, @(eventControlAssist), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UIControlEvents)eventControlAssist {
    return [objc_getAssociatedObject(self, _CC_UICONTROL_EVENT_STORED_KEY_) unsignedIntegerValue];
}

- (void) ccControlExtensionAction : ( __kindof UIControl *) sender {
    void (^t)( __kindof UIControl *) = objc_getAssociatedObject(self, _CC_UICONTROL_EXTENSION_CLICK_ASSOCIATE_KEY_);
    if (t) {
        if (NSThread.isMainThread) t(sender);
        else dispatch_sync(dispatch_get_main_queue(), ^{
            t(sender);
        });
    }
}

- (void) ccControlExtensionEventAction : (__kindof UIControl *) sender {
    UIControlEvents events = self.eventControlAssist;
    NSString *s = @"CC_UICONTROL_EVENT_TRIGGER_ACTION_";
    s = [s stringByAppendingString:[NSString stringWithFormat:@"%@",@(events).stringValue]];
    void (^bEvent)(__kindof UIControl *sender) = self.dEvent[s];
    if (bEvent) bEvent(self);
}

@end

#pragma mark - -----
static const char * _CC_UIVIEW_ASSOCIATE_HITTEST_TOP_KEY_ = "CC_UIVIEW_ASSOCIATE_HITTEST_TOP_KEY";
static const char * _CC_UIVIEW_ASSOCIATE_HITTEST_LEFT_KEY_ = "CC_UIVIEW_ASSOCIATE_HITTEST_LEFT_KEY";
static const char * _CC_UIVIEW_ASSOCIATE_HITTEST_BOTTOM_KEY_ = "CC_UIVIEW_ASSOCIATE_HITTEST_BOTTOM_KEY";
static const char * _CC_UIVIEW_ASSOCIATE_HITTEST_RIGHT_KEY_ = "CC_UIVIEW_ASSOCIATE_HITTEST_RIGHT_KEY";

@implementation UIControl (CCExtension)

+ (instancetype) common : (CGRect) frame {
    UIControl *c = [[self alloc] initWithFrame:frame];
    c.userInteractionEnabled = YES;
    return c;
}
/// actions , default is touchUpInside
- (instancetype) cc_actions : (void (^)( __kindof UIControl *sender)) action {
    return [self cc_target:self actions:action];
}
- (instancetype) cc_target : (id) target
                   actions : (void (^)( __kindof UIControl *sender)) action {
    objc_setAssociatedObject(self, _CC_UICONTROL_EXTENSION_CLICK_ASSOCIATE_KEY_, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:target
              action:@selector(ccControlExtensionAction:)
    forControlEvents:UIControlEventTouchUpInside];
    return self;
}
/// custom actions .
- (instancetype) cc_target : (id) target
                  selector : (SEL) sel
                    events : (UIControlEvents) events {
    [self addTarget:(target ? target : self)
              action:sel
    forControlEvents:events];
    return self;
}
/// increase trigger rect .
- (instancetype) cc_increase : (UIEdgeInsets) insets {
    objc_setAssociatedObject(self, _CC_UIVIEW_ASSOCIATE_HITTEST_TOP_KEY_,
                             @(insets.top), OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, _CC_UIVIEW_ASSOCIATE_HITTEST_LEFT_KEY_,
                             @(insets.left), OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, _CC_UIVIEW_ASSOCIATE_HITTEST_BOTTOM_KEY_,
                             @(insets.bottom), OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, _CC_UIVIEW_ASSOCIATE_HITTEST_RIGHT_KEY_,
                             @(insets.right), OBJC_ASSOCIATION_COPY_NONATOMIC);
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    __weak typeof(self) pSelf = self;
    CGRect (^t)(void) = ^CGRect {
        NSNumber * top = objc_getAssociatedObject(pSelf, _CC_UIVIEW_ASSOCIATE_HITTEST_TOP_KEY_);
        NSNumber * left = objc_getAssociatedObject(pSelf, _CC_UIVIEW_ASSOCIATE_HITTEST_LEFT_KEY_);
        NSNumber * bottom = objc_getAssociatedObject(pSelf, _CC_UIVIEW_ASSOCIATE_HITTEST_BOTTOM_KEY_);
        NSNumber * right = objc_getAssociatedObject(pSelf, _CC_UIVIEW_ASSOCIATE_HITTEST_RIGHT_KEY_);
        if (top && left && bottom && right) {
            return CGRectMake(pSelf.bounds.origin.x - left.floatValue,
                              pSelf.bounds.origin.y - top.floatValue,
                              pSelf.bounds.size.width + left.floatValue + right.floatValue,
                              pSelf.bounds.size.height + top.floatValue + bottom.floatValue);
        }
        else return pSelf.bounds;
    };
    
    CGRect rect = t();
    if (CGRectEqualToRect(rect, self.bounds)) return [super hitTest:point withEvent:event];
    return CGRectContainsPoint(rect, point) ? self : nil;
}

- (instancetype) cc_shared_control_event : (UIControlEvents) event
                                 actions : (void (^)( __kindof UIControl *sender)) action {
    if (!action) return self;
    NSString *s = [@"CC_UICONTROL_EVENT_TRIGGER_ACTION_" stringByAppendingString:[NSString stringWithFormat:@"%@",@(event).stringValue]];
    
    [self.dEvent setValue:action forKey:s];
    self.eventControlAssist = self.eventControlAssist | event;
    
    [self addTarget:self
             action:@selector(ccControlExtensionEventAction:)
   forControlEvents:event];
    return self;
}

- (instancetype) cc_remove_event : (UIControlEvents) event {
    if (self.eventControlAssist & event) {
        NSString *s = @"CC_UICONTROL_EVENT_TRIGGER_ACTION_";
        NSString *ts = [s stringByAppendingString:[NSString stringWithFormat:@"%@",@(self.eventControlAssist).stringValue]];
        id t = self.dEvent[ts];
        self.eventControlAssist = self.eventControlAssist & (~event);
        NSString *te = [s stringByAppendingString:[NSString stringWithFormat:@"%@",@(self.eventControlAssist).stringValue]];
        [self.dEvent setValue:t forKey:te];
        [self removeTarget:self
                    action:@selector(ccControlExtensionEventAction:)
          forControlEvents:event];
    }
    return self;
}

@end
