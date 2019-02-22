//
//  MQTouchableImageView.h
//  MQExtensionKit
//
//  Created by ElwinFrederick on 2018/12/17.
//  Copyright © 2018 ElwinFrederick. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MQTouchableImageView : UIImageView
/// decide which part of image can respond (above given alpha percent) . // 决定图片的哪部分可以响应 . (在给出的 透明度 之上)
/// u_percent : percent that can actually respond to user's touch (0 ~ 100) . // 用户点击相应 (取值范围 0 ~ 100)
- (instancetype )init_by : (UIImage *) image
   trigger_alpha_percent : (unsigned long long) u_percent NS_DESIGNATED_INITIALIZER ;

/// percent you gave . // 你给出的百分比 .
@property (nonatomic , assign , readonly) unsigned long long u_trigger_percent ;

/// generated bitmap info for image , only contains alpha value . // 生成的 bitmap 信息 , 只有 alpha 值 .
@property (nonatomic , strong , readonly) NSData *data_image_alpha_bitmap_info ;

@end

NS_ASSUME_NONNULL_END
