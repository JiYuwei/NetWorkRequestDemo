//
//  BaseModel.h
//  NetWorkRequestDemo
//
//  Created by 纪宇伟 on 2017/7/16.
//  Copyright © 2017年 jyw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

+ (instancetype)model;
+ (instancetype)modelWithDictionary:(NSDictionary *)dict;

@end
