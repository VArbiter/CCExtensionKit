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

- (BOOL)mq_is_directory_t:(NSString *)sPath {
    if (!sPath || !sPath.length) return false;
    BOOL isDir = false;
    [self fileExistsAtPath:sPath
               isDirectory:&isDir];
    return isDir;
}
- (BOOL)mq_exists_t:(NSString *)sPath {
    if (!sPath || !sPath.length) return false;
    if ([self mq_is_directory_t:sPath]) return false;
    return [self fileExistsAtPath:sPath];
}
- (BOOL)mq_remove_t:(NSString *)sPath {
    if (!sPath || !sPath.length) return YES;
    NSError *e;
    BOOL b = [self removeItemAtPath:sPath
                              error:&e];
    return e ? false : b;
}
- (BOOL)mq_create_folder_t:(NSString *)sPath {
    if (!sPath || !sPath.length) return false;
    if ([self mq_is_directory_t:sPath]) return YES;
    NSError *e = nil;
    BOOL b = [self createDirectoryAtPath:sPath
             withIntermediateDirectories:YES // whether if create middle path // 是否创建中间路径
                              attributes:nil
                                   error:&e];
    return e ? false : b;
}
- (BOOL)mq_move_t:(NSString *)sFrom to:(NSString *)sTo {
    if (!sFrom || !sFrom.length
        || !sTo || !sTo.length) return false;
    if ([self mq_is_directory_t:sFrom]) return false;
    if ([self mq_is_directory_t:sTo]) return false;
    if (![self mq_exists_t:sFrom]) return false;
    NSError *e ;
    BOOL b = [self moveItemAtPath:sFrom
                           toPath:sTo
                            error:&e];
    return e ? false : b;
}

- (unsigned long long)mq_file_size_t:(NSString *)sPath {
    if (!sPath || !sPath.length) return 0;
    if ([self mq_is_directory_t:sPath]) return 0;
    if (![self mq_exists_t:sPath]) return 0;
    NSError *e ;
    NSDictionary *dictionaryInfo = [self attributesOfItemAtPath:sPath
                                                          error:&e];
    return e ? 0 : [dictionaryInfo[NSFileSize] longLongValue];
}
- (unsigned long long)mq_folder_size_t:(NSString *)sPath {
    if (!sPath || !sPath.length) return 0;
    if (![self mq_is_directory_t:sPath]) return [self mq_file_size_t:sPath];
    NSEnumerator * enumeratorFiles = [[self subpathsAtPath:sPath] objectEnumerator];
    NSString * sFileName = nil;
    unsigned long long folderSize = 0;
    while ((sFileName = [enumeratorFiles nextObject]) != nil) {
        folderSize += [self mq_file_size_t:[sPath stringByAppendingPathComponent:sFileName]];
    }
    return folderSize;
}

- (NSString *)mq_MD5_auto:(NSString *)sPath {
    if (!sPath || !sPath.length) return nil;
    if ([self mq_is_directory_t:sPath]) return nil;
    if (![self mq_exists_t:sPath]) return nil;
    if ([self mq_file_size_t:sPath] >= 10 * pow(10, 6)) { // file limit 10 MB // 文件限制 10 M
        return [self mq_MD5_large:sPath] ;
    }
    return [self mq_MD5_normal:sPath];
}
- (NSString *)mq_MD5_normal:(NSString *)sPath {
    if (!sPath || !sPath.length) return nil;
    if ([self mq_is_directory_t:sPath]) return nil;
    if (![self mq_exists_t:sPath]) return nil;
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:sPath];
    if(!handle) return nil;
    
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    BOOL done = NO;
    while(!done)
    {
        NSData * dataFile = [handle readDataOfLength: 256 ];
        CC_MD5_Update(&md5, dataFile.bytes, (CC_LONG)dataFile.length);
        if( dataFile.length == 0 ) done = YES;
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSMutableString *string = @"".mutableCopy;
    for (NSUInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [string appendString:[NSString stringWithFormat:@"%02x",digest[i]]];
    }
    return string;
}
- (NSString *)mq_MD5_large:(NSString *)sPath {
    if (!sPath || !sPath.length) return nil;
    if ([self mq_is_directory_t:sPath]) return nil;
    if (![self mq_exists_t:sPath]) return nil;
    NSString *(^t)(CFStringRef stringRefPath , size_t sizeChunk) = ^NSString *(CFStringRef stringRefPath , size_t sizeChunk) {
        // Declare needed variables // 声明变量
        CFStringRef result = NULL;
        CFReadStreamRef readStream = NULL;
        // Get the file URL // 获得文件 URL
        CFURLRef fileURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
                                                         (CFStringRef)stringRefPath,
                                                         kCFURLPOSIXPathStyle,
                                                         (Boolean)false);
        if (!fileURL) goto done;
        // Create and open the read stream // 创建文件输入流
        readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,
                                                (CFURLRef)fileURL);
        if (!readStream) goto done;
        bool didSucceed = (bool)CFReadStreamOpen(readStream);
        if (!didSucceed) goto done;
        // Initialize the hash object // 创建哈希对象
        CC_MD5_CTX hashObject;
        CC_MD5_Init(&hashObject);
        // Make sure chunkSizeForReadingData is valid // 保证 读取对象的 会大小是有效的
        if (!sizeChunk) {
            sizeChunk = mq_file_hash_default_chunk_size;
        }
        // Feed the data to the hash object // 将 data 给 哈希对象
        bool hasMoreData = true;
        while (hasMoreData) {
            uint8_t buffer[sizeChunk];
            CFIndex readBytesCount = CFReadStreamRead(readStream,(UInt8 *)buffer,(CFIndex)sizeof(buffer));
            if (readBytesCount == -1) break;
            if (readBytesCount == 0) {
                hasMoreData = false;
                continue;
            }
            CC_MD5_Update(&hashObject,(const void *)buffer,(CC_LONG)readBytesCount);
        }
        // Check if the read operation succeeded // 检查读取操作是否成功
        didSucceed = !hasMoreData;
        // Compute the hash digest // 计算 哈希值
        unsigned char digest[CC_MD5_DIGEST_LENGTH];
        CC_MD5_Final(digest, &hashObject);
        // Abort if the read operation failed // 放弃如果读操作失败
        if (!didSucceed) goto done;
        // Compute the string result // 计算字符串对象
        char hash[2 * sizeof(digest) + 1];
        for (size_t i = 0; i < sizeof(digest); ++i) {
            snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
        }
        result = CFStringCreateWithCString(kCFAllocatorDefault,(const char *)hash,kCFStringEncodingUTF8);
        
    done:
        if (readStream) {
            CFReadStreamClose(readStream);
            CFRelease(readStream);
        }
        if (fileURL) CFRelease(fileURL);
        return (__bridge_transfer NSString *) result;
    };
    return t ? t(((__bridge CFStringRef)sPath) , mq_file_hash_default_chunk_size) : nil;
}
- (NSString *)mq_mime_type:(NSString *)sPath {
    if (!sPath || !sPath.length) return nil;
    if ([self mq_is_directory_t:sPath]) return nil;
    if (![self mq_exists_t:sPath]) return nil;
    NSString *sExtension = sPath.pathExtension;
    CFStringRef sContentRef = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,
                                                                    (__bridge CFStringRef)(sExtension),
                                                                    NULL);
    return CFBridgingRelease(sContentRef); // hanleded to arc // 交给 ARC 管理
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

- (BOOL)mq_move_to:(NSString *)sTo {
    return [NSFileManager.defaultManager mq_move_t:self
                                                to:sTo];
}

- (NSString *)mime_type {
    return [NSFileManager.defaultManager mq_mime_type:self];
}
- (NSString *)file_auto_MD5 {
    return [NSFileManager.defaultManager mq_MD5_auto:self];
}
- (NSString *)file_MD5 {
    return [NSFileManager.defaultManager mq_MD5_normal:self];
}
- (NSString *)large_file_MD5 {
    return [NSFileManager.defaultManager mq_MD5_large:self];
}

@end
