//
//  NSBundle+CCChain.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 08/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (CCChain)

@property (nonatomic , class , copy , readonly) NSBundle *(^main)();
@property (nonatomic , class , copy , readonly) NSBundle *(^bundleFor)(Class clazz);
/// name , extension , path re-call (if found);
@property (nonatomic , copy , readonly) NSBundle *(^resourceS)(NSString * sName, NSString * sExtension, void(^)(NSString *sPath));
/// name , extension , subPath , path re-call (if found);
@property (nonatomic , copy , readonly) NSBundle *(^resourceSC)(NSString * sName, NSString * sExtension, NSString * sSubPath, void(^)(NSString *sPath));
/// extension , subPath , paths re-call (if found);
@property (nonatomic , copy , readonly) NSBundle *(^resourceST)(NSString * sExtension, NSString * sSubPath, void(^)(NSArray <NSString *> *sPath));

@end
