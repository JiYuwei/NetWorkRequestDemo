//
//  DataModel.m
//  NetWorkRequestDemo
//
//  Created by 纪宇伟 on 2017/7/7.
//  Copyright © 2017年 jyw. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

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
    if ([key isEqualToString:@"goto"]) {
        self.i_goto = value;
    }
}

@end
