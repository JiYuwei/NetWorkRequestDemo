//
//  TableViewCell.h
//  NetWorkRequestDemo
//
//  Created by 纪宇伟 on 2017/7/7.
//  Copyright © 2017年 jyw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DataModel;

static CGFloat cellHeight = 180;

@interface TableViewCell : UITableViewCell

@property(nonatomic,copy)NSArray <DataModel *> *dataArray;

@end
