//
//  NSAttributedString+CCExtension.h
//  CCExtensionKit
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

@import UIKit;

@interface NSAttributedString (CCExtension)

+ (NSMutableAttributedString *) cc_color : (UIColor *) color
                                  string : (NSString *) string ;
- (NSMutableAttributedString *) cc_color : (UIColor *) color ;
- (NSMutableAttributedString *) cc_operate : (NSMutableAttributedString * (^)(NSMutableAttributedString * sender)) action ;
- (NSMutableAttributedString *) cc_append_s : (NSAttributedString *) sAttr ;
- (NSMutableAttributedString *) cc_append_c : (NSString *) string ;

@end

#pragma mark - -----

@interface NSMutableAttributedString (CCExtension)

- (NSMutableAttributedString *) cc_attribute_c : (NSAttributedStringKey) sKey
                                       value : (id) value ;
- (NSMutableAttributedString *) cc_attribute_s : (NSDictionary <NSAttributedStringKey , id> *) dAttributes ;

@end

#pragma mark - -----

@interface NSString (CCExtension_AttributedString)

@property (nonatomic , readonly) NSMutableAttributedString * toAttribute;
- (NSMutableAttributedString *) cc_color : (UIColor *) color ;

@end
