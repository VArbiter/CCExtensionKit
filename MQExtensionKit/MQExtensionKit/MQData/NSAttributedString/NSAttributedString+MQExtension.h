//
//  NSAttributedString+MQExtension.h
//  MQExtensionKit
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

@import UIKit;

@interface NSAttributedString (MQExtension)

@property (nonatomic , readonly) NSMutableAttributedString * to_mutable;
@property (nonatomic , readonly) BOOL is_mutable;

@end

#pragma mark - -----

@interface NSMutableAttributedString (MQExtension)

- (__kindof NSMutableAttributedString *) mq_attribute_c : (NSAttributedStringKey) sKey
                                       value : (id) value ;
- (__kindof NSMutableAttributedString *) mq_attribute_s : (NSDictionary <NSAttributedStringKey , id> *) dAttributes ;

+ (__kindof NSMutableAttributedString *) mq_color : (UIColor *) color
                                           string : (NSString *) string ;
- (__kindof NSMutableAttributedString *) mq_color : (UIColor *) color ;
- (__kindof NSMutableAttributedString *) mq_font : (UIFont *) font ;
- (__kindof NSMutableAttributedString *) mq_style : (void (^)(__kindof NSMutableParagraphStyle * style)) action ;
- (__kindof NSMutableAttributedString *) mq_operate : (__kindof NSMutableAttributedString * (^)(__kindof NSMutableAttributedString * sender)) action ;
- (__kindof NSMutableAttributedString *) mq_append_s : (NSAttributedString *) sAttr ;
- (__kindof NSMutableAttributedString *) mq_append_c : (NSString *) string ;

@end

#pragma mark - -----

@interface NSString (MQExtension_AttributedString)

@property (nonatomic , readonly) NSMutableAttributedString * to_attribute;

@end
