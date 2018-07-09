//
//  UIImagePickerController+CCExtension.m
//  CCExtensionKit
//
//  Created by 冯明庆 on 2017/4/14.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UIImagePickerController+CCExtension.h"

#import "CCCommon.h"

#import <objc/runtime.h>

@implementation UIImagePickerController (CCExtension)

+ (instancetype) cc_common {
    UIImagePickerController *c = UIImagePickerController.alloc.init;
    CC_WEAK_INSTANCE(c);
    c.delegate = weak_c;
    return c;
}

- (instancetype) cc_delegate : (id) delegate {
    if (delegate) self.delegate = delegate;
    return self;
}

- (instancetype) cc_camera : (void (^)(void)) notAllowed {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        if (notAllowed) notAllowed();
        return self;
    }
    if (_CC_IS_SIMULATOR_) {
        NSLog(@"\n \
              Simulator is not support camera . \n \
              UIImagePickerController will change \"sourceType\" \
              \t from \"UIImagePickerControllerSourceTypeCamera\" \
              \t to \"UIImagePickerControllerSourceTypePhotoLibrary\". \n");
        return [self cc_photo_library:notAllowed];
    } else {
        self.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        self.showsCameraControls = YES;
        return self;
    }
}

- (instancetype) cc_saved_photos_album : (void (^)(void)) notAllowed {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        if (notAllowed) notAllowed();
        return self;
    }
    self.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    return self;
}

- (instancetype) cc_photo_library : (void (^)(void)) notAllowed {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        if (notAllowed) notAllowed();
        return self;
    }
    self.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    return self;
}

- (instancetype) cc_enable_editing {
    self.allowsEditing = YES;
    return self;
}

- (instancetype) cc_save : (CCImageSaveType) type {
    objc_setAssociatedObject(self, "_CC_IMAGE_PICKER_SAVE_TYPE_", @(type), OBJC_ASSOCIATION_ASSIGN);
    return self;
}

- (instancetype) cc_cancel : (void (^)(void)) action {
    objc_setAssociatedObject(self, "_CC_IMAGE_PICKER_USER_DID_CANCEL_", action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return self;
}

- (instancetype) cc_error_in : (void (^)(NSError *error)) action {
    objc_setAssociatedObject(self, "_CC_IMAGE_PICKER_SAVING_ERROR_", action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return self;
}

- (instancetype) cc_original : (void (^)(UIImage *image)) action {
    objc_setAssociatedObject(self, "_CC_IMAGE_PICKER_GET_ORIGINAL_IMAGE_", action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return self;
}

- (instancetype) cc_edited : (void (^)(UIImage *image , CGRect cropRect)) action {
    objc_setAssociatedObject(self, "_CC_IMAGE_PICKER_GET_EDITED_IMAGE_", action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return self;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    CCImageSaveType type = [objc_getAssociatedObject(self, "_CC_IMAGE_PICKER_SAVE_TYPE_") intValue];
    if (type & CCImageSaveTypeNone) return ;
    __weak typeof(self) pSelf = self;
    void (^o)(void) = ^ {
        UIImageWriteToSavedPhotosAlbum(info[@"UIImagePickerControllerOriginalImage"],
                                       self,
                                       @selector(image:didFinishSavingWithError:contextInfo:),
                                       nil);
        void (^t)(UIImage *) = objc_getAssociatedObject(pSelf, "_CC_IMAGE_PICKER_GET_ORIGINAL_IMAGE_");
        if (t) t(info[@"UIImagePickerControllerOriginalImage"]);
    };
    void (^e)(void) = ^ {
        UIImageWriteToSavedPhotosAlbum(info[@"UIImagePickerControllerEditedImage"],
                                       self,
                                       @selector(image:didFinishSavingWithError:contextInfo:),
                                       nil);
        void (^t)(UIImage *, CGRect) = objc_getAssociatedObject(pSelf, "_CC_IMAGE_PICKER_GET_EDITED_IMAGE_");
        if (t) t(info[@"UIImagePickerControllerEditedImage"] , [info[@"UIImagePickerControllerCropRect"] CGRectValue]);
    };
    
    if (type & CCImageSaveTypeAll) {
        if (o) o();
        if (e) e();
    }
    else if (type & CCImageSaveTypeOriginal) {
        if (o) o();
    }
    else if (type & CCImageSaveTypeEdited) {
        if (e) e();
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    void (^t)(void) = objc_getAssociatedObject(self, "_CC_IMAGE_PICKER_USER_DID_CANCEL_");
    if (t) t();
}

- (void)image:(UIImage *)image
didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo{
    void (^t)(NSError *) = objc_getAssociatedObject(self, "_CC_IMAGE_PICKER_SAVING_ERROR_");
    if (t) t(error);
}

_CC_DETECT_DEALLOC_

@end
