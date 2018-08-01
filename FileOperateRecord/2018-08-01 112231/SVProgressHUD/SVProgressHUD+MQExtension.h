//
//  SVProgressHUD+MQExtension.h
//  MQExtension_Example
//
//  Created by ElwinFrederick on 2018/8/1.
//  Copyright © 2018 ElwinFrederick. All rights reserved.
//

#if __has_include(<SVProgressHUD/SVProgressHUD.h>)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"
    @import SVProgressHUD;
#pragma clang diagnostic pop

@interface SVProgressHUD (MQExtension)

- (instancetype) mq_show ;

@end

#endif
