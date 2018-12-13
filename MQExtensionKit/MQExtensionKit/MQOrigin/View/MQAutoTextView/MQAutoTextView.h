//
//  MQAutoTextView.h
//  MQExtensionKit
//
//  Created by 冯明庆 on 10/10/2018.
//  Copyright © 2018 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MQAutoTextView , MQAutoInternalTextView;

@protocol MQAutoTextViewDelegate <NSObject>

@optional

- (BOOL) mq_auto_text_view : (MQAutoTextView *) text_view
mq_should_change_text_in_range : (NSRange) range
          replacement_text : (NSString *) text ;

- (BOOL) mq_auto_text_view : (MQAutoTextView *) text_view
  should_interact_with_url : (NSURL *)url
                  in_range : (NSRange) range ;

- (BOOL) mq_auto_text_view : (MQAutoTextView *) text_view
should_interact_with_text_attachment : (NSTextAttachment *) attachment
                  in_range : (NSRange) range;

- (BOOL) mq_auto_text_view_should_begin_editing : (MQAutoTextView *) text_view ;
- (BOOL) mq_auto_text_view_should_end_editing : (MQAutoTextView *) text_view ;

- (void) mq_auto_text_view_did_begin_editing : (MQAutoTextView *) text_view ;
- (void) mq_auto_text_view_did_end_editing : (MQAutoTextView *) text_view ;

- (void) mq_auto_text_view_did_change_selection : (MQAutoTextView *) text_view ;

- (void) mq_auto_text_view_did_change : (MQAutoTextView *) text_view ;

- (void) mq_auto_text_view : (MQAutoTextView *) text_view
        will_change_height : (CGFloat) f_height;
- (void) mq_auto_text_view : (MQAutoTextView *) text_view
         did_change_height : (CGFloat) f_height;

@end

FOUNDATION_EXPORT NSInteger MQ_ORIGIN_AUTO_TEXT_VIEW_DEFAULT_MAX_NUMBER_OF_LINES ;
FOUNDATION_EXPORT NSInteger MQ_ORIGIN_AUTO_TEXT_VIEW_DEFAULT_MARGIN;
FOUNDATION_EXPORT CGFloat MQ_ORIGIN_AUTO_TEXT_VIEW_DEFAULT_FONT_SIZE;

@interface MQAutoTextView : UIScrollView

@property (nonatomic , assign) id < MQAutoTextViewDelegate > delegate_text_view;
@property (nonatomic , strong , readonly) MQAutoInternalTextView *text_view;

@property (nonatomic , assign) NSInteger i_min_number_of_lines;
@property (nonatomic , assign) NSInteger i_max_number_of_lines;
@property (nonatomic , strong) UIView *view_input;

@property (nonatomic , copy) NSString * s_text ;
@property (nonatomic , copy) NSAttributedString *s_attributed ;
@property (nonatomic , assign) BOOL is_allows_editing_text_attributes ;

- (void) mq_scroll_range_to_visible : (NSRange) range ;

@end

#pragma mark - ----- ###########################################################

@interface MQAutoInternalTextView : UITextView

@property (nonatomic , strong) NSAttributedString * s_attr_placeholder ;

@end
