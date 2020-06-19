//
//  NSFileManager+MQExtension.h
//  MQExtensionKit
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSInteger const mq_file_hash_default_chunk_size ;

NSString * MQ_HOME_DIRECTORY(void);
NSString * MQ_TEMP_DIRECTORY(void);
NSString * MQ_CACHE_DIRECTORY(void);
NSString * MQ_LIBRARY_DIRECTORY(void);

@interface NSFileManager (MQExtension)

- (BOOL) mq_is_directory_t : (NSString *) s_path ;
- (BOOL) mq_exists_t : (NSString *) s_path ;
- (BOOL) mq_remove_t : (NSString *) s_path ;
/// create if not exists . // 如果不存在就创建
- (BOOL) mq_create_folder_t : (NSString *) s_path ;
- (BOOL) mq_move_t : (NSString *) s_from
                to : (NSString *) s_to ;

/// note : in iOS , 1G == 1000Mb == 1000 * 1000kb == 1000 * 1000 * 1000b
/// note : in iOS (for bytes) , 1G = pow(10, 9) , 1Mb = pow(10, 6) , 1Kb = pow(10, 3)
/// note : highly recommend put it in a sub thread . (if sPath point at a directory) // 如果 sPath 是一个文件夹 , 建议把它放在子线程中
- (unsigned long long) mq_file_size_t : (NSString *) s_path ;
- (unsigned long long) mq_folder_size_t : (NSString *) s_path ;

/// note : if self is a folder or not valued path at all , returns nil // 如果 self 是一个文件夹 , 或者路径是无效的 , 返回 nil
#ifndef __IPHONE_13_0
- (NSString *) mq_MD5_auto : (NSString *) s_path ;
- (NSString *) mq_MD5_normal : (NSString *) s_path ;
- (NSString *) mq_MD5_large : (NSString *) s_path ;
#endif
- (NSString *) mq_mime_type : (NSString *) s_path ;

@end

#pragma mark - -----

@interface NSString (MQExtension_File_Extension)

@property (nonatomic , readonly) BOOL is_directory_t ;
@property (nonatomic , readonly) BOOL is_exists_t ;
@property (nonatomic , readonly) BOOL remove_t ;
@property (nonatomic , readonly) BOOL create_folder_t ;

/// note : highly recommend put it in a sub thread . (if self point at a directory) // 如果 字符串 是一个文件夹 , 建议把它放在子线程中
@property (nonatomic , readonly) unsigned long long file_size_t ;
@property (nonatomic , readonly) unsigned long long folder_size_t ;

- (BOOL) mq_move_to : (NSString *) s_to ;

/// note : if self is a folder or not valued path at all , returns nil rather than it self . // 如果 字符串 是一个文件夹 , 或者路径是无效的 , 返回 nil 而不是它本身
@property (nonatomic , readonly) NSString *mime_type ;

#ifndef __IPHONE_13_0
@property (nonatomic , readonly) NSString *file_auto_MD5 ;
@property (nonatomic , readonly) NSString *file_MD5 ;
@property (nonatomic , readonly) NSString *large_file_MD5 ;
#endif

@end
