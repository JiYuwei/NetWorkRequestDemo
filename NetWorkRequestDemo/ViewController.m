//
//  ViewController.m
//  NetWorkRequestDemo
//
//  Created by 纪宇伟 on 2017/7/5.
//  Copyright © 2017年 jyw. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>
#import "ViewController.h"
#import "JYNetworkRequest.h"
#import "TableViewCell.h"
#import "DataModel.h"

#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController () <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;

@end


@implementation ViewController

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"AFNetworkingTest";
    
    NSString *url = @"https://app.bilibili.com/x/feed/index?access_key=f1f583b3c34d7eb53dfb2cd248c64ae6&actionKey=appkey&appkey=27eb53fc9058f8c3&build=5800&device=phone&idx=1494956798&mobi_app=iphone&network=wifi&open_event=&platform=ios&pull=1&sign=7280ea66a6494319d2f033b145dde8c3&style=2&ts=1499343223";

    [self createUI];
    
    [self retrieveJsonUseGETWithURL:url prepare:^{
        [SVProgressHUD showWithStatus:@"正在加载"];
    } finsih:^{
        if ([SVProgressHUD isVisible]) {
            [SVProgressHUD dismiss];
        }
    }];
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
        [self buildDataModelWithJson:json];
        
    } failure:^(NSError *error, BOOL needCache, NSDictionary *cachedJson) {
        NSLog(@"%@",error);
        if (needCache) {
            [self buildDataModelWithJson:cachedJson];
        }
    }];
}

-(void)buildDataModelWithJson:(NSDictionary *)json
{
    if ([json[@"code"] integerValue] == 0) {
        [self.dataArray removeAllObjects];
        NSArray *srcArray = json[@"data"];
        NSMutableArray <DataModel *> *modelArr = [NSMutableArray array];
        
        for (NSDictionary *dic in srcArray) {
            DataModel *model = [DataModel modelWithDictionary:dic];
            [modelArr addObject:model];
        }
        
        for (NSInteger i = 0; i < modelArr.count; i+=2) {
            NSArray <DataModel *> *array;
            if (i < modelArr.count - 1) {
                array = @[modelArr[i],modelArr[i+1]];
            }
            else{
                array = @[modelArr[i]];
            }
            
            [_dataArray addObject:array];
        }
        
        [_tableView reloadData];
    }
}

#pragma mark - Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TableViewCell class])];
    cell.dataArray = _dataArray[indexPath.row];
    
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
