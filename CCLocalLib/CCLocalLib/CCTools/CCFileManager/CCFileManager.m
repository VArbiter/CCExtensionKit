//
//  CCFileManager.m
//  CCAudioPlayer-Demo
//
//  Created by 冯明庆 on 27/06/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "CCFileManager.h"
#import "CCCommonDefine.h"

#import <CommonCrypto/CommonDigest.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface CCFileManager () < NSCopying , NSMutableCopying >

@end

#define _CC_HASH_DEFAULT_CHUNK_SIZE_ 1024 * 8

static CCFileManager * _manager = nil;

@implementation CCFileManager

+ (CCFileManager *)sharedInstance {
    if (_manager) return _manager;
    _manager = [[self alloc] init];
    return _manager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (_manager) return _manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [super allocWithZone:zone];
    });
    return _manager;
}

- (id)copyWithZone:(NSZone *)zone {
    return _manager;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _manager;
}

- (NSString *)stringPathComplete {
    NSString *stringPath = [self.stringCacheFolder stringByAppendingPathComponent:@"Downloader/Completed"];
    if ([self ccCreate:stringPath]) {
        return stringPath;
    }
    return self.stringCacheFolder;
}
- (NSString *)stringPathTempCache {
    NSString *stringPath = [self.stringCacheFolder stringByAppendingPathComponent:@"Downloader/TempCache."];
    if ([self ccCreate:stringPath]) {
        return stringPath;
    }
    return self.stringCacheFolder;
}

- (NSFileManager *)fileManager {
    return [NSFileManager defaultManager];
}


- (BOOL) ccCreate : (NSString *) stringFolderPath {
    BOOL isDirectory = false;
    if ([self.fileManager fileExistsAtPath:stringFolderPath
                               isDirectory:&isDirectory]) {
        if (isDirectory) {
            return YES;
        }
    }
    NSError *error = nil;
    BOOL isSucceed = [self.fileManager createDirectoryAtPath:stringFolderPath
                                 withIntermediateDirectories:YES // 中间路径是否创建
                                                  attributes:nil
                                                       error:&error];
    if (error) {
        CCLog(@"%@",error);
    }
    return isSucceed;
}

- (BOOL) ccExists : (NSString *) stringFilePath {
    BOOL isDirectory = false;
    if ([self.fileManager fileExistsAtPath:stringFilePath
                               isDirectory:&isDirectory]) {
        if (isDirectory) {
            return false;
        }
        return YES;
    }
    return false;
}

- (unsigned long long) ccSize : (NSString *) stringFilePath {
    if (![self ccExists:stringFilePath]) return 0;
    NSError *error ;
    NSDictionary *dictionaryInfo = [self.fileManager attributesOfItemAtPath:stringFilePath
                                                                      error:&error];
    if (error) {
        if (![self ccRemove:stringFilePath]) {
            [self ccRemove:stringFilePath];
        }
        return 0;
    }
    return [dictionaryInfo[NSFileSize] longLongValue];
}

- (BOOL) ccRemove : (NSString *) stringFilePath {
    if (![self ccExists:stringFilePath]) {
        return YES;
    }
    NSError *error;
    BOOL isSucceed = [self.fileManager removeItemAtPath:stringFilePath
                                                  error:&error];
    if (error) {
        return false;
    }
    return isSucceed;
}

- (BOOL) ccMove : (NSString *) stringFilePath
             to : (NSString *) stringPath  {
    if ([self ccExists:stringFilePath]) {
        NSError *error ;
        BOOL isSucceed = [self.fileManager moveItemAtPath:stringFilePath
                                                   toPath:stringPath
                                                    error:&error];
        if (error) {
            return false;
        }
        return isSucceed;
    }
    return false;
}

- (NSString *) ccMD5 : (NSString *) stringFilePath {
    if (![self ccExists:stringFilePath]) {
        return nil;
    }
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:stringFilePath];
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
        [string appendString:ccStringFormat(@"%02x",digest[i])];
    }
    return string;
}
- (NSString *) ccMD5L : (NSString *) stringFilePath {
    if (![self ccExists:stringFilePath]) {
        return nil;
    }
    
    NSString *(^block)(CFStringRef stringRefPath , size_t sizeChunk) = ^NSString *(CFStringRef stringRefPath , size_t sizeChunk) {
        // Declare needed variables
        CFStringRef result = NULL;
        CFReadStreamRef readStream = NULL;
        // Get the file URL
        CFURLRef fileURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
                                                         (CFStringRef)stringRefPath,
                                                         kCFURLPOSIXPathStyle,
                                                         (Boolean)false);
        if (!fileURL) goto done;
        // Create and open the read stream
        readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,
                                                (CFURLRef)fileURL);
        if (!readStream) goto done;
        bool didSucceed = (bool)CFReadStreamOpen(readStream);
        if (!didSucceed) goto done;
        // Initialize the hash object
        CC_MD5_CTX hashObject;
        CC_MD5_Init(&hashObject);
        // Make sure chunkSizeForReadingData is valid
        if (!sizeChunk) {
            sizeChunk = _CC_HASH_DEFAULT_CHUNK_SIZE_;
        }
        // Feed the data to the hash object
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
        // Check if the read operation succeeded
        didSucceed = !hasMoreData;
        // Compute the hash digest
        unsigned char digest[CC_MD5_DIGEST_LENGTH];
        CC_MD5_Final(digest, &hashObject);
        // Abort if the read operation failed
        if (!didSucceed) goto done;
        // Compute the string result
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
        if (fileURL) {
            CFRelease(fileURL);
        }
        return (__bridge_transfer NSString *) result;
    };
    if (block) {
        return block(((__bridge CFStringRef)stringFilePath) , _CC_HASH_DEFAULT_CHUNK_SIZE_);
    }
    return nil;
}

- (NSString *) ccMimeType : (NSString *) stringFilePath {
    if (![self ccExists:stringFilePath]) {
        return nil;
    }
    NSString *stringExtension = stringFilePath.pathExtension;
    CFStringRef stringContentRef = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,
                                                                         (__bridge CFStringRef)(stringExtension),
                                                                         NULL);
    return CFBridgingRelease(stringContentRef); // 这种桥接 , 交个 ARC 释放 .
}

#pragma mark - Private
- (NSString *)stringCacheFolder {
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory , NSUserDomainMask, YES).firstObject;
}
- (NSString *)stringTempFolder {
    return NSTemporaryDirectory();
}
- (NSString *)stringHomeFolder {
    return NSHomeDirectory();
}

@end
