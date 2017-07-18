//
//  BaseModel.m
//  NetWorkRequestDemo
//
//  Created by 纪宇伟 on 2017/7/16.
//  Copyright © 2017年 jyw. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

+ (instancetype)model
{
    return [self modelWithDictionary:nil];
}

+(instancetype)modelWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
