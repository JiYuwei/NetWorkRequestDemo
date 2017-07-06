//
//  ViewController.m
//  NetWorkRequestDemo
//
//  Created by 纪宇伟 on 2017/7/5.
//  Copyright © 2017年 jyw. All rights reserved.
//

#import "ViewController.h"
#import "JYNetworkRequest.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"AFNetworkingTest";
    
    NSString *url = @"http://api-dev.shwilling.com/v2/home/home_show8";
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"dd90bc78411df64e79947f8a30e535d0",@"signature",
                                     @"B29753C3A98AA69CAD388ACBEC3A9AF6",@"deviceid",
                                     @"c876e8f0f198e2fe2d7ea7b2f8f2fdb4",@"app_token",
                                     nil];
    
//    [JYNetworkRequest retrieveJsonUsePOSTfromURL:url parameters:parameters success:^(NSDictionary *json){
//        NSLog(@"%@",json);
//    } failure:^(NSError *error, BOOL needCache, NSDictionary *cachedJson) {
//        NSLog(@"%@",error);
//    }];
    
    [JYNetworkRequest retrieveJsonWithPrepare:nil finish:nil needCache:YES requestType:HTTPRequestTypePOST fromURL:url parameters:parameters success:^(NSDictionary *json) {
        NSLog(@"%@",json);
    } failure:^(NSError *error, BOOL needCache, NSDictionary *cachedJson) {
        NSLog(@"%@",error);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
