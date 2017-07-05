//
//  JYNetworkRequest.m
//  NetWorkRequestDemo
//
//  Created by 纪宇伟 on 2017/7/5.
//  Copyright © 2017年 jyw. All rights reserved.
//

#import "JYNetworkRequest.h"
#import <AFNetworking/AFNetworking.h>

static JYNetworkRequest *request;


@interface JYNetworkRequest ()

@property(nonatomic,strong)AFHTTPSessionManager *manager;

@end


@implementation JYNetworkRequest

+(instancetype)sharedRequest
{
    if (!request) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            request = [[self alloc] init];
        });
    }
    
    return request;
}

-(instancetype)init
{
    if (self = [super init]) {
        _manager = [AFHTTPSessionManager manager];
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _manager.requestSerializer.timeoutInterval = 20;
        [_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [_manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    
    return self;
}

#pragma mark - Public

+(void)retrieveJsonWithPrepare:(prepareBlock)prepare finish:(finishBlock)finish needCache:(BOOL)needCache requestType:(HTTPRequestType)type fromURL:(NSString *)url parmeters:(NSDictionary *)parmeters success:(requestSuccessBlock)success failure:(requestFailureBlock)failure
{
    return [[self sharedRequest] retrieveJsonWithPrepare:prepare finish:finish needCache:needCache requestType:type fromURL:url parmeters:parmeters success:success failure:failure];
}


#pragma mark - Private

- (void)retrieveJsonWithPrepare:(prepareBlock)prepare finish:(finishBlock)finish needCache:(BOOL)needCache requestType:(HTTPRequestType)type fromURL:(NSString *)url parmeters:(NSDictionary *)parmeters success:(requestSuccessBlock)success failure:(requestFailureBlock)failure
{
    if (!url) {
        return;
    }
    if (prepare) {
        prepare();
    }
    
//    if (needCache) {
//        NSString *requestKey = [self generateRequestKey:url parameters:parmeters];
//        
//    }
    
    switch (type) {
        case HTTPRequestTypeGET:
        {
            [_manager GET:url parameters:parmeters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (finish) {
                    finish();
                }
                
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (finish) {
                    finish();
                }
                
                
                
            }];
        }
            break;
        case HTTPRequestTypePOST:
        {
            [_manager POST:url parameters:parmeters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (finish) {
                    finish();
                }
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (finish) {
                    finish();
                }
                
                
            }];
        }
            break;
            
        default:
            break;
    }
    
}




- (NSString *)generateRequestKey:(NSString *)requestUrl parameters:(NSDictionary *)parameters
{
    NSArray *paramNames = [parameters allKeys];
    NSArray *sortedParamNames = [paramNames sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
                                 {
                                     return [obj1 compare:obj2 options:NSCaseInsensitiveSearch];
                                 }];
    
    requestUrl = [requestUrl stringByAppendingString:@"="];
    for (NSString *paramName in sortedParamNames)
    {
        requestUrl = [requestUrl stringByAppendingFormat:@"%@=%@", paramName, [parameters objectForKey:paramName]];
    }
    
    return [requestUrl md5];
}


@end

