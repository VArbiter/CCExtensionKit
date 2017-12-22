//
//  NSFileManager+CCExtension.m
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "NSFileManager+CCExtension.h"

#import <CommonCrypto/CommonDigest.h>
#import <MobileCoreServices/MobileCoreServices.h>

NSInteger const _CC_FILE_HASH_DEFAULT_CHUNK_SIZE_ = 1024 * 8;

@implementation NSFileManager (CCExtension)

+ (NSString *)sHomeDirectory {
    return NSHomeDirectory();
}
+ (NSString *)sTempDirectory {
    return NSTemporaryDirectory();
}
+ (NSString *)sCacheDirectory {
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory , NSUserDomainMask, YES).firstObject;
}
+ (NSString *)sLibraryDirectory {
    return NSSearchPathForDirectoriesInDomains(NSLibraryDirectory , NSUserDomainMask, YES).firstObject;
}

- (BOOL)ccIsDirectoryT:(NSString *)sPath {
    if (!sPath || !sPath.length) return false;
    BOOL isDir = false;
    [self fileExistsAtPath:sPath
               isDirectory:&isDir];
    return isDir;
}
- (BOOL)ccExistsT:(NSString *)sPath {
    if (!sPath || !sPath.length) return false;
    if ([self ccIsDirectoryT:sPath]) return false;
    return [self fileExistsAtPath:sPath];
}
- (BOOL)ccRemoveT:(NSString *)sPath {
    if (!sPath || !sPath.length) return YES;
    NSError *e;
    BOOL b = [self removeItemAtPath:sPath
                              error:&e];
    return e ? false : b;
}
- (BOOL)ccCreateFolderT:(NSString *)sPath {
    if (!sPath || !sPath.length) return false;
    if ([self ccIsDirectoryT:sPath]) return YES;
    NSError *e = nil;
    BOOL b = [self createDirectoryAtPath:sPath
             withIntermediateDirectories:YES // whether if create middle path // 是否创建中间路径
                              attributes:nil
                                   error:&e];
    return e ? false : b;
}
- (BOOL)ccMoveT:(NSString *)sFrom to:(NSString *)sTo {
    if (!sFrom || !sFrom.length
        || !sTo || !sTo.length) return false;
    if ([self ccIsDirectoryT:sFrom]) return false;
    if ([self ccIsDirectoryT:sTo]) return false;
    if (![self ccExistsT:sFrom]) return false;
    NSError *e ;
    BOOL b = [self moveItemAtPath:sFrom
                           toPath:sTo
                            error:&e];
    return e ? false : b;
}

- (unsigned long long)ccFileSizeT:(NSString *)sPath {
    if (!sPath || !sPath.length) return 0;
    if ([self ccIsDirectoryT:sPath]) return 0;
    if (![self ccExistsT:sPath]) return 0;
    NSError *e ;
    NSDictionary *dictionaryInfo = [self attributesOfItemAtPath:sPath
                                                          error:&e];
    return e ? 0 : [dictionaryInfo[NSFileSize] longLongValue];
}
- (unsigned long long)ccFolderSizeT:(NSString *)sPath {
    if (!sPath || !sPath.length) return 0;
    if (![self ccIsDirectoryT:sPath]) return [self ccFileSizeT:sPath];
    NSEnumerator * enumeratorFiles = [[self subpathsAtPath:sPath] objectEnumerator];
    NSString * sFileName = nil;
    unsigned long long folderSize = 0;
    while ((sFileName = [enumeratorFiles nextObject]) != nil) {
        folderSize += [self ccFileSizeT:[sPath stringByAppendingPathComponent:sFileName]];
    }
    return folderSize;
}

- (NSString *)ccMD5Auto:(NSString *)sPath {
    if (!sPath || !sPath.length) return @"";
    if ([self ccIsDirectoryT:sPath]) return @"";
    if (![self ccExistsT:sPath]) return @"";
    if ([self ccFileSizeT:sPath] >= 10 * pow(10, 6)) { // file limit 10 MB // 文件限制 10 M
        return [self ccMD5Large:sPath] ;
    }
    return [self ccMD5Normal:sPath];
}
- (NSString *)ccMD5Normal:(NSString *)sPath {
    if (!sPath || !sPath.length) return @"";
    if ([self ccIsDirectoryT:sPath]) return @"";
    if (![self ccExistsT:sPath]) return @"";
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
- (NSString *)ccMD5Large:(NSString *)sPath {
    if (!sPath || !sPath.length) return @"";
    if ([self ccIsDirectoryT:sPath]) return @"";
    if (![self ccExistsT:sPath]) return @"";
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
            sizeChunk = _CC_FILE_HASH_DEFAULT_CHUNK_SIZE_;
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
    return t ? t(((__bridge CFStringRef)sPath) , _CC_FILE_HASH_DEFAULT_CHUNK_SIZE_) : @"";
}
- (NSString *)ccMimeType:(NSString *)sPath {
    if (!sPath || !sPath.length) return @"";
    if ([self ccIsDirectoryT:sPath]) return @"";
    if (![self ccExistsT:sPath]) return @"";
    NSString *sExtension = sPath.pathExtension;
    CFStringRef sContentRef = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,
                                                                    (__bridge CFStringRef)(sExtension),
                                                                    NULL);
    return CFBridgingRelease(sContentRef); // hanleded to arc // 交给 ARC 管理
}


@end

#pragma mark - -----

@implementation NSString (CCExtension_File_Extension)

- (BOOL)isDirectoryT {
    return [NSFileManager.defaultManager ccIsDirectoryT:self];
}
- (BOOL)isExistsT {
    return [NSFileManager.defaultManager ccExistsT:self];
}
- (BOOL)removeT {
    return [NSFileManager.defaultManager ccRemoveT:self];
}
- (BOOL)createFolderT {
    return [NSFileManager.defaultManager ccCreateFolderT:self];
}

- (unsigned long long)fileSizeT {
    return [NSFileManager.defaultManager ccFileSizeT:self];
}
- (unsigned long long)folderSizeT {
    return [NSFileManager.defaultManager ccFolderSizeT:self];
}

- (BOOL)ccMoveTo:(NSString *)sTo {
    return [NSFileManager.defaultManager ccMoveT:self
                                              to:sTo];
}

- (NSString *)mimeType {
    return [NSFileManager.defaultManager ccMimeType:self];
}
- (NSString *)fileAutoMD5 {
    return [NSFileManager.defaultManager ccMD5Auto:self];
}
- (NSString *)fileMD5 {
    return [NSFileManager.defaultManager ccMD5Normal:self];
}
- (NSString *)largeFileMD5 {
    return [NSFileManager.defaultManager ccMD5Large:self];
}

@end
