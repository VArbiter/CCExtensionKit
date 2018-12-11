//
//  MQMenuView.m
//  MQExtensionKit
//
//  Created by Elwinfrederick on 14/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "MQMenuView.h"

#import <objc/runtime.h>
#import "MQCommon.h"

#pragma mark - -----

@interface UIMenuItem (MQExtension)

@property (nonatomic , strong) NSMutableDictionary *dictionary ;
@property (nonatomic , assign) NSInteger i_current ;
@property (nonatomic , readonly) NSString *s_key ;

@end

@implementation UIMenuItem (MQExtension)

- (void)setDictionary:(NSMutableDictionary *)dictionary {
    objc_setAssociatedObject(self, @selector(dictionary), dictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSMutableDictionary *)dictionary {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setI_current:(NSInteger)i_current {
    objc_setAssociatedObject(self, @selector(i_current), @(i_current), OBJC_ASSOCIATION_ASSIGN);
}
- (NSInteger)i_current {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (NSString *)s_key {
    return self.dictionary.allKeys.firstObject;
}

@end

#pragma mark - -----

@interface UIMenuController (MQExtension)

@property (nonatomic , assign , readonly) UIMenuItem *(^menu_item_t)(NSInteger) ;

@property (nonatomic , assign , readonly) NSInteger (^click_t)(NSString *);

@end

@implementation UIMenuController (MQExtension)

- (UIMenuItem *(^)(NSInteger))menu_item_t {
    __weak typeof(self) weak_self = self;
    return ^UIMenuItem *(NSInteger index) {
        if (index == -1) return nil;
        for (UIMenuItem *t_item in weak_self.menuItems) {
            if (![t_item isKindOfClass:[UIMenuItem class]]) continue;
            if (t_item.i_current == index) return t_item;
        }
        return nil;
    };
}

- (NSInteger (^)(NSString *))click_t {
    __weak typeof(self) weak_self = self;
    return ^NSInteger(NSString *s_title) {
        for (UIMenuItem *t_item in weak_self.menuItems) {
            if (![t_item isKindOfClass:UIMenuItem.class]) continue;
            if ([t_item.s_key isEqualToString:s_title])
                return t_item.i_current;
        }
        return -1;
    };
}

@end

#pragma mark - -----

@interface MQMenuView (MQExtension_Assist_Generate)

@property (nonatomic , copy) void(^block_title)(NSString *) ;
@property (nonatomic , class) NSArray *array_keys ;

- (void) MQ_METHOD_REPLACE_IMPL : (id) sender  ;

@end

@implementation MQMenuView (MQExtension_Assist_Generate)

static NSArray *__array_keys = nil;

+ (BOOL) resolveInstanceMethod:(SEL)sel {
    for (id obj in self.array_keys) {
        if (![obj isKindOfClass:[NSString class]]) continue;
        NSString *s_key = (NSString *) obj ;
        if (sel == NSSelectorFromString(s_key)) {
            return class_addMethod([self class],
                                   sel,
                                   class_getMethodImplementation(self, @selector(MQ_METHOD_REPLACE_IMPL:)),
                                   "s@:@");;
        }
    }
    return [super resolveInstanceMethod:sel];
}

- (void) MQ_METHOD_REPLACE_IMPL : (id) sender  {
    if (self.block_title) self.block_title([NSString stringWithUTF8String:sel_getName(_cmd)]);
}

- (void)setBlock_title:(void (^)(NSString *))block_title {
    objc_setAssociatedObject(self, @selector(block_title), block_title, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void (^)(NSString *))block_title {
    return objc_getAssociatedObject(self, _cmd);
}

+ (void)setArray_keys:(NSArray *)array_keys {
    __array_keys = array_keys;
}
+ (NSArray *)array_keys {
    return __array_keys;
}

@end

#pragma mark - -----

@interface MQMenuView ()

- (void) mq_default_settings ;
- (void) mq_add_menu_notification ;
- (void) mq_did_hide_menu : (NSNotification *) sender ;
- (void) mq_will_hide_menu : (NSNotification *) sender ;

@property (nonatomic , strong) UIMenuController *menu_controller ;
@property (nonatomic , strong) NSMutableArray *array_menu_items ;
@property (nonatomic , copy) void (^click)(NSDictionary *d_total ,
                                            NSString *s_key ,
                                            NSString *s_value ,
                                            NSInteger index) ;
@property (nonatomic , assign) id < MQMenuViewProtocol > delegate ;

@end

@implementation MQMenuView

- (instancetype) mq_show : (CGRect) frame
                   items : (NSArray <NSDictionary <NSString * , NSString *> *> *) array_titles {
    if (self.menu_controller.isMenuVisible || !array_titles.count) return self;
    
    NSMutableArray *a_keys = [NSMutableArray array];
    [array_titles enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            [a_keys addObject:obj.allKeys.firstObject];
        }
    }];
    self.class.array_keys = a_keys;
    
    [self.array_menu_items removeAllObjects];
    
    __weak typeof(self) weak_self = self;
    [array_titles enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *s_key = obj.allKeys.firstObject;
        NSString *s_value = obj.allValues.firstObject;
        
        void (^addMethod)(UIMenuItem * , SEL ) = ^(UIMenuItem *menu_item , SEL selector) {
            [menu_item setTitle:s_value];
            [menu_item setAction:selector];
            menu_item.i_current = idx ;
            menu_item.dictionary = [NSMutableDictionary dictionaryWithObject:s_value
                                                                     forKey:s_key];
            [weak_self.array_menu_items addObject:menu_item];
        };
        
        if ([s_key isKindOfClass:[NSString class]] && [s_value isKindOfClass:[NSString class]]) {
            UIMenuItem *menu_item = [[UIMenuItem alloc] init];
            SEL selector = NSSelectorFromString(s_key);
            if (addMethod) {
                if ([weak_self.class resolveInstanceMethod:selector]) {
                    if ([weak_self respondsToSelector:selector]) addMethod(menu_item , selector);
                }
                else if ([weak_self respondsToSelector:selector]) addMethod(menu_item , selector);
            }
        }
    }];
    
    self.menu_controller.menuItems = self.array_menu_items;
    [self becomeFirstResponder];
    [self.menu_controller setTargetRect:frame
                                inView:self];
    [self.menu_controller setMenuVisible:YES
                               animated:YES];
    return self;
}
- (instancetype) mq_click : (void (^)(NSDictionary *d_total ,
                                     NSString *s_key ,
                                     NSString *s_value ,
                                     NSInteger index)) click {
    self.click = [click copy];
    return self;
}
- (instancetype) mq_delegate : (id <MQMenuViewProtocol>) delegate {
    self.delegate = delegate;
    return self;
}

void MQ_DESTORY_MENU_ITEM(MQMenuView *view) {
    [view removeFromSuperview];
    view = nil;
}

- (void) mq_default_settings {
    [self mq_add_menu_notification];
    
    __weak typeof(self) weak_self = self;
    self.block_title = ^(NSString *string_title) {
        NSInteger index = weak_self.menu_controller.click_t(string_title);
        UIMenuItem *menu_item = weak_self.menu_controller.menu_item_t(index);
        if (weak_self.click)
            weak_self.click(menu_item.dictionary ,
                        menu_item.dictionary.allKeys.firstObject,
                        menu_item.dictionary.allValues.firstObject,
                        index);
    };
}

- (void) mq_add_menu_notification {
    NSNotificationCenter *c = [NSNotificationCenter defaultCenter];
    [c addObserver:self
          selector:@selector(mq_will_hide_menu:)
              name:UIMenuControllerWillHideMenuNotification
            object:nil];
    [c addObserver:self
          selector:@selector(mq_did_hide_menu:)
              name:UIMenuControllerDidHideMenuNotification
            object:nil];
}
- (void) mq_did_hide_menu : (NSNotification *) sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mq_menu_view_did_close:)]) {
        [self.delegate mq_menu_view_did_close:self];
    }
}
- (void) mq_will_hide_menu : (NSNotification *) sender {
    if ([self canResignFirstResponder]) [self resignFirstResponder];
}

- (NSMutableArray *)array_menu_items {
    if (_array_menu_items) return _array_menu_items;
    _array_menu_items = [NSMutableArray array];
    return _array_menu_items;
}

- (UIMenuController *)menu_controller {
    if (_menu_controller) return _menu_controller;
    _menu_controller = [UIMenuController sharedMenuController];
    return _menu_controller;
}

- (void)dealloc {
    NSNotificationCenter *c = [NSNotificationCenter defaultCenter];
    [c removeObserver:UIMenuControllerWillHideMenuNotification];
    [c removeObserver:UIMenuControllerDidHideMenuNotification];
    
    MQLog(@"_MQ_%@_DEALLOC_",NSStringFromClass(self.class));
}

@end
