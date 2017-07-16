//
//  AddDownloadTaskController.h
//  NetWorkRequestDemo
//
//  Created by 纪宇伟 on 2017/7/15.
//  Copyright © 2017年 jyw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddDownloadTaskController : UIViewController

@property(nonatomic,copy) void (^startDownloadHandler)(NSString *url);

@end
