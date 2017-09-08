//
//  UIImagePickerController+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/14.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger , CCImageSaveType) {
    CCImageSaveTypeNone = 1 << 0 , // 1 save nothing , if options contains none , will ignore other save types
    CCImageSaveTypeOriginal = 1 << 1, // 2
    CCImageSaveTypeEdited = 1 << 2, // 4
    CCImageSaveTypeAll = 1 << 3 // 8 both original && edited
};

@interface UIImagePickerController (CCExtension) < UINavigationControllerDelegate , UIImagePickerControllerDelegate >

/// default : allowEditing = false;
+ (instancetype) common ;
/// default is itself .
/// note : if specific , reload method to get images will be handled by developers , extension kit will do nothing
- (instancetype) ccDelegateT : (id) delegate ;

/// default present camera , allowEditing = false;
- (instancetype) ccCameraT : (void (^)()) notAllowed ;
/// default present savedPhotosAlbum , allowEditing = false;
- (instancetype) ccSavedPhotosAlbumT : (void (^)()) notAllowed ;
/// default present photoLibrary , allowEditing = false;
- (instancetype) ccPhotoLibraryT : (void (^)()) notAllowed ;
/// allowEditing = YES ;
- (instancetype) ccEnableEditing ;
/// save specific type of images
- (instancetype) ccSave : (CCImageSaveType) type ;
/// if user cancelled
- (instancetype) ccCancel : (void (^)()) action ;
/// if an error on saving process
- (instancetype) ccErrorIn : (void (^)(NSError *error)) action ;

/// original iamge
- (instancetype) ccOriginal : (void (^)(UIImage *image)) action ;
/// edited image
/// note : only enableEditing
- (instancetype) ccEdited : (void (^)(UIImage *image , CGRect cropRect)) action ;

@end
