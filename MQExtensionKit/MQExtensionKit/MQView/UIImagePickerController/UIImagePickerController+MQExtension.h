//
//  UIImagePickerController+MQExtension.h
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/4/14.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger , MQImageSaveType) {
    /// 1 save nothing , if options contains none , will ignore other save types // 什么也不保存 , 如果选项包含了它 , 将会无视掉其他类型
    MQImageSaveTypeNone = 1 << 0 ,
    /// 2
    MQImageSaveTypeOriginal = 1 << 1,
    /// 4
    MQImageSaveTypeEdited = 1 << 2,
    /// 8 both original && edited // 原来的 和 编辑过的
    MQImageSaveTypeAll = 1 << 3
};

@interface UIImagePickerController (MQExtension) < UINavigationControllerDelegate , UIImagePickerControllerDelegate >

/// default : allowEditing = false; // 默认不允许编辑
+ (instancetype) mq_common ;
/// default is itself . // 默认是它本身
/// note : if specific , reload method to get images will be handled by developers , extension kit will do nothing // 如果指定 , 重载方法将会交由开发者控制 , 框架将不会做任何事情
- (instancetype) mq_delegate : (id) delegate ;

/// default present camera , allowEditing = false; // 默认照相机 , 不能编辑
- (instancetype) mq_camera : (void (^)(void)) not_allowed ;
/// default present savedPhotosAlbum , allowEditing = false; // 默认保存图片相册 , 不能编辑
- (instancetype) mq_saved_photos_album : (void (^)(void)) not_allowed ;
/// default present photoLibrary , allowEditing = false; // 默认 图库 , 不能编辑
- (instancetype) mq_photo_library : (void (^)(void)) not_allowed ;
/// allowEditing = YES ; // 启用编辑
- (instancetype) mq_enable_editing ;
/// save specific type of images // 保存 图片
- (instancetype) mq_save : (MQImageSaveType) type ;
/// if user cancelled // 如果用户取消了操作
- (instancetype) mq_cancel : (void (^)(void)) action ;
/// if an error on saving process // 如果处理过程中出现了错误
- (instancetype) mq_error_in : (void (^)(NSError *error)) action ;

/// original iamge // 原始 image
- (instancetype) mq_original : (void (^)(UIImage *image)) action ;
/// edited image // 编辑过后的 image
/// note : only enableEditing // 前提是启用编辑
- (instancetype) mq_edited : (void (^)(UIImage *image , CGRect cropRect)) action ;

@end
