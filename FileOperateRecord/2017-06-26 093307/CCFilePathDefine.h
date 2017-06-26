//
//  CCFilePathDefine.h
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/7.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#ifndef CCFilePathDefine_h
#define CCFilePathDefine_h

// 使用 userDefault 储存当前处理过后的背景图片 (路径). (模糊处理)
#define _CC_SHOP_BACKGROUND_IMAGE_NAME_KEY_ @"CC_SHOP_BACKGROUND_IMAGE_NAME_KEY"

static inline NSString *_CC_CACHE_PROCESSED_IMAGE_FILE_FOLDER_() {
    return [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
                                                 NSUserDomainMask,
                                                 YES)
             firstObject]
            stringByAppendingPathComponent:@"CCProcessedImage"];
}

#endif
