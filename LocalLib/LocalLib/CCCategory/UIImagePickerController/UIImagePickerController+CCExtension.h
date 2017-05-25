//
//  UIImagePickerController+CCExtension.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/14.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , CCImagePickerSupportType) {
    CCImagePickerSupportTypeNone = 0, // 用户锁定访问权限
    CCImagePickerSupportTypeAll , // 所有
    CCImagePickerSupportTypePhotoLibrary , // 图库
    CCImagePickerSupportTypeCamera , // 相机
    CCImagePickerSupportTypePhotosAlbum // 相册 (保存图片)
};

typedef NS_ENUM(NSInteger , CCImagePickerPresentType) {
    CCImagePickerPresentTypeNone = 0 , // 无操作
    CCImagePickerPresentTypeCamera , // 弹出相机
    CCImagePickerPresentTypePhotoLibrary , // 弹出图库
    CCImagePickerPresentTypePhotosAlbum , // 弹出相册
};

typedef NS_ENUM(NSInteger , CCImageSaveType) {
    CCImageSaveTypeNone = 0 ,
    CCImageSaveTypeOriginalImage ,
    CCImageSaveTypeEditedImage ,
    CCImageSaveTypeAll 
};

/// image 存在 , arrayTypes 是支持类型集合 , 不存在是不支持类型集合
typedef void (^BlockSaveError)(NSError *error);
typedef CCImageSaveType (^BlockCompleteHandler)(UIImage *imageOrigin , UIImage *imageEdited , CGRect rectCrop , NSArray <NSNumber *> * arrayTypes); // YES 保存到相册
typedef void(^BlockCancelPick)();

@interface UIImagePickerController (CCExtension) < UINavigationControllerDelegate , UIImagePickerControllerDelegate >

- (instancetype) ccImagePickerWithType : (CCImagePickerPresentType) typePresent
                   withCompleteHandler : (BlockCompleteHandler) blockComplete
                            withCancel : (BlockCancelPick) blockCancel
                         withSaveError : (BlockSaveError) blockError;
- (NSArray *) ccSupportType ;

@property (nonatomic , copy) BlockCompleteHandler blockCompleteHandler ;
@property (nonatomic , copy) BlockCancelPick blockCancelPick ;
@property (nonatomic , copy) BlockSaveError blockSaveError ;

@end
