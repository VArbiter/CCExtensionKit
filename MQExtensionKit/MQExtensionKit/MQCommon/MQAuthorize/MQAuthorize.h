//
//  CCAuthorize.h
//  MQExtensionKit
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger , CCSupportType) {
    CCSupportTypeNone = 0, // all access denied // 所有都被拒绝
    CCSupportTypeAll , // all // 所有允许通行
    CCSupportTypePhotoLibrary , // photos library // 图库
    CCSupportTypeVideo ,
    CCSupportTypeAudio
};

@interface CCAuthorize : NSObject

+ (instancetype) mq_shared ;
/// has authorize to sepecific settings . // 是否有某个权限
/// the return value for fail , decide whether if need to guide to setting pages . // fail block 的返回值决定是否打开设置页面
- (instancetype) mq_has_authorize : (CCSupportType) type
                          success : (void (^)(void)) success
                             fail : (BOOL (^)(void)) fail ;

@end
