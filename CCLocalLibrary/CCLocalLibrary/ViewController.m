//
//  ViewController.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 25/05/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "ViewController.h"

#import "CCCommonViewTools.h"
#import "CCCommonDataTools.h"

#import "CCCommonTools.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image = [ccImageCache(@"0ZG63407-0") ccGaussianImageAcc:_CC_GAUSSIAN_BLUR_VALUE_ iterationCount:100 tint:nil];
    UIImageView *imageView = [UIImageView ccCommon:CGRectZero image:image enable:false];
    imageView.y = 80;
    imageView.size = [image ccZoom:0.5];
    
    [self.view addSubview:imageView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
