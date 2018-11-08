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
@property (nonatomic , assign) NSInteger iCurrent ;
@property (nonatomic , readonly) NSString *sKey ;

@end

@implementation UIMenuItem (MQExtension)

- (void)setDictionary:(NSMutableDictionary *)dictionary {
    objc_setAssociatedObject(self, @selector(dictionary), dictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSMutableDictionary *)dictionary {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setICurrent:(NSInteger)iCurrent {
    objc_setAssociatedObject(self, @selector(iCurrent), @(iCurrent), OBJC_ASSOCIATION_ASSIGN);
}
- (NSInteger)iCurrent {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (NSString *)sKey {
    return self.dictionary.allKeys.firstObject;
}

@end

#pragma mark - -----

@interface UIMenuController (MQExtension)

@property (nonatomic , assign , readonly) UIMenuItem *(^menuItemT)(NSInteger) ;

@property (nonatomic , assign , readonly) NSInteger (^clickT)(NSString *);

@end

@implementation UIMenuController (MQExtension)

- (UIMenuItem *(^)(NSInteger))menuItemT {
    __weak typeof(self) pSelf = self;
    return ^UIMenuItem *(NSInteger index) {
        if (index == -1) return nil;
        for (UIMenuItem *tempItem in pSelf.menuItems) {
            if (![tempItem isKindOfClass:[UIMenuItem class]]) continue;
            if (tempItem.iCurrent == index) return tempItem;
        }
        return nil;
    };
}

- (NSInteger (^)(NSString *))clickT {
    __weak typeof(self) pSelf = self;
    return ^NSInteger(NSString *sTitle) {
        for (UIMenuItem *tempItem in pSelf.menuItems) {
            if (![tempItem isKindOfClass:UIMenuItem.class]) continue;
            if ([tempItem.sKey isEqualToString:sTitle])
                return tempItem.iCurrent;
        }
        return -1;
    };
}

@end

#pragma mark - -----

@interface MQMenuView (MQExtension_Assist_Generate)

@property (nonatomic , copy) void(^blockTitle)(NSString *) ;
@property (nonatomic , class) NSArray *arrayKeys ;

- (void) MQ_METHOD_REPLACE_IMPL : (id) sender  ;

@end

static NSArray *__arrayKeys = nil;

@implementation MQMenuView (MQExtension_Assist_Generate)

+ (BOOL) resolveInstanceMethod:(SEL)sel {
    for (id obj in self.arrayKeys) {
        if (![obj isKindOfClass:[NSString class]]) continue;
        NSString *stringKey = (NSString *) obj ;
        if (sel == NSSelectorFromString(stringKey)) {
            return class_addMethod([self class],
                                   sel,
                                   class_getMethodImplementation(self, @selector(MQ_METHOD_REPLACE_IMPL:)),
                                   "s@:@");;
        }
    }
    return [super resolveInstanceMethod:sel];
}

- (void) MQ_METHOD_REPLACE_IMPL : (id) sender  {
    if (self.blockTitle) self.blockTitle([NSString stringWithUTF8String:sel_getName(_cmd)]);
}

- (void)setBlockTitle:(void (^)(NSString *))blockTitle {
    objc_setAssociatedObject(self, @selector(blockTitle), blockTitle, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void (^)(NSString *))blockTitle {
    return objc_getAssociatedObject(self, _cmd);
}

+ (void)setArrayKeys:(NSArray *)arrayKeys {
    __arrayKeys = arrayKeys;
}
+ (NSArray *)arrayKeys {
    return __arrayKeys;
}

@end

#pragma mark - -----

@interface MQMenuView ()

- (void) mq_default_settings ;
- (void) mq_add_menu_notification ;
- (void) mq_did_hide_menu : (NSNotification *) sender ;
- (void) mq_will_hide_menu : (NSNotification *) sender ;

@property (nonatomic , strong) UIMenuController *menuController ;
@property (nonatomic , strong) NSMutableArray *arrayMenuItem ;
@property (nonatomic , copy) void (^click)(NSDictionary *dTotal ,
                                            NSString *sKey ,
                                            NSString *sValue ,
                                            NSInteger index) ;
@property (nonatomic , assign) id < MQMenuViewProtocol > delegate ;

@end

@implementation MQMenuView

- (instancetype) mq_show : (CGRect) frame
                   items : (NSArray <NSDictionary <NSString * , NSString *> *> *) arrayTitles {
    if (self.menuController.isMenuVisible || !arrayTitles.count) return self;
    
    NSMutableArray *akeys = [NSMutableArray array];
    [arrayTitles enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            [akeys addObject:obj.allKeys.firstObject];
        }
    }];
    self.class.arrayKeys = akeys;
    
    [self.arrayMenuItem removeAllObjects];
    
    __weak typeof(self) pSelf = self;
    [arrayTitles enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *sKey = obj.allKeys.firstObject;
        NSString *sValue = obj.allValues.firstObject;
        
        void (^addMethod)(UIMenuItem *menuItem , SEL selector) = ^(UIMenuItem *menuItem , SEL selector) {
            [menuItem setTitle:sValue];
            [menuItem setAction:selector];
            menuItem.iCurrent = idx ;
            menuItem.dictionary = [NSMutableDictionary dictionaryWithObject:sValue
                                                                     forKey:sKey];
            [pSelf.arrayMenuItem addObject:menuItem];
        };
        
        if ([sKey isKindOfClass:[NSString class]] && [sValue isKindOfClass:[NSString class]]) {
            UIMenuItem *menuItem = [[UIMenuItem alloc] init];
            SEL selector = NSSelectorFromString(sKey);
            if (addMethod) {
                if ([pSelf.class resolveInstanceMethod:selector]) {
                    if ([pSelf respondsToSelector:selector]) addMethod(menuItem , selector);
                }
                else if ([pSelf respondsToSelector:selector]) addMethod(menuItem , selector);
            }
        }
    }];
    
    self.menuController.menuItems = self.arrayMenuItem;
    [self becomeFirstResponder];
    [self.menuController setTargetRect:frame
                                inView:self];
    [self.menuController setMenuVisible:YES
                               animated:YES];
    return self;
}
- (instancetype) mq_click : (void (^)(NSDictionary *dTotal ,
                                     NSString *sKey ,
                                     NSString *sValue ,
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
    
    __weak typeof(self) pSelf = self;
    self.blockTitle = ^(NSString *stringTitle) {
        NSInteger index = pSelf.menuController.clickT(stringTitle);
        UIMenuItem *menuItem = pSelf.menuController.menuItemT(index);
        if (pSelf.click)
            pSelf.click(menuItem.dictionary ,
                        menuItem.dictionary.allKeys.firstObject,
                        menuItem.dictionary.allValues.firstObject,
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

- (NSMutableArray *)arrayMenuItem {
    if (_arrayMenuItem) return _arrayMenuItem;
    _arrayMenuItem = [NSMutableArray array];
    return _arrayMenuItem;
}

- (UIMenuController *)menuController {
    if (_menuController) return _menuController;
    _menuController = [UIMenuController sharedMenuController];
    return _menuController;
}

- (void)dealloc {
    NSNotificationCenter *c = [NSNotificationCenter defaultCenter];
    [c removeObserver:UIMenuControllerWillHideMenuNotification];
    [c removeObserver:UIMenuControllerDidHideMenuNotification];
    
    MQLog(@"_MQ_%@_DEALLOC_",NSStringFromClass(self.class));
}

@end
