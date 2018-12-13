//
//  UIImagePickerController+MQExtension.m
//  MQExtensionKit
//
//  Created by 冯明庆 on 2017/4/14.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UIImagePickerController+MQExtension.h"

#import "MQCommon.h"

#import <objc/runtime.h>

@implementation UIImagePickerController (MQExtension)

+ (instancetype) mq_common {
    UIImagePickerController *c = UIImagePickerController.alloc.init;
    MQ_WEAK_INSTANCE(c);
    c.delegate = weak_c;
    return c;
}

- (instancetype) mq_delegate : (id) delegate {
    if (delegate) self.delegate = delegate;
    return self;
}

- (instancetype) mq_camera : (void (^)(void)) not_allowed {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        if (not_allowed) not_allowed();
        return self;
    }
    if (mq_is_simulator()) {
        NSLog(@"\n \
              Simulator is not support camera . \n \
              UIImagePickerController will change \"sourceType\" \
              \t from \"UIImagePickerControllerSourceTypeCamera\" \
              \t to \"UIImagePickerControllerSourceTypePhotoLibrary\". \n");
        return [self mq_photo_library:not_allowed];
    } else {
        self.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        self.showsCameraControls = YES;
        return self;
    }
}

- (instancetype) mq_saved_photos_album : (void (^)(void)) not_allowed {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        if (not_allowed) not_allowed();
        return self;
    }
    self.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    return self;
}

- (instancetype) mq_photo_library : (void (^)(void)) not_allowed {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        if (not_allowed) not_allowed();
        return self;
    }
    self.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    return self;
}

- (instancetype) mq_enable_editing {
    self.allowsEditing = YES;
    return self;
}

- (instancetype) mq_save : (MQImageSaveType) type {
    objc_setAssociatedObject(self, "_MQ_IMAGE_PICKER_SAVE_TYPE_", @(type), OBJC_ASSOCIATION_ASSIGN);
    return self;
}

- (instancetype) mq_cancel : (void (^)(void)) action {
    objc_setAssociatedObject(self, "_MQ_IMAGE_PICKER_USER_DID_CANCEL_", action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return self;
}

- (instancetype) mq_error_in : (void (^)(NSError *error)) action {
    objc_setAssociatedObject(self, "_MQ_IMAGE_PICKER_SAVING_ERROR_", action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return self;
}

- (instancetype) mq_original : (void (^)(UIImage *image)) action {
    objc_setAssociatedObject(self, "_MQ_IMAGE_PICKER_GET_ORIGINAL_IMAGE_", action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return self;
}

- (instancetype) mq_edited : (void (^)(UIImage *image , CGRect cropRect)) action {
    objc_setAssociatedObject(self, "_MQ_IMAGE_PICKER_GET_EDITED_IMAGE_", action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return self;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    MQImageSaveType type = [objc_getAssociatedObject(self, "_MQ_IMAGE_PICKER_SAVE_TYPE_") intValue];
    if (type & MQImageSaveTypeNone) return ;
    __weak typeof(self) weak_self = self;
    void (^o)(void) = ^ {
        __strong typeof(weak_self) strong_self = weak_self;
        UIImageWriteToSavedPhotosAlbum(info[@"UIImagePickerControllerOriginalImage"],
                                       strong_self,
                                       @selector(image:didFinishSavingWithError:contextInfo:),
                                       nil);
        void (^t)(UIImage *) = objc_getAssociatedObject(strong_self, "_MQ_IMAGE_PICKER_GET_ORIGINAL_IMAGE_");
        if (t) t(info[@"UIImagePickerControllerOriginalImage"]);
    };
    void (^e)(void) = ^ {
        __strong typeof(weak_self) strong_self = weak_self;
        UIImageWriteToSavedPhotosAlbum(info[@"UIImagePickerControllerEditedImage"],
                                       self,
                                       @selector(image:didFinishSavingWithError:contextInfo:),
                                       nil);
        void (^t)(UIImage *, CGRect) = objc_getAssociatedObject(strong_self, "_MQ_IMAGE_PICKER_GET_EDITED_IMAGE_");
        if (t) t(info[@"UIImagePickerControllerEditedImage"] , [info[@"UIImagePickerControllerCropRect"] CGRectValue]);
    };
    
    if (type & MQImageSaveTypeAll) {
        if (o) o();
        if (e) e();
    }
    else if (type & MQImageSaveTypeOriginal) {
        if (o) o();
    }
    else if (type & MQImageSaveTypeEdited) {
        if (e) e();
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    void (^t)(void) = objc_getAssociatedObject(self, "_MQ_IMAGE_PICKER_USER_DID_CANCEL_");
    if (t) t();
}

- (void)image:(UIImage *)image
didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo{
    void (^t)(NSError *) = objc_getAssociatedObject(self, "_MQ_IMAGE_PICKER_SAVING_ERROR_");
    if (t) t(error);
}

MQ_DETECT_DEALLOC

@end
