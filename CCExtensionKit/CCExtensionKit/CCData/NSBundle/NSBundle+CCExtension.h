//
//  NSBundle+CCExtension.h
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 28/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (CCExtension)

+ (instancetype) cc_bundle_for : (Class) clazz ;
/// name , extension , path re-call (if found); // 名称 , 扩展名 . 路径回调 (如果找到的话)
- (instancetype) cc_resource : (NSString *) sName
                   extension : (NSString *) sExtension
                      action : (void(^)(NSString *sPath)) action ;
/// name , extension , subPath , path re-call (if found); // 名称 , 扩展名 . 子路径回调 (如果找到的话)
- (instancetype) cc_resource : (NSString *) sName
                   extension : (NSString *) sExtension
                    sub_path : (NSString *) sSubPath
                      action : (void(^)(NSString *sPath)) action ;
/// extension , subPath , paths re-call (if found); // 名称 , 扩展名 . 路径回调 (如果找到的话)
- (instancetype) cc_resource : (NSString *) sExtension
                    sub_path : (NSString *) sSubPath
                      action : (void(^)(NSArray <NSString *> *sPath)) action ;

@end
