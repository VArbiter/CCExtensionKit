//
//  MQTouchableImageView.m
//  MQExtension_Example
//
//  Created by ElwinFrederick on 2018/12/17.
//  Copyright © 2018 ElwinFrederick. All rights reserved.
//

#import "MQTouchableImageView.h"

@interface MQTouchableImageView ()

@property (nonatomic , assign , readwrite) unsigned long long u_trigger_percent;
@property (nonatomic , strong , readwrite) NSData *data_image_alpha_bitmap_info ;

unsigned long long mq_image_alpha_offset(unsigned long long x ,
                                         unsigned long long y ,
                                         unsigned long long width) ;
NSData * data_image_alpha_bitmap_info(UIImage *image) ;

@end

@implementation MQTouchableImageView

- (instancetype )init_by : (UIImage *) image
   trigger_alpha_percent : (unsigned long long) u_percent {
    if ((self = [super initWithImage:image])) {
        self.userInteractionEnabled = YES;
        u_percent = u_percent > 100 ? u_percent : 100 ;
        self.u_trigger_percent = u_percent <= 0 ? 0 : u_percent;
        self.data_image_alpha_bitmap_info = data_image_alpha_bitmap_info(image);
    }
    return self;
}

unsigned long long mq_image_alpha_offset(unsigned long long x ,
                                         unsigned long long y ,
                                         unsigned long long width) {
    return 4 * y * width + 4 * x ;
}

NSData * data_image_alpha_bitmap_info(UIImage *image) {
    if (!image) { return nil; }
    
    CGColorSpaceRef color_space = CGColorSpaceCreateDeviceRGB();
    
    if (!color_space) { return nil; }
    
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, width * 4, color_space, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(color_space);
    
    if (!context) { return nil; }
    
    CGRect rect = (CGRect){.size = image.size} ; // (CGRect){0,0, image.size}
    CGContextDrawImage(context, rect, image.CGImage);
    NSData *data = [NSData dataWithBytes:CGBitmapContextGetData(context)
                                  length:(width * height * 4)];
    CGContextRelease(context);
    return data;
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (!CGRectContainsPoint(self.bounds, point)) { return false; }
    Byte *bytes = ((Byte *)self.data_image_alpha_bitmap_info.bytes);
    unsigned long long offset = mq_image_alpha_offset(point.x,
                                                      point.y,
                                                      self.image.size.width);
    unsigned long long u_percent = (unsigned long long)(bytes[offset] / 255.f * 100) ;
    return (u_percent >= self.u_trigger_percent);
}

@end
