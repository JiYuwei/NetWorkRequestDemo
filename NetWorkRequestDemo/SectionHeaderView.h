//
//  SectionHeaderView.h
//  NetWorkRequestDemo
//
//  Created by 纪宇伟 on 2017/7/17.
//  Copyright © 2017年 jyw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionHeaderView : UIScrollView

@property(nonatomic,copy) void (^moveCompleteHandler)(NSInteger);

-(instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items;

-(void)moveToSelectIndex:(NSInteger)selectIndex;

@end
