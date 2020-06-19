//
//  MQAutoTextView.m
//  MQExtensionKit
//
//  Created by 冯明庆 on 10/10/2018.
//  Copyright © 2018 冯明庆. All rights reserved.
//
#import "MQAutoTextView.h"

NSInteger MQ_ORIGIN_AUTO_TEXT_VIEW_DEFAULT_MAX_NUMBER_OF_LINES = 3;
NSInteger MQ_ORIGIN_AUTO_TEXT_VIEW_DEFAULT_MARGIN = 16;
CGFloat MQ_ORIGIN_AUTO_TEXT_VIEW_DEFAULT_FONT_SIZE = 16.f;

@interface MQAutoTextView () < UITextViewDelegate >

@property (nonatomic , strong , readwrite) MQAutoInternalTextView *text_view;

@property (nonatomic , assign) CGFloat f_max_height;
@property (nonatomic , assign) CGFloat f_min_height;
@property (nonatomic , assign) CGRect frame_previous;

@property (nonatomic , assign , readonly) CGSize size_measure_text_view ;

- (void) mq_init_setup ;
- (void) mq_make_to_fit_scroll_view ;
- (CGRect) mq_measure_frame : (CGSize) size_content ;
- (void) mq_scroll_to_bottom ;
- (CGFloat) mq_simulate_height_according_to : (NSInteger) i_line ;

@end

@implementation MQAutoTextView

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        CGRect r = (CGRect){0, 0, frame.size.width, frame.size.height};
        MQAutoInternalTextView *text_view = [[MQAutoInternalTextView alloc] initWithFrame:r];
        self.text_view = text_view;
        self.frame_previous = frame;
        [self mq_init_setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        MQAutoInternalTextView *text_view = [[MQAutoInternalTextView alloc] initWithFrame:CGRectZero];
        self.text_view = text_view;
        self.frame_previous = CGRectZero;
        [self mq_init_setup];
    }
    return self;
}

- (void) mq_init_setup {
    self.text_view.delegate = self;
    self.text_view.scrollEnabled = NO;
    self.text_view.font = [UIFont systemFontOfSize:MQ_ORIGIN_AUTO_TEXT_VIEW_DEFAULT_FONT_SIZE ];
    self.text_view.backgroundColor = [UIColor clearColor];
    [self addSubview:self.text_view];
    self.f_min_height = self.frame.size.height;
    self.i_max_number_of_lines = MQ_ORIGIN_AUTO_TEXT_VIEW_DEFAULT_MAX_NUMBER_OF_LINES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.frame_previous.size.width != self.bounds.size.width) {
        self.frame_previous = self.frame;
        [self mq_make_to_fit_scroll_view];
    }
}

- (CGSize)intrinsicContentSize {
    return [self mq_measure_frame:self.size_measure_text_view].size;
}

#pragma mark - -----

- (void) mq_make_to_fit_scroll_view {
    BOOL is_scroll_to_bottom =
    self.contentOffset.y == self.contentSize.height - self.frame.size.height;
    CGSize size_actual = [self size_measure_text_view];
    CGRect rect_old_scroll_view_frame = self.frame;
    
    CGRect frame = self.bounds;
    frame.origin = CGPointZero;
    frame.size.height = size_actual.height;
    self.text_view.frame = frame;
    self.contentSize = frame.size;
    
    CGRect rect_new_scroll_view_frame = [self mq_measure_frame:size_actual];
    
    if(rect_old_scroll_view_frame.size.height != rect_new_scroll_view_frame.size.height
       && rect_new_scroll_view_frame.size.height <= self.f_max_height) {
        [self flashScrollIndicators];
        if ([self.delegate_text_view
             respondsToSelector:@selector(mq_auto_text_view:will_change_height:)]) {
            [self.delegate_text_view mq_auto_text_view:self
                                    will_change_height:rect_new_scroll_view_frame.size.height];
        }
    }
    self.frame = rect_new_scroll_view_frame;
    
    if(is_scroll_to_bottom) { [self mq_scroll_to_bottom]; }
    
    if (rect_old_scroll_view_frame.size.height != rect_new_scroll_view_frame.size.height
        && [self.delegate_text_view
            respondsToSelector:@selector(mq_auto_text_view:did_change_height:)]) {
            [self.delegate_text_view mq_auto_text_view:self
                                     did_change_height:rect_new_scroll_view_frame.size.height];
    }
    
    [self invalidateIntrinsicContentSize];
}

- (CGRect) mq_measure_frame : (CGSize) size_content {
    CGSize size_self;
    if (size_content.height < self.f_min_height || !self.text_view.hasText) {
        size_self = (CGSize){size_content.width, self.f_min_height};
    } else if (self.f_max_height > 0 && size_content.height > self.f_max_height) {
        size_self = (CGSize){size_content.width, self.f_max_height};
    } else {
        size_self = size_content;
    }
    CGRect frame = self.frame;
    frame.size.height = size_self.height;
    return frame;
}

- (CGSize)size_measure_text_view {
    return [self.text_view sizeThatFits:(CGSize){self.bounds.size.width, CGFLOAT_MAX}];
}

- (void)mq_scroll_to_bottom{
    CGPoint offset = self.contentOffset;
    self.contentOffset = (CGPoint){offset.x, self.contentSize.height - self.frame.size.height};
}

- (CGFloat) mq_simulate_height_according_to : (NSInteger) i_line {
    NSString *s_t = self.text_view.text;
    NSMutableString *s_mutable_new = [NSMutableString stringWithString:@"-"];
    
    self.text_view.delegate = nil;
    self.text_view.hidden = YES;
    
    for (NSInteger index = 0 ; index < i_line ; index ++) {
        [s_mutable_new appendString:@"\n|W|"];
    }
    self.text_view.text = s_mutable_new;
    
    CGFloat f_margin_text_view = MQ_ORIGIN_AUTO_TEXT_VIEW_DEFAULT_MARGIN;
    CGFloat height = self.size_measure_text_view.height
    - (f_margin_text_view + self.text_view.contentInset.top + self.text_view.contentInset.bottom);
    
    self.text_view.text = s_t;
    self.text_view.hidden = NO;
    self.text_view.delegate = self;
    
    return height;
}

- (void) mq_scroll_range_to_visible : (NSRange) range {
    [self.text_view scrollRangeToVisible:range];
}

#pragma mark - -----

- (void) setView_input:(UIView *)view_input {
    self.text_view.inputView = view_input;
}
- (UIView *) view_input {
    return self.text_view.inputView;
}
- (BOOL) isFirstResponder {
    return self.text_view.isFirstResponder;
}
- (BOOL) becomeFirstResponder {
    return [self.text_view becomeFirstResponder];
}
- (BOOL) resignFirstResponder {
    return [self.text_view resignFirstResponder];
}

#pragma mark - -----

- (void)setS_text:(NSString *)s_text {
    self.text_view.text = s_text;
    [self mq_make_to_fit_scroll_view];
}
- (NSString *)s_text {
    return self.text_view.text ;
}

- (void)setS_attributed:(NSAttributedString *)s_attributed {
    self.text_view.attributedText = s_attributed;
    [self mq_make_to_fit_scroll_view];
}
- (NSAttributedString *)s_attributed {
    return self.text_view.attributedText ;
}

- (void)setIs_allows_editing_text_attributes:(BOOL)is_allows_editing_text_attributes {
    self.text_view.allowsEditingTextAttributes = is_allows_editing_text_attributes;
}
- (BOOL)is_allows_editing_text_attributes {
    return self.text_view.allowsEditingTextAttributes ;
}

- (void)setI_min_number_of_lines:(NSInteger)i_min_number_of_lines {
    if (i_min_number_of_lines <= 0) {
        self.f_min_height = 0;
        return;
    }
    self.f_min_height = [self mq_simulate_height_according_to:i_min_number_of_lines];
    _i_min_number_of_lines = i_min_number_of_lines;
}

- (void)setI_max_number_of_lines:(NSInteger)i_max_number_of_lines {
    if (i_max_number_of_lines <= 0) {
        self.f_max_height = 0;
        return;
    }
    self.f_max_height = [self mq_simulate_height_according_to:i_max_number_of_lines];
    _i_max_number_of_lines = i_max_number_of_lines;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([self.delegate_text_view
         respondsToSelector:@selector(mq_auto_text_view:
                                      mq_should_change_text_in_range:
                                      replacement_text:)]) {
        return [self.delegate_text_view mq_auto_text_view:self
                           mq_should_change_text_in_range:range
                                         replacement_text:text];
    }
    return YES;
}

#ifdef __IPHONE_10_0
-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction
#else
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
#endif
{
    if ([self.delegate_text_view
         respondsToSelector:@selector(mq_auto_text_view:
                                      should_interact_with_url:
                                      in_range:)]) {
        return [self.delegate_text_view mq_auto_text_view:self
                                 should_interact_with_url:URL
                                                 in_range:characterRange];
    }
    return YES;
}

#ifdef __IPHONE_10_0
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction
#else
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange
#endif
{
    if ([self.delegate_text_view
         respondsToSelector:@selector(mq_auto_text_view:
                                      should_interact_with_text_attachment:
                                      in_range:)]) {
        return [self.delegate_text_view mq_auto_text_view:self
                     should_interact_with_text_attachment:textAttachment
                                                 in_range:characterRange];
    }
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([self.delegate_text_view
         respondsToSelector:@selector(mq_auto_text_view_did_begin_editing:)]) {
        [self.delegate_text_view mq_auto_text_view_did_begin_editing:self];
    }
}
- (void)textViewDidChangeSelection:(UITextView *)textView {
    if ([self.delegate_text_view
         respondsToSelector:@selector(mq_auto_text_view_did_change_selection:)]) {
        [self.delegate_text_view mq_auto_text_view_did_change_selection:self];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([self.delegate_text_view
         respondsToSelector:@selector(mq_auto_text_view_did_end_editing:)]) {
        [self.delegate_text_view mq_auto_text_view_did_end_editing:self];
    }
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([self.delegate_text_view
         respondsToSelector:@selector(mq_auto_text_view_should_begin_editing:)]) {
       return [self.delegate_text_view mq_auto_text_view_should_begin_editing:self];
    }
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if ([self.delegate_text_view
         respondsToSelector:@selector(mq_auto_text_view_should_end_editing:)]) {
        return [self.delegate_text_view mq_auto_text_view_should_end_editing:self];
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView {
    if ([self.delegate_text_view
         respondsToSelector:@selector(mq_auto_text_view_did_change:)]) {
        [self.delegate_text_view mq_auto_text_view_did_change:self];
    }
    [self mq_make_to_fit_scroll_view];
}

@end

#pragma mark - ----- ###########################################################

@interface MQAutoInternalTextView ()

@property (nonatomic , assign) BOOL is_need_display_placeholder;
- (void) mq_notification_text_did_change : (NSNotification *) sender ;
- (void) mq_update_holder_status ;

@end

@implementation MQAutoInternalTextView

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
    if ((self = [super initWithFrame:frame textContainer:textContainer])) {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter] ;
        [center addObserver:self
                   selector:@selector(mq_notification_text_did_change:)
                       name:UITextViewTextDidChangeNotification
                     object:self];
    }
    return self;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if(action == @selector(copy:)
       || action == @selector(selectAll:)
       || action == @selector(cut:)
       || action ==@selector(select:)
       || action ==@selector(paste:)) {
        return[super canPerformAction:action withSender:sender];
    }
    return NO;
}

#pragma mark - -----

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (!self.is_need_display_placeholder) {
        return;
    }
    NSMutableParagraphStyle *paragraph_style = [[NSMutableParagraphStyle alloc] init];
    paragraph_style.alignment = self.textAlignment;
    
    CGRect target_rect = CGRectMake(5,
                                    8 + self.contentInset.top,
                                    self.frame.size.width - self.contentInset.left,
                                    self.frame.size.height - self.contentInset.top);
    
    NSAttributedString *s_attr = self.s_attr_placeholder;
    [s_attr drawInRect:target_rect];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self mq_update_holder_status];
}
- (void)setS_attr_placeholder:(NSAttributedString *)s_attr_placeholder {
    _s_attr_placeholder = s_attr_placeholder;
    [self setNeedsDisplay];
}
- (void)setIs_need_display_placeholder:(BOOL)is_need_display_placeholder {
    BOOL t = _is_need_display_placeholder;
    _is_need_display_placeholder = is_need_display_placeholder;
    if (t != self.is_need_display_placeholder) {
        [self setNeedsDisplay];
    }
}

- (void) mq_update_holder_status {
    self.is_need_display_placeholder = self.text.length == 0;
}

- (void) mq_notification_text_did_change : (NSNotification *) sender {
    [self mq_update_holder_status];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
