//
//  NSFileManager+CCExtension.h
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSInteger const _CC_FILE_HASH_DEFAULT_CHUNK_SIZE_;

@interface NSFileManager (CCExtension)

@property (nonatomic , class , readonly) NSString *sHomeDirectory;
@property (nonatomic , class , readonly) NSString *sTempDirectory;
@property (nonatomic , class , readonly) NSString *sCacheDirectory;
@property (nonatomic , class , readonly) NSString *sLibraryDirectory;

- (BOOL) ccIsDirectoryT : (NSString *) sPath ;
- (BOOL) ccExistsT : (NSString *) sPath ;
- (BOOL) ccRemoveT : (NSString *) sPath ;
/// create if not exists . // 如果不存在就创建
- (BOOL) ccCreateFolderT : (NSString *) sPath ;
- (BOOL) ccMoveT : (NSString *) sFrom
              to : (NSString *) sTo ;

/// note : in iOS , 1G == 1000Mb == 1000 * 1000kb == 1000 * 1000 * 1000b
/// note : in iOS (for bytes) , 1G = pow(10, 9) , 1Mb = pow(10, 6) , 1Kb = pow(10, 3)
/// note : highly recommend put it in a sub thread . (if sPath point at a directory) // 如果 sPath 是一个文件夹 , 建议把它放在子线程中
- (unsigned long long) ccFileSizeT : (NSString *) sPath ;
- (unsigned long long) ccFolderSizeT : (NSString *) sPath ;

/// note : if self is a folder or not valued path at all , returns @"" // 如果 self 是一个文件夹 , 或者路径是无效的 , 返回 @""
- (NSString *) ccMD5Auto : (NSString *) sPath ;
- (NSString *) ccMD5Normal : (NSString *) sPath ;
- (NSString *) ccMD5Large : (NSString *) sPath ;
- (NSString *) ccMimeType : (NSString *) sPath ;

@end

#pragma mark - -----

@interface NSString (CCExtension_File_Extension)

@property (nonatomic , readonly) BOOL isDirectoryT ;
@property (nonatomic , readonly) BOOL isExistsT ;
@property (nonatomic , readonly) BOOL removeT ;
@property (nonatomic , readonly) BOOL createFolderT ;

/// note : highly recommend put it in a sub thread . (if self point at a directory) // 如果 字符串 是一个文件夹 , 建议把它放在子线程中
@property (nonatomic , readonly) unsigned long long fileSizeT ;
@property (nonatomic , readonly) unsigned long long folderSizeT ;

- (BOOL) ccMoveTo : (NSString *) sTo ;

/// note : if self is a folder or not valued path at all , returns @"" rather than it self . // 如果 字符串 是一个文件夹 , 或者路径是无效的 , 返回 @"" 而不是它本身
@property (nonatomic , readonly) NSString *mimeType ;
@property (nonatomic , readonly) NSString *fileAutoMD5 ;
@property (nonatomic , readonly) NSString *fileMD5 ;
@property (nonatomic , readonly) NSString *largeFileMD5 ;

@end
