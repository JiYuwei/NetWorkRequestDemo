//
//  DownloadViewController.m
//  NetWorkRequestDemo
//
//  Created by 纪宇伟 on 2017/7/15.
//  Copyright © 2017年 jyw. All rights reserved.
//

#import "DownloadViewController.h"
#import "AddDownloadTaskController.h"
#import "JYNetworkRequest.h"
#import "DownloadCell.h"

@interface DownloadViewController () <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;

@end


@implementation DownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"下载";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addDownloadTask)];
    
    _dataArray = [NSMutableArray array];
    [self createTableView];
}

-(void)addDownloadTask
{
    AddDownloadTaskController *addVC = [[AddDownloadTaskController alloc] init];
    [addVC setStartDownloadHandler:^(NSString *url){
        [self downloadFileWithURL:url];
    }];
    UINavigationController *addNavi = [[UINavigationController alloc] initWithRootViewController:addVC];
    [self presentViewController:addNavi animated:YES completion:nil];
}

-(void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DownloadCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([DownloadCell class])];
    
    [self.view addSubview:_tableView];
}

-(void)downloadFileWithURL:(NSString *)url
{
    
    [JYNetworkRequest downloadFileWithURL:url progress:^(NSProgress *progress) {
        NSString *percent = progress.localizedDescription;
        NSLog(@"%@",percent);
    } success:^(NSURLResponse *response, NSURL *filePath) {
        NSLog(@"%@",filePath);
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}






#pragma mark - Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DownloadCell class])];
    
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
