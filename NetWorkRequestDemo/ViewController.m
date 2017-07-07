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
    
    NSString *url = @"https://app.bilibili.com/x/feed/index?access_key=f1f583b3c34d7eb53dfb2cd248c64ae6&actionKey=appkey&appkey=27eb53fc9058f8c3&build=5800&device=phone&idx=1494956798&mobi_app=iphone&network=wifi&open_event=&platform=ios&pull=1&sign=7280ea66a6494319d2f033b145dde8c3&style=2&ts=1499343223";
//    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"dd90bc78411df64e79947f8a30e535d0",@"signature",
//                                     @"B29753C3A98AA69CAD388ACBEC3A9AF6",@"deviceid",
//                                     @"c876e8f0f198e2fe2d7ea7b2f8f2fdb4",@"app_token",
//                                     nil];
    
//    [JYNetworkRequest retrieveJsonUsePOSTfromURL:url parameters:parameters success:^(NSDictionary *json){
//        NSLog(@"%@",json);
//    } failure:^(NSError *error, BOOL needCache, NSDictionary *cachedJson) {
//        NSLog(@"%@",error);
//    }];
    
    [self retrieveJsonUseGETWithURL:url];
}

-(void)retrieveJsonUseGETWithURL:(NSString *)url
{
    return[self retrieveJsonUseGETWithURL:url prepare:nil finsih:nil];
}

-(void)retrieveJsonUseGETWithURL:(NSString *)url prepare:(prepareBlock)prepare finsih:(finishBlock)finish
{
    [JYNetworkRequest retrieveJsonWithPrepare:prepare finish:finish needCache:YES requestType:HTTPRequestTypeGET fromURL:url parameters:@{} success:^(NSDictionary *json) {
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
