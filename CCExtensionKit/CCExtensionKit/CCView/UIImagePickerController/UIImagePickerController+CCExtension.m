//
//  UIImagePickerController+CCExtension.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/14.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UIImagePickerController+CCExtension.h"

#import "CCCommonDefine.h"
#import "CCCommonTools.h"

#import <objc/runtime.h>

@implementation UIImagePickerController (CCExtension)

- (instancetype) ccImagePicker : (CCImagePickerPresentType) typePresent
                      complete : (BlockCompleteHandler) blockComplete
                        cancel : (BlockCancelPick) blockCancel
                     saveError : (BlockSaveError) blockError {
    NSArray *arraySupport = self.ccSupportType;
    if ([arraySupport containsObject:@(CCImagePickerSupportTypeNone)]) {
        CC_Safe_UI_Operation(blockComplete, ^{
            blockComplete(nil , nil , CGRectNull , arraySupport);
        });
        return nil;
    }
    BOOL isSupportAll = [arraySupport containsObject:@(CCImagePickerSupportTypeAll)];
    CCImagePickerSupportType typeUnsupport = -1;
    
    switch (typePresent) {
        case CCImagePickerPresentTypeNone:{
            return nil;
        }break;
        case CCImagePickerPresentTypeCamera:{
            if (isSupportAll || [arraySupport containsObject:@(CCImagePickerPresentTypeCamera)]) {
                self.sourceType = UIImagePickerControllerSourceTypeCamera;
                self.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
                self.showsCameraControls = YES;
            }
            else typeUnsupport = CCImagePickerSupportTypeCamera;
        }break;
        case CCImagePickerPresentTypePhotosAlbum:{
            if (isSupportAll || [arraySupport containsObject:@(CCImagePickerPresentTypePhotosAlbum)]) {
                self.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
            else typeUnsupport = CCImagePickerSupportTypePhotosAlbum;
        }break;
        case CCImagePickerPresentTypePhotoLibrary:{
            if (isSupportAll || [arraySupport containsObject:@(CCImagePickerPresentTypePhotoLibrary)]) {
                self.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            else typeUnsupport = CCImagePickerSupportTypePhotoLibrary;
        }break;
            
        default:{
            return nil;
        }break;
    }
    if ((NSInteger) typeUnsupport > 0) {
        CC_Safe_UI_Operation(blockComplete, ^{
            blockComplete(nil , nil , CGRectNull , @[@(typeUnsupport)]);
        });
        return nil;
    }
    
    self.delegate = self;
    self.allowsEditing = YES;
    self.blockCompleteHandler = [blockComplete copy];
    self.blockCancelPick = [blockCancel copy];
    self.blockSaveError = [blockError copy];
    return self;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    ccWeakSelf;
    CC_Safe_UI_Operation(self.blockCompleteHandler, ^{
        NSArray *arraySupport = pSelf.ccSupportType;
        CCImageSaveType typeSave = pSelf.blockCompleteHandler(info[@"UIImagePickerControllerOriginalImage"],
                                                              info[@"UIImagePickerControllerEditedImage"],
                                                              [info[@"UIImagePickerControllerCropRect"] CGRectValue],
                                                              arraySupport);
        
        switch (typeSave) {
            case CCImageSaveTypeNone:{
                return ;
            }break;
            case CCImageSaveTypeOriginalImage:{
                UIImageWriteToSavedPhotosAlbum(info[@"UIImagePickerControllerOriginalImage"],
                                               self,
                                               @selector(image:didFinishSavingWithError:contextInfo:),
                                               nil);
            }break;
            case CCImageSaveTypeEditedImage:{
                UIImageWriteToSavedPhotosAlbum(info[@"UIImagePickerControllerEditedImage"],
                                               self,
                                               @selector(image:didFinishSavingWithError:contextInfo:), nil);
            }break;
                
            case CCImageSaveTypeAll:{
                UIImageWriteToSavedPhotosAlbum(info[@"UIImagePickerControllerOriginalImage"],
                                               self,
                                               @selector(image:didFinishSavingWithError:contextInfo:),
                                               nil);
                UIImageWriteToSavedPhotosAlbum(info[@"UIImagePickerControllerEditedImage"],
                                               self,
                                               @selector(image:didFinishSavingWithError:contextInfo:),
                                               nil);
            }break;
                
            default:
                break;
        }
    });
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    ccWeakSelf;
    CC_Safe_UI_Operation(self.blockCancelPick, ^{
        pSelf.blockCancelPick();
    });
}

- (void)image:(UIImage *)image
didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo {
    ccWeakSelf;
    if (error) {
        CC_Safe_UI_Operation(self.blockSaveError, ^{
            pSelf.blockSaveError(error);
        });
    }
}

- (NSArray *) ccSupportType {
    if (![CCCommonTools ccHasAccessToAlbum] || ![CCCommonTools ccHasAccessToCamera]) {
        return @[@(CCImagePickerSupportTypeNone)];
    }
    NSMutableArray *array = [NSMutableArray array];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [array addObject:@(CCImagePickerSupportTypePhotoLibrary)];
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        [array addObject:@(CCImagePickerSupportTypePhotosAlbum)];
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [array addObject:@(CCImagePickerSupportTypeCamera)];
    }
    if (array.count == 3) {
        return @[@(CCImagePickerSupportTypeAll)];
    }
    else if (!array.count) {
        return @[@(CCImagePickerSupportTypeNone)];
    }
    else return array;
}

- (void)setBlockCompleteHandler:(BlockCompleteHandler)blockCompleteHandler {
    objc_setAssociatedObject(self, @selector(blockCompleteHandler), blockCompleteHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (BlockCompleteHandler)blockCompleteHandler {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setBlockCancelPick:(BlockCancelPick)blockCancelPick {
    objc_setAssociatedObject(self, @selector(blockCancelPick), blockCancelPick, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (BlockCancelPick)blockCancelPick {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setBlockSaveError:(BlockSaveError)blockSaveError {
    objc_setAssociatedObject(self, @selector(blockSaveError), blockSaveError, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (BlockSaveError)blockSaveError {
    return objc_getAssociatedObject(self, _cmd);
}

_CC_DETECT_DEALLOC_

@end
