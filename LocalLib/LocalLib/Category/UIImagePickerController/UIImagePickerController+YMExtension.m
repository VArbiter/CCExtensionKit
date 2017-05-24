//
//  UIImagePickerController+YMExtension.m
//  ym_sell_ios
//
//  Created by 冯明庆 on 2017/4/14.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UIImagePickerController+YMExtension.h"
#import "YMCommonDefine.h"

#import <objc/runtime.h>
#import "YMCommonTools.h"

const char * _YM_IMAGE_PICKER_BLOCK_COMPLETE_HANDLER_KEY_ ;
const char * _YM_IMAGE_PICKER_BLOCK_CANCEL_KEY_;
const char * _YM_IMAGE_PICKER_BLOCK_SAVE_ERROR_KEY ;

@implementation UIImagePickerController (YMExtension)

- (instancetype) ymImagePickerWithType : (YMImagePickerPresentType) typePresent
                   withCompleteHandler : (BlockCompleteHandler) blockComplete
                            withCancel : (BlockCancelPick) blockCancel
                         withSaveError : (BlockSaveError) blockError {
    NSArray *arraySupport = self.ymSupportType;
    if ([arraySupport containsObject:@(YMImagePickerSupportTypeNone)]) {
        _YM_Safe_UI_Block_(blockComplete, ^{
            blockComplete(nil , nil , CGRectNull , arraySupport);
        });
        return nil;
    }
    BOOL isSupportAll = [arraySupport containsObject:@(YMImagePickerSupportTypeAll)];
    YMImagePickerSupportType typeUnsupport = -1;
    
    switch (typePresent) {
        case YMImagePickerPresentTypeNone:{
            return nil;
        }break;
        case YMImagePickerPresentTypeCamera:{
            if (isSupportAll || [arraySupport containsObject:@(YMImagePickerPresentTypeCamera)]) {
                self.sourceType = UIImagePickerControllerSourceTypeCamera;
                self.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
                self.showsCameraControls = YES;
            }
            else typeUnsupport = YMImagePickerSupportTypeCamera;
        }break;
        case YMImagePickerPresentTypePhotosAlbum:{
            if (isSupportAll || [arraySupport containsObject:@(YMImagePickerPresentTypePhotosAlbum)]) {
                self.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
            else typeUnsupport = YMImagePickerSupportTypePhotosAlbum;
        }break;
        case YMImagePickerPresentTypePhotoLibrary:{
            if (isSupportAll || [arraySupport containsObject:@(YMImagePickerPresentTypePhotoLibrary)]) {
                self.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            else typeUnsupport = YMImagePickerSupportTypePhotoLibrary;
        }break;
            
        default:{
            return nil;
        }break;
    }
    if ((NSInteger) typeUnsupport > 0) {
        _YM_Safe_UI_Block_(blockComplete, ^{
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
    ymWeakSelf;
    _YM_Safe_UI_Block_(self.blockCompleteHandler, ^{
        NSArray *arraySupport = pSelf.ymSupportType;
        YMImageSaveType typeSave = pSelf.blockCompleteHandler(info[@"UIImagePickerControllerOriginalImage"],
                                                              info[@"UIImagePickerControllerEditedImage"],
                                                              [info[@"UIImagePickerControllerCropRect"] CGRectValue],
                                                              arraySupport);
        
        switch (typeSave) {
            case YMImageSaveTypeNone:{
                return ;
            }break;
            case YMImageSaveTypeOriginalImage:{
                UIImageWriteToSavedPhotosAlbum(info[@"UIImagePickerControllerOriginalImage"],
                                               self,
                                               @selector(image:didFinishSavingWithError:contextInfo:),
                                               nil);
            }break;
            case YMImageSaveTypeEditedImage:{
                UIImageWriteToSavedPhotosAlbum(info[@"UIImagePickerControllerEditedImage"],
                                               self,
                                               @selector(image:didFinishSavingWithError:contextInfo:), nil);
            }break;
                
            case YMImageSaveTypeAll:{
                UIImageWriteToSavedPhotosAlbum(info[@"UIImagePickerControllerEditedImage"],
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
    ymWeakSelf;
    _YM_Safe_UI_Block_(self.blockCancelPick, ^{
        pSelf.blockCancelPick();
    });
}

- (void)image:(UIImage *)image
didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo {
    ymWeakSelf;
    if (error) {
        _YM_Safe_Block_(self.blockSaveError, ^{
            pSelf.blockSaveError(error);
        });
    }
}

- (NSArray *) ymSupportType {
    if (![YMCommonTools ymHasAccessToAlbum] || ![YMCommonTools ymHasAccessToCamera]) {
        return @[@(YMImagePickerSupportTypeNone)];
    }
    NSMutableArray *array = [NSMutableArray array];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [array addObject:@(YMImagePickerSupportTypePhotoLibrary)];
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        [array addObject:@(YMImagePickerSupportTypePhotosAlbum)];
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [array addObject:@(YMImagePickerSupportTypeCamera)];
    }
    if (array.count == 3) {
        return @[@(YMImagePickerSupportTypeAll)];
    }
    else if (!array.count) {
        return @[@(YMImagePickerSupportTypeNone)];
    }
    else return array;
}

- (void)setBlockCompleteHandler:(BlockCompleteHandler)blockCompleteHandler {
    objc_setAssociatedObject(self, &_YM_IMAGE_PICKER_BLOCK_COMPLETE_HANDLER_KEY_, blockCompleteHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (BlockCompleteHandler)blockCompleteHandler {
    return objc_getAssociatedObject(self, &_YM_IMAGE_PICKER_BLOCK_COMPLETE_HANDLER_KEY_);
}

- (void)setBlockCancelPick:(BlockCancelPick)blockCancelPick {
    objc_setAssociatedObject(self, &_YM_IMAGE_PICKER_BLOCK_CANCEL_KEY_, blockCancelPick, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (BlockCancelPick)blockCancelPick {
    return objc_getAssociatedObject(self, &_YM_IMAGE_PICKER_BLOCK_CANCEL_KEY_);
}

- (void)setBlockSaveError:(BlockSaveError)blockSaveError {
    objc_setAssociatedObject(self, &_YM_IMAGE_PICKER_BLOCK_SAVE_ERROR_KEY, blockSaveError, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (BlockSaveError)blockSaveError {
    return objc_getAssociatedObject(self, &_YM_IMAGE_PICKER_BLOCK_SAVE_ERROR_KEY);
}

_YM_DETECT_DEALLOC_

@end
