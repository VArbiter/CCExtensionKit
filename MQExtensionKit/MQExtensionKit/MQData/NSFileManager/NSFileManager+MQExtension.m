//
//  NSFileManager+MQExtension.m
//  MQExtensionKit
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "NSFileManager+MQExtension.h"

#import <CommonCrypto/CommonDigest.h>
#import <MobileCoreServices/MobileCoreServices.h>

NSInteger const mq_file_hash_default_chunk_size = 1024 * 8;

NSString * MQ_HOME_DIRECTORY(void) {
    return NSHomeDirectory();
}
NSString * MQ_TEMP_DIRECTORY(void) {
    return NSTemporaryDirectory();
}
NSString * MQ_CACHE_DIRECTORY(void) {
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory , NSUserDomainMask, YES).firstObject;
}
NSString * MQ_LIBRARY_DIRECTORY(void) {
    return NSSearchPathForDirectoriesInDomains(NSLibraryDirectory , NSUserDomainMask, YES).firstObject;
}

@implementation NSFileManager (MQExtension)

- (BOOL)mq_is_directory_t:(NSString *)s_path {
    if (!s_path || !s_path.length) return false;
    BOOL is_dir = false;
    [self fileExistsAtPath:s_path
               isDirectory:&is_dir];
    return is_dir;
}
- (BOOL)mq_exists_t:(NSString *)s_path {
    if (!s_path || !s_path.length) return false;
    if ([self mq_is_directory_t:s_path]) return false;
    return [self fileExistsAtPath:s_path];
}
- (BOOL)mq_remove_t:(NSString *)s_path {
    if (!s_path || !s_path.length) return YES;
    NSError *e;
    BOOL b = [self removeItemAtPath:s_path
                              error:&e];
    return e ? false : b;
}
- (BOOL)mq_create_folder_t:(NSString *)s_path {
    if (!s_path || !s_path.length) return false;
    if ([self mq_is_directory_t:s_path]) return YES;
    NSError *e = nil;
    BOOL b = [self createDirectoryAtPath:s_path
             withIntermediateDirectories:YES // whether if create middle path // 是否创建中间路径
                              attributes:nil
                                   error:&e];
    return e ? false : b;
}
- (BOOL)mq_move_t:(NSString *)s_from to:(NSString *)s_to {
    if (!s_from || !s_from.length
        || !s_to || !s_to.length) return false;
    if ([self mq_is_directory_t:s_from]) return false;
    if ([self mq_is_directory_t:s_to]) return false;
    if (![self mq_exists_t:s_from]) return false;
    NSError *e ;
    BOOL b = [self moveItemAtPath:s_from
                           toPath:s_to
                            error:&e];
    return e ? false : b;
}

- (unsigned long long)mq_file_size_t:(NSString *)s_path {
    if (!s_path || !s_path.length) return 0;
    if ([self mq_is_directory_t:s_path]) return 0;
    if (![self mq_exists_t:s_path]) return 0;
    NSError *e ;
    NSDictionary *d_info = [self attributesOfItemAtPath:s_path
                                                  error:&e];
    return e ? 0 : [d_info[NSFileSize] longLongValue];
}
- (unsigned long long)mq_folder_size_t:(NSString *)s_path {
    if (!s_path || !s_path.length) return 0;
    if (![self mq_is_directory_t:s_path]) return [self mq_file_size_t:s_path];
    NSEnumerator * enumerator_files = [[self subpathsAtPath:s_path] objectEnumerator];
    NSString * s_file_name = nil;
    unsigned long long folder_size = 0;
    while ((s_file_name = [enumerator_files nextObject]) != nil) {
        folder_size += [self mq_file_size_t:[s_path stringByAppendingPathComponent:s_file_name]];
    }
    return folder_size;
}

#ifndef __IPHONE_13_0
- (NSString *)mq_MD5_auto:(NSString *)s_path {
    if (!s_path || !s_path.length) return nil;
    if ([self mq_is_directory_t:s_path]) return nil;
    if (![self mq_exists_t:s_path]) return nil;
    if ([self mq_file_size_t:s_path] >= 10 * pow(10, 6)) { // file limit 10 MB // 文件限制 10 M
        return [self mq_MD5_large:s_path] ;
    }
    return [self mq_MD5_normal:s_path];
}
- (NSString *)mq_MD5_normal:(NSString *)s_path {
    if (!s_path || !s_path.length) return nil;
    if ([self mq_is_directory_t:s_path]) return nil;
    if (![self mq_exists_t:s_path]) return nil;
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:s_path];
    if(!handle) return nil;
    
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    BOOL done = NO;
    while(!done)
    {
        NSData * data_file = [handle readDataOfLength: 256 ];
        CC_MD5_Update(&md5, data_file.bytes, (CC_LONG)data_file.length);
        if( data_file.length == 0 ) done = YES;
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSMutableString *string = @"".mutableCopy;
    for (NSUInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [string appendString:[NSString stringWithFormat:@"%02x",digest[i]]];
    }
    return string;
}
- (NSString *)mq_MD5_large:(NSString *)s_path {
    if (!s_path || !s_path.length) return nil;
    if ([self mq_is_directory_t:s_path]) return nil;
    if (![self mq_exists_t:s_path]) return nil;
    NSString *(^t)(CFStringRef , size_t) = ^NSString *(CFStringRef s_ref_path , size_t size_chunk) {
        // Declare needed variables // 声明变量
        CFStringRef result = NULL;
        CFReadStreamRef read_stream = NULL;
        // Get the file URL // 获得文件 URL
        CFURLRef file_url = CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
                                                         (CFStringRef)s_ref_path,
                                                         kCFURLPOSIXPathStyle,
                                                         (Boolean)false);
        if (!file_url) goto done;
        // Create and open the read stream // 创建文件输入流
        read_stream = CFReadStreamCreateWithFile(kCFAllocatorDefault,
                                                (CFURLRef)file_url);
        if (!read_stream) goto done;
        bool did_succeed = (bool)CFReadStreamOpen(read_stream);
        if (!did_succeed) goto done;
        // Initialize the hash object // 创建哈希对象
        CC_MD5_CTX hash_object;
        CC_MD5_Init(&hash_object);
        // Make sure chunkSizeForReadingData is valid // 保证 读取对象的 会大小是有效的
        if (!size_chunk) {
            size_chunk = mq_file_hash_default_chunk_size;
        }
        // Feed the data to the hash object // 将 data 给 哈希对象
        bool is_has_more_data = true;
        while (is_has_more_data) {
            uint8_t buffer[size_chunk];
            CFIndex read_bytes_count = CFReadStreamRead(read_stream,(UInt8 *)buffer,(CFIndex)sizeof(buffer));
            if (read_bytes_count == -1) break;
            if (read_bytes_count == 0) {
                is_has_more_data = false;
                continue;
            }
            CC_MD5_Update(&hash_object,(const void *)buffer,(CC_LONG)read_bytes_count);
        }
        // Check if the read operation succeeded // 检查读取操作是否成功
        did_succeed = !is_has_more_data;
        // Compute the hash digest // 计算 哈希值
        unsigned char digest[CC_MD5_DIGEST_LENGTH];
        CC_MD5_Final(digest, &hash_object);
        // Abort if the read operation failed // 放弃如果读操作失败
        if (!did_succeed) goto done;
        // Compute the string result // 计算字符串对象
        char hash[2 * sizeof(digest) + 1];
        for (size_t i = 0; i < sizeof(digest); ++i) {
            snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
        }
        result = CFStringCreateWithCString(kCFAllocatorDefault,(const char *)hash,kCFStringEncodingUTF8);
        
    done:
        if (read_stream) {
            CFReadStreamClose(read_stream);
            CFRelease(read_stream);
        }
        if (file_url) CFRelease(file_url);
        return (__bridge_transfer NSString *) result;
    };
    return t ? t(((__bridge CFStringRef)s_path) , mq_file_hash_default_chunk_size) : nil;
}
#endif

- (NSString *)mq_mime_type:(NSString *)s_path {
    if (!s_path || !s_path.length) return nil;
    if ([self mq_is_directory_t:s_path]) return nil;
    if (![self mq_exists_t:s_path]) return nil;
    NSString *s_extension = s_path.pathExtension;
    CFStringRef s_content_ref = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,
                                                                      (__bridge CFStringRef)(s_extension),
                                                                      NULL);
    return CFBridgingRelease(s_content_ref);
}


@end

#pragma mark - -----

@implementation NSString (MQExtension_File_Extension)

- (BOOL)is_directory_t {
    return [NSFileManager.defaultManager mq_is_directory_t:self];
}
- (BOOL)is_exists_t {
    return [NSFileManager.defaultManager mq_exists_t:self];
}
- (BOOL)remove_t {
    return [NSFileManager.defaultManager mq_remove_t:self];
}
- (BOOL)create_folder_t {
    return [NSFileManager.defaultManager mq_create_folder_t:self];
}

- (unsigned long long)file_size_t {
    return [NSFileManager.defaultManager mq_file_size_t:self];
}
- (unsigned long long)folder_size_t {
    return [NSFileManager.defaultManager mq_folder_size_t:self];
}

- (BOOL)mq_move_to:(NSString *)s_to {
    return [NSFileManager.defaultManager mq_move_t:self
                                                to:s_to];
}

- (NSString *)mime_type {
    return [NSFileManager.defaultManager mq_mime_type:self];
}

#ifndef __IPHONE_13_0
- (NSString *)file_auto_MD5 {
    return [NSFileManager.defaultManager mq_MD5_auto:self];
}
- (NSString *)file_MD5 {
    return [NSFileManager.defaultManager mq_MD5_normal:self];
}
- (NSString *)large_file_MD5 {
    return [NSFileManager.defaultManager mq_MD5_large:self];
}
#endif

@end
