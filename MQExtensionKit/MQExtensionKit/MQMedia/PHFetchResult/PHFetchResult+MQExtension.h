//
//  PHFetchResult+MQExtension.h
//  MQExtensionKit
//
//  Created by ElwinFrederick on 21/05/2018.
//  Copyright © 2018 冯明庆. All rights reserved.
//

#import <Photos/Photos.h>

@interface PHFetchResult (CCExtension)

// return nil if results has nothing . // 如果没有任何值 , 返回 nil .
- (NSArray <PHAsset *> *) mq_filter_type : (PHAssetMediaType) type_media ;

// return nil if results has nothing . // 如果没有任何值 , 返回 nil .
@property (readonly) NSArray <PHAsset *> * array_results ;

@end
