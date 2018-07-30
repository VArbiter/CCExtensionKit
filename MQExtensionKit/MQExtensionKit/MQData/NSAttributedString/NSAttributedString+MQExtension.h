//
//  NSAttributedString+MQExtension.h
//  MQExtensionKit
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

@import UIKit;

@interface NSAttributedString (MQExtension)

+ (NSMutableAttributedString *) mq_color : (UIColor *) color
                                  string : (NSString *) string ;
- (NSMutableAttributedString *) mq_color : (UIColor *) color ;
- (NSMutableAttributedString *) mq_operate : (NSMutableAttributedString * (^)(NSMutableAttributedString * sender)) action ;
- (NSMutableAttributedString *) mq_append_s : (NSAttributedString *) sAttr ;
- (NSMutableAttributedString *) mq_append_c : (NSString *) string ;

@end

#pragma mark - -----

@interface NSMutableAttributedString (MQExtension)

- (NSMutableAttributedString *) mq_attribute_c : (NSAttributedStringKey) sKey
                                       value : (id) value ;
- (NSMutableAttributedString *) mq_attribute_s : (NSDictionary <NSAttributedStringKey , id> *) dAttributes ;

@end

#pragma mark - -----

@interface NSString (MQExtension_AttributedString)

@property (nonatomic , readonly) NSMutableAttributedString * to_attribute;
- (NSMutableAttributedString *) mq_color : (UIColor *) color ;

@end