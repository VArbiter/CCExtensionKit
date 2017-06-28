//
//  CCFileManager.h
//  CCAudioPlayer-Demo
//
//  Created by 冯明庆 on 27/06/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCFileManager : NSObject

@property (nonatomic , class , strong , readonly) CCFileManager * sharedInstance ;

@property (nonatomic , strong , readonly) NSString * stringPathComplete ;
@property (nonatomic , strong , readonly) NSString * stringPathTempCache ;

@property (nonatomic , strong , readonly) NSString * stringCacheFile ;

@property (nonatomic , strong , readonly) NSFileManager *fileManager ;

/// 如果不存在就创建 , 存在则不创建
- (BOOL) ccCreate : (NSString *) stringFolderPath ;

/// 判断文件是否存在
- (BOOL) ccExists : (NSString *) stringFilePath ;

/// 判断文件大小
- (unsigned long long) ccSize : (NSString *) stringFilePath ;

/// 删除文件
- (BOOL) ccRemove : (NSString *) stringFilePath ;

/**
 移动文件

 @param stringFilePath 来源
 @param stringPath 目的
 */
- (BOOL) ccMove : (NSString *) stringFilePath
             to : (NSString *) stringPath ;

- (NSString *) ccMD5 : (NSString *) stringFilePath ; // 普通文件 MD5 验证
- (NSString *) ccMD5L : (NSString *) stringFilePath ; // 大文件 MD5 验证
- (NSString *) ccMimeType : (NSString *) stringFilePath ; // 获得 文件 MimeType 类型

@end
