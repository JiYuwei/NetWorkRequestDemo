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
        _manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _manager.responseSerializer.stringEncoding = NSUTF8StringEncoding;
        _manager.requestSerializer.timeoutInterval = 20;
        
//        [_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//        [_manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        
//        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"bilibili" ofType:@"cer"];
//        NSData * certData =[NSData dataWithContentsOfFile:cerPath];
//        NSSet * certSet = [[NSSet alloc] initWithObjects:certData, nil];
//        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:certSet];
//        securityPolicy.validatesDomainName = NO;
//        securityPolicy.allowInvalidCertificates = YES;
//        
//        _manager.securityPolicy = securityPolicy;
    }
    
    return self;
}

#pragma mark - Public

+(void)retrieveJsonUseGETfromURL:(NSString *)url parameters:(NSDictionary *)parameters success:(requestSuccessBlock)success failure:(requestFailureBlock)failure
{
    return [self retrieveJsonWithPrepare:nil finish:nil needCache:NO requestType:HTTPRequestTypeGET fromURL:url parameters:parameters success:success failure:failure];
}

+(void)retrieveJsonUsePOSTfromURL:(NSString *)url parameters:(NSDictionary *)parameters success:(requestSuccessBlock)success failure:(requestFailureBlock)failure
{
    return [self retrieveJsonWithPrepare:nil finish:nil needCache:NO requestType:HTTPRequestTypePOST fromURL:url parameters:parameters success:success failure:failure];
}

+(void)retrieveJsonWithPrepare:(prepareBlock)prepare finish:(finishBlock)finish needCache:(BOOL)needCache requestType:(HTTPRequestType)type fromURL:(NSString *)url parameters:(NSDictionary *)parameters success:(requestSuccessBlock)success failure:(requestFailureBlock)failure
{
    return [[self sharedRequest] retrieveJsonWithPrepare:prepare finish:finish needCache:needCache requestType:type fromURL:url parameters:parameters success:success failure:failure];
}

#pragma mark -

+(void)uploadImageWithURL:(NSString *)url parameters:(NSDictionary *)parameters image:(UIImage *)image isOriginal:(BOOL)original success:(requestSuccessBlock)success failure:(failureBlock)failure
{
    return [self uploadMutiImageWithURL:url parameters:parameters images:@[image] isOriginal:original progress:nil success:success failure:failure];
}

+(void)uploadMutiImageWithURL:(NSString *)url parameters:(NSDictionary *)parameters images:(NSArray <UIImage *> *)images isOriginal:(BOOL)original progress:(progressBlock)uploadProgress success:(requestSuccessBlock)success failure:(failureBlock)failure
{
    return[[self sharedRequest] uploadMutiImageWithURL:url parameters:parameters images:images isOriginal:original progress:uploadProgress success:success failure:failure];
}

#pragma mark -

+(void)uploadFileWithURL:(NSString *)url parameters:(NSDictionary *)parameters fileURL:(NSURL *)fileURL name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType progress:(progressBlock)uploadProgress success:(requestSuccessBlock)success failure:(failureBlock)failure
{
    return [[self sharedRequest] uploadFileWithURL:url parameters:parameters fileURL:fileURL name:name fileName:fileName mimeType:mimeType progress:uploadProgress success:success failure:failure];
}

#pragma mark -

+(void)downloadFileWithURL:(NSString *)url progress:(progressBlock)donloadProgress success:(void (^)(NSURLResponse *response, NSURL *filePath))success failure:(failureBlock)failure
{
    return [[self sharedRequest] downloadFileWithURL:url progress:donloadProgress success:success failure:failure];
}

#pragma mark -

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
                
//                if (json && needCache) {
//                    NSString *requestKey = [self generateRequestKey:url parameters:parameters];
//                    [[JYRequestCache sharedRequestCache] putToCache:requestKey jsonData:responseObject];
//                }
                
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
//                if (needCache) {
//                    NSString *requestKey = [self generateRequestKey:url parameters:parameters];
//                    json = [[JYRequestCache sharedRequestCache] getFromCache:requestKey];
//                }
                
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

-(void)uploadMutiImageWithURL:(NSString *)url parameters:(NSDictionary *)parameters images:(NSArray <UIImage *> *)images isOriginal:(BOOL)original progress:(progressBlock)uploadProgress success:(requestSuccessBlock)success failure:(failureBlock)failure
{
    if (!url) {
        return;
    }
    
    [_manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (images.count > 0) {
            for (NSInteger i = 0; i < images.count; i++) {
                UIImage *image = images[i];
                NSData *imageData = UIImageJPEGRepresentation(image, original?1.0:0.4);
                NSString *name = [NSString stringWithFormat:@"images"];
                NSString *fileName = [NSString stringWithFormat:@"image%ld.jpg",i];
                
                [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"image/jpeg"];
            }
        }
    } progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *json = (NSDictionary *)responseObject;
        
        if (success) {
            success(json);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

-(void)uploadFileWithURL:(NSString *)url parameters:(NSDictionary *)parameters fileURL:(NSURL *)fileURL name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType progress:(progressBlock)uploadProgress success:(requestSuccessBlock)success failure:(failureBlock)failure
{
    if (!url) {
        return;
    }
    
    [_manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileURL:fileURL name:name fileName:fileName mimeType:mimeType error:nil];
        
    } progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *json = (NSDictionary *)responseObject;
        
        if (success) {
            success(json);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

-(void)downloadFileWithURL:(NSString *)url progress:(progressBlock)donloadProgress success:(void (^)(NSURLResponse *response, NSURL *filePath))success failure:(failureBlock)failure
{
    NSURLSessionDownloadTask *downloadTask = [_manager downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] progress:donloadProgress destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).lastObject stringByAppendingPathComponent:@"Downloadfiles"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSString *savePath = [path stringByAppendingPathComponent:response.suggestedFilename];
        
        return [NSURL fileURLWithPath:savePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            if (failure) {
                failure(error);
            }
        }
        else{
            if (success) {
                success(response,filePath);
            }
        }
    }];
    
    [downloadTask resume];
}


-(NSString *)generateRequestKey:(NSString *)requestUrl parameters:(NSDictionary *)parameters
{
    NSArray *paramNames = [parameters allKeys];
    NSArray *sortedParamNames = [paramNames sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
                                 {
                                     return [obj1 compare:obj2 options:NSCaseInsensitiveSearch];
                                 }];
    
    requestUrl = [requestUrl stringByAppendingString:@"?"];
    for (NSString *paramName in sortedParamNames)
    {
        requestUrl = [requestUrl stringByAppendingFormat:@"%@=%@", paramName, [parameters objectForKey:paramName]];
    }
    
    return [requestUrl md5];
}

-(void)cancelRequestWithURL:(NSString *)url
{
    if (_manager.tasks.count == 0) {
        return;
    }
    
    for (NSURLSessionTask *task in _manager.tasks) {
        if ([task.originalRequest.URL.absoluteString isEqualToString:url]) {
            [task cancel];
            return;
        }
    }
    
//    [_manager.session getAllTasksWithCompletionHandler:^(NSArray<__kindof NSURLSessionTask *> * _Nonnull tasks) {
//        if (tasks.count == 0) {
//            return;
//        }
//        
//        for (NSURLSessionTask *task in tasks) {
//            if (!url) {
//                [task cancel];
//            }
//            else if ([task.currentRequest.URL.absoluteString isEqualToString:url]) {
//                [task cancel];
//                return;
//            }
//        }
//    }];
}

-(void)cancelAllRequest
{
    [_manager.tasks makeObjectsPerformSelector:@selector(cancel)];
}

@end

