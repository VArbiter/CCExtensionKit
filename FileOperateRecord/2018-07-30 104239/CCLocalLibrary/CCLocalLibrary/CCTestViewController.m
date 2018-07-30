//
//  CCTestViewController.m
//  CCExtensionKit
//
//  Created by 冯明庆 on 22/10/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "CCTestViewController.h"

#import "UIViewController+CCExtension.h"

@interface CCTestViewController ()

@end

@implementation CCTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self cc_enable_pushing_poping_style_when_present_or_dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self cc_dismiss];
}

@end
