//
//  DownloadCell.h
//  NetWorkRequestDemo
//
//  Created by 纪宇伟 on 2017/7/15.
//  Copyright © 2017年 jyw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DownloadModel;

static CGFloat downloadCellHeight = 60;

@interface DownloadCell : UITableViewCell

@property(nonatomic,strong)DownloadModel *fileDataModel;

@end
