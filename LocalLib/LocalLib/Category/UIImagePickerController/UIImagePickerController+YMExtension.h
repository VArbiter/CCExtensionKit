//
//  UIImagePickerController+YMExtension.h
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/4/14.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , YMImagePickerSupportType) {
    YMImagePickerSupportTypeNone = 0, // 用户锁定访问权限
    YMImagePickerSupportTypeAll , // 所有
    YMImagePickerSupportTypePhotoLibrary , // 图库
    YMImagePickerSupportTypeCamera , // 相机
    YMImagePickerSupportTypePhotosAlbum // 相册 (保存图片)
};

typedef NS_ENUM(NSInteger , YMImagePickerPresentType) {
    YMImagePickerPresentTypeNone = 0 , // 无操作
    YMImagePickerPresentTypeCamera , // 弹出相机
    YMImagePickerPresentTypePhotoLibrary , // 弹出图库
    YMImagePickerPresentTypePhotosAlbum , // 弹出相册
};

typedef NS_ENUM(NSInteger , YMImageSaveType) {
    YMImageSaveTypeNone = 0 ,
    YMImageSaveTypeOriginalImage ,
    YMImageSaveTypeEditedImage ,
    YMImageSaveTypeAll 
};

/// image 存在 , arrayTypes 是支持类型集合 , 不存在是不支持类型集合
typedef void (^BlockSaveError)(NSError *error);
typedef YMImageSaveType (^BlockCompleteHandler)(UIImage *imageOrigin , UIImage *imageEdited , CGRect rectCrop , NSArray <NSNumber *> * arrayTypes); // YES 保存到相册
typedef void(^BlockCancelPick)();

@interface UIImagePickerController (YMExtension) < UINavigationControllerDelegate , UIImagePickerControllerDelegate >

- (instancetype) ymImagePickerWithType : (YMImagePickerPresentType) typePresent
                   withCompleteHandler : (BlockCompleteHandler) blockComplete
                            withCancel : (BlockCancelPick) blockCancel
                         withSaveError : (BlockSaveError) blockError;
- (NSArray *) ymSupportType ;

@property (nonatomic , copy) BlockCompleteHandler blockCompleteHandler ;
@property (nonatomic , copy) BlockCancelPick blockCancelPick ;
@property (nonatomic , copy) BlockSaveError blockSaveError ;

@end
