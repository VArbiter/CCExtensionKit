//
//  NSAttributedString+CCExtension.h
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

@import UIKit;

@interface NSAttributedString (CCExtension)

+ (NSMutableAttributedString *) ccColor : (UIColor *) color
                                 string : (NSString *) string ;
- (NSMutableAttributedString *) ccColor : (UIColor *) color ;
- (NSMutableAttributedString *) ccOperate : (NSMutableAttributedString * (^)(NSMutableAttributedString * sender)) action ;
- (NSMutableAttributedString *) ccAppendS : (NSAttributedString *) sAttr ;
- (NSMutableAttributedString *) ccAppendC : (NSString *) string ;

@end

#pragma mark - -----

@interface NSMutableAttributedString (CCExtension)

- (NSMutableAttributedString *) ccAttributeC : (NSAttributedStringKey) sKey
                                       value : (id) value ;
- (NSMutableAttributedString *) ccAttributeS : (NSDictionary <NSAttributedStringKey , id> *) dAttributes ;

@end

#pragma mark - -----

@interface NSString (CCExtension_AttributedString)

@property (nonatomic , readonly) NSMutableAttributedString * toAttribute;
- (NSMutableAttributedString *) ccColor : (UIColor *) color ;

@end
