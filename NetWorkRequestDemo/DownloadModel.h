//
//  DownloadModel.h
//  NetWorkRequestDemo
//
//  Created by 纪宇伟 on 2017/7/16.
//  Copyright © 2017年 jyw. All rights reserved.
//

#import "BaseModel.h"

@interface DownloadModel : BaseModel

@property(nonatomic,copy)NSString *fileURL;
@property(nonatomic,copy)NSString *fileName;
@property(nonatomic,copy)NSString *fileSize;
@property(nonatomic,copy)NSString *downloadPercent;
//@property(nonatomic,copy)NSString *downloadSpeed;

-(void)updateDataModelWithDict:(NSDictionary *)dict;

@end
