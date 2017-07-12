//
//  JYNetworkRequest.h
//  NetWorkRequestDemo
//
//  Created by 纪宇伟 on 2017/7/5.
//  Copyright © 2017年 jyw. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HTTPRequestType) {
    HTTPRequestTypeGET,
    HTTPRequestTypePOST
};

typedef void(^prepareBlock)();
typedef void(^finishBlock)();
typedef void(^requestSuccessBlock) (NSDictionary *json);
typedef void(^requestFailureBlock) (NSError *error,BOOL needCache,NSDictionary *cachedJson);


@interface JYNetworkRequest : NSObject


+(void)retrieveJsonUseGETfromURL:(NSString *)url
                         success:(requestSuccessBlock)success
                         failure:(requestFailureBlock)failure;

+(void)retrieveJsonUsePOSTfromURL:(NSString *)url
                       parameters:(NSDictionary *)parameters
                          success:(requestSuccessBlock)success
                          failure:(requestFailureBlock)failure;



+(void)retrieveJsonWithPrepare:(prepareBlock)prepare
                        finish:(finishBlock)finish
                     needCache:(BOOL)needCache
                   requestType:(HTTPRequestType)type
                       fromURL:(NSString *)url
                     parameters:(NSDictionary *)parameters
                       success:(requestSuccessBlock)success
                       failure:(requestFailureBlock)failure;

+(void)cancelRequestWithURL:(NSString *)url;

+(void)cancelAllRequest;

@end


@interface NSString (md5)
- (NSString *) md5;
@end

#import<CommonCrypto/CommonDigest.h>

@implementation NSString (md5)

- (NSString *)md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr),result);
    NSMutableString *md5Str =[NSMutableString string];
    for (int i = 0; i < 16; i++)
        [md5Str appendFormat:@"%02X", result[i]];
    
    return [md5Str uppercaseString];
}

@end
