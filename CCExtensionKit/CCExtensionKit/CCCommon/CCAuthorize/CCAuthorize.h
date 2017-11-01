//
//  CCAuthorize.h
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger , CCSupportType) {
    CCSupportTypeNone = 0, // all access denied
    CCSupportTypeAll , // all
    CCSupportTypePhotoLibrary , // photos library
    CCSupportTypeVideo ,
    CCSupportTypeAudio
};

@interface CCAuthorize : NSObject

+ (instancetype) shared ;
/// has authorize to sepecific settings .
/// the return value for fail , decide whether if need to guide to setting pages .
- (instancetype) ccHasAuthorize : (CCSupportType) type
                        success : (void (^)(void)) success
                           fail : (BOOL (^)(void)) fail ;

@end
