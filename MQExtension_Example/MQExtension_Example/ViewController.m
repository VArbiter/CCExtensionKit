//
//  ViewController.m
//  MQExtensionKit
//
//  Created by ElwinFrederick on 2018/7/30.
//  Copyright © 2018 ElwinFrederick. All rights reserved.
//

#import "ViewController.h"

#import "MQRouter.h"
@import MGJRouter;

@interface TestModel : NSObject < MQRouterDelegate >

@end

@implementation TestModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [MQRouter mq_add_delegate:self];
    }
    return self;
}

- (void)mq_router:(MQRouter *)router did_begin_excuting:(MQRouterRegistKey)regist_key user_info:(MQRouterPatternInfo)user_info {
    NSLog(@"model %@" , self);
}

- (void)dealloc {
    [MQRouter mq_remove_delegate:self];
}

@end

@interface ViewController () < MQRouterDelegate >

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *ss = [MGJRouter generateURLWithPattern:@"beauty&:id&:value" parameters:@[@"13" , @"14"]];
    
    NSString *sss = [MQRouter mq_generate_path_pattern:@"beauty&:id&:value" related_params:@[@"13" , @"14"]];
    
    
//    [MQRouter mq_add_delegate:self];
//    TestModel *t_1 = [[TestModel alloc] init];
//    TestModel *t_2 = [[TestModel alloc] init];
    
//    NSLog(@"%lu %@" , (unsigned long)MQRouter.ht_all_delegates.count ,
//          MQRouter.ht_all_delegates);
    
    [MQRouter mq_regist_action:mq_router_make(@"lalala") handler:^(NSDictionary *action_info) {
        NSLog(@"yes");
    }];
    [MQRouter mq_regist_action:mq_router_make(@"lalala/abcd") handler:^(NSDictionary *action_info) {
        NSLog(@"yes");
    }];
    [MQRouter mq_regist_action:mq_router_make(@"lalala/defg") handler:^(NSDictionary *action_info) {
        NSLog(@"yes");
    }];
    
//    [MQRouter mq_call:mq_router_make(@"lalala")];
    
    [MQRouter mq_regist_object:mq_router_make(@"hehe") handler:^id(NSDictionary *object_info) {
        return @{@"123" : @"456"};
    }];
    
//    NSLog(@"%@",[MQRouter mq_fetch:mq_router_make(@"hehe")]);
    
//    t_1 = nil;
//    t_2 = nil;
    
    NSLog(@"%lu %@" , (unsigned long)MQRouter.ht_all_delegates.count ,
          MQRouter.ht_all_delegates);
    
    [MQRouter mq_regist_object:mq_router_make(@"test") required:@[@"abc",@"cde"] handler:^id(NSDictionary *object_info) {
        NSLog(@"%@",object_info);
        return @{@"123" : @"456"};
    }];
    
    [MQRouter mq_regist_object:mq_router_make(@"test/hijk/lmn/opq") required:@[@"abc",@"cde"] handler:^id(NSDictionary *object_info) {
        NSLog(@"%@",object_info);
        return @{@"123" : @"456"};
    }];
    
    [MQRouter mq_regist_object:mq_router_make(@"test/rst/uvw") required:@[@"abc",@"cde"] handler:^id(NSDictionary *object_info) {
        NSLog(@"%@",object_info);
        return @{@"123" : @"456"};
    }];
    
    [MQRouter mq_regist_object:mq_router_make(@"test/rst/xyz") required:@[@"abc",@"cde"] handler:^id(NSDictionary *object_info) {
        NSLog(@"%@",object_info);
        return @{@"123" : @"456"};
    }];
    
    /*
    NSLog(@"%@",[MQRouter mq_fetch:mq_router_make(@"test?abc=1&cde=2") user_info:nil completion:^(id result) {
        
    } error:^(MQRouterRegistKey key, MQRouterPatternInfo user_info) {
        
    }]);
     */
    
    id t = [MQRouter mq_registed_paths_for_scheme:MQRouter.default_scheme];
    
    /*
    [MQRouter mq_deregist:mq_router_make(@"test")];
    
    [MQRouter mq_call:mq_router_make(@"test") user_info:nil completion:^(id result) {
        
    } error:^(MQRouterRegistKey key, MQRouterPatternInfo user_info) {
        
    }];
    
    [MQRouter mq_deregist_for_scheme:MQRouter.default_scheme];
    
    [MQRouter mq_deregist_all];
     */
    
    NSLog(@"%lu %@" , (unsigned long)MQRouter.ht_all_delegates.count ,
          MQRouter.ht_all_delegates);
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSLog(@"%lu %@" , (unsigned long)MQRouter.ht_all_delegates.count ,
//          MQRouter.ht_all_delegates);
    NSLog(@"%@" , MQRouter.router_map);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mq_router:(MQRouter *)router did_begin_excuting:(MQRouterRegistKey)regist_key user_info:(MQRouterPatternInfo)user_info {
    
}
- (void)mq_router:(MQRouter *)router excuting_complete:(MQRouterRegistKey)regist_key user_info:(MQRouterPatternInfo)user_info result:(id)result {
    
}
- (void)mq_router:(MQRouter *)router excuting_fail:(MQRouterRegistKey)regist_key user_info:(MQRouterPatternInfo)user_info error:(MQRouterError)error {
    
}
- (void)mq_router:(MQRouter *)router did_begin_searching:(MQRouterRegistKey)regist_key pattern_info:(MQRouterPatternInfo)pattern_info {
    
}
- (void)mq_router:(MQRouter *)router did_deregist_path:(MQRouterRegistKey)path {
    
}
- (void)mq_router:(MQRouter *)router did_deregist_scheme:(NSString *)scheme {
    
}
- (void)mq_router_deregist_all_complete:(MQRouter *)router {
    
}

@end
