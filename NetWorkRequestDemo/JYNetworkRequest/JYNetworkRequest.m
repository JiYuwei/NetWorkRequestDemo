//
//  JYNetworkRequest.m
//  NetWorkRequestDemo
//
//  Created by 纪宇伟 on 2017/7/5.
//  Copyright © 2017年 jyw. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "JYNetworkRequest.h"
#import "JYRequestCache.h"

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
        _manager.responseSerializer.stringEncoding = NSUTF8StringEncoding;
        _manager.requestSerializer.timeoutInterval = 20;
        
//        [_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//        [_manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        
        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"bilibili" ofType:@"cer"];
        NSData * certData =[NSData dataWithContentsOfFile:cerPath];
        NSSet * certSet = [[NSSet alloc] initWithObjects:certData, nil];
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:certSet];
        securityPolicy.validatesDomainName = NO;
        securityPolicy.allowInvalidCertificates = YES;
        
        _manager.securityPolicy = securityPolicy;
    }
    
    return self;
}

#pragma mark - Public

+(void)retrieveJsonUseGETfromURL:(NSString *)url success:(requestSuccessBlock)success failure:(requestFailureBlock)failure
{
    return [self retrieveJsonWithPrepare:nil finish:nil needCache:NO requestType:HTTPRequestTypeGET fromURL:url parameters:[NSDictionary dictionary] success:success failure:failure];
}

+(void)retrieveJsonUsePOSTfromURL:(NSString *)url parameters:(NSDictionary *)parameters success:(requestSuccessBlock)success failure:(requestFailureBlock)failure
{
    return [self retrieveJsonWithPrepare:nil finish:nil needCache:NO requestType:HTTPRequestTypePOST fromURL:url parameters:parameters success:success failure:failure];
}

+(void)retrieveJsonWithPrepare:(prepareBlock)prepare finish:(finishBlock)finish needCache:(BOOL)needCache requestType:(HTTPRequestType)type fromURL:(NSString *)url parameters:(NSDictionary *)parameters success:(requestSuccessBlock)success failure:(requestFailureBlock)failure
{
    return [[self sharedRequest] retrieveJsonWithPrepare:prepare finish:finish needCache:needCache requestType:type fromURL:url parameters:parameters success:success failure:failure];
}

+(void)cancelRequestWithURL:(NSString *)url
{
    if (!url) {
        return;
    }
    return [[self sharedRequest] cancelRequestWithURL:url];
}

+(void)cancelAllRequest{
    return [[self sharedRequest] cancelAllRequest];
}

#pragma mark - Private

- (void)retrieveJsonWithPrepare:(prepareBlock)prepare finish:(finishBlock)finish needCache:(BOOL)needCache requestType:(HTTPRequestType)type fromURL:(NSString *)url parameters:(NSDictionary *)parameters success:(requestSuccessBlock)success failure:(requestFailureBlock)failure
{
    if (!url) {
        return;
    }
    if (prepare) {
        prepare();
    }
    
    switch (type) {
        case HTTPRequestTypeGET:
        {
            [_manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
//                NSDictionary *json = [JYRequestCache jsonData2NSDictionary:responseObject];
                NSDictionary *json = (NSDictionary *)responseObject;
                
                if (json && needCache) {
                    NSString *requestKey = [self generateRequestKey:url parameters:parameters];
                    [[JYRequestCache sharedRequestCache] putToCache:requestKey jsonDict:json];
                }
                
                if (success) {
                    success(json);
                }
                if (finish) {
                    finish();
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                if (task.error.code == NSURLErrorCancelled) {
                    if (finish) {
                        finish();
                    }
                    return;
                }
                
                NSDictionary *json = nil;
                if (needCache) {
                    NSString *requestKey = [self generateRequestKey:url parameters:parameters];
                    json = [[JYRequestCache sharedRequestCache] getFromCache:requestKey];
                }
                
                if (failure) {
                    failure(error,needCache,json);
                }
                if (finish) {
                    finish();
                }
            }];
        }
            break;
        case HTTPRequestTypePOST:
        {
            [_manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
//                NSDictionary *json = [JYRequestCache jsonData2NSDictionary:responseObject];
                NSDictionary *json = (NSDictionary *)responseObject;
                
                if (json && needCache) {
                    NSString *requestKey = [self generateRequestKey:url parameters:parameters];
                    [[JYRequestCache sharedRequestCache] putToCache:requestKey jsonData:responseObject];
                }
                
                if (success) {
                    success(json);
                }
                if (finish) {
                    finish();
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                if (task.error.code == NSURLErrorCancelled) {
                    if (finish) {
                        finish();
                    }
                    return;
                }
                
                NSDictionary *json = nil;
                if (needCache) {
                    NSString *requestKey = [self generateRequestKey:url parameters:parameters];
                    json = [[JYRequestCache sharedRequestCache] getFromCache:requestKey];
                }
                
                if (failure) {
                    failure(error,needCache,json);
                }
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

- (void)cancelRequestWithURL:(NSString *)url
{
    [_manager.session getAllTasksWithCompletionHandler:^(NSArray<__kindof NSURLSessionTask *> * _Nonnull tasks) {
        if (tasks.count == 0) {
            return;
        }
        
        for (NSURLSessionTask *task in tasks) {
            if (!url) {
                [task cancel];
            }
            else if ([task.currentRequest.URL.absoluteString isEqualToString:url]) {
                [task cancel];
                return;
            }
        }
    }];
}

-(void)cancelAllRequest
{
    [self cancelRequestWithURL:nil];
}

@end

