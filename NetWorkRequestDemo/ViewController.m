//
//  ViewController.m
//  NetWorkRequestDemo
//
//  Created by 纪宇伟 on 2017/7/5.
//  Copyright © 2017年 jyw. All rights reserved.
//

#import "ViewController.h"
#import "JYNetworkRequest.h"
#import "TableViewCell.h"

#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController () <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableView;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"AFNetworkingTest";
    
    NSString *url = @"https://app.bilibili.com/x/feed/index?access_key=f1f583b3c34d7eb53dfb2cd248c64ae6&actionKey=appkey&appkey=27eb53fc9058f8c3&build=5800&device=phone&idx=1494956798&mobi_app=iphone&network=wifi&open_event=&platform=ios&pull=1&sign=7280ea66a6494319d2f033b145dde8c3&style=2&ts=1499343223";

    [self createUI];
    [self retrieveJsonUseGETWithURL:url];
}

-(void)createUI
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TableViewCell class])];
    
    [self.view addSubview:_tableView];
}


-(void)retrieveJsonUseGETWithURL:(NSString *)url
{
    return[self retrieveJsonUseGETWithURL:url prepare:nil finsih:nil];
}

-(void)retrieveJsonUseGETWithURL:(NSString *)url prepare:(prepareBlock)prepare finsih:(finishBlock)finish
{
    [JYNetworkRequest retrieveJsonWithPrepare:prepare finish:finish needCache:YES requestType:HTTPRequestTypeGET fromURL:url parameters:@{} success:^(NSDictionary *json) {
        NSLog(@"%@",json);
    } failure:^(NSError *error, BOOL needCache, NSDictionary *cachedJson) {
        NSLog(@"%@",error);
    }];
}


#pragma mark - Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TableViewCell class])];
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight / 320 * SCREENWIDTH;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
