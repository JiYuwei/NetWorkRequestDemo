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
#import "SectionHeaderView.h"
#import "WeakProxy.h"
#import "DownloadCell.h"
#import "DownloadModel.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

static CGFloat sectionHeaderHeight = 40;

@interface DownloadViewController () <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,copy)NSArray *headerItems;
@property(nonatomic,strong)NSMutableArray <UITableView *> *tableViews;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)SectionHeaderView *sectionHeader;
@property(nonatomic,strong)NSTimer *reloadTimer;
@property(nonatomic,strong)WeakProxy *proxy;

@end


@implementation DownloadViewController

-(instancetype)init
{
    if (self = [super init]) {
        _proxy = [WeakProxy proxyWithTarget:self];
        
        _reloadTimer = [NSTimer timerWithTimeInterval:1.0 target:_proxy selector:@selector(refreshDownloadData) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_reloadTimer forMode:NSRunLoopCommonModes];
    }
    return self;
}

-(void)refreshDownloadData
{
    if (_dataArray.count > 0) {
        [_tableViews[0] reloadData];
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"下载";
    self.view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addDownloadTask)];
    
    [self createSectionHeader];
    [self prepareData];
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

-(void)createSectionHeader
{
    _headerItems = @[@"下载中",@"已下载"];
    _sectionHeader = [[SectionHeaderView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, sectionHeaderHeight) items:_headerItems];
    
    [self.view addSubview:_sectionHeader];
}

-(void)prepareData
{
    _dataArray = [NSMutableArray array];
    
    for (NSInteger i = 0; i < _headerItems.count; i++) {
        NSMutableArray <DownloadModel *> *array = [NSMutableArray array];
        [_dataArray addObject:array];
    }
}

-(void)createTableView
{
    _tableViews = [NSMutableArray array];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64 + sectionHeaderHeight, SCREENWIDTH, SCREENHEIGHT - 40 - 64 - 49)];
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width * _headerItems.count, _scrollView.bounds.size.height);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    __weak UIScrollView *weakScrollView = _scrollView;
    [_sectionHeader setMoveCompleteHandler:^(NSInteger index){
        weakScrollView.contentOffset = CGPointMake(_scrollView.bounds.size.width * index, 0);
    }];
    
    for (NSInteger i = 0; i < _headerItems.count; i++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(_scrollView.bounds.size.width * i, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height) style:UITableViewStyleGrouped];
        tableView.dataSource = self;
        tableView.delegate = self;
        
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DownloadCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([DownloadCell class])];
        
        tableView.separatorInset = UIEdgeInsetsZero;
        
        [_scrollView addSubview:tableView];
        
        [_tableViews addObject:tableView];
    }
}

-(void)downloadFileWithURL:(NSString *)url
{
    DownloadModel *model = [DownloadModel model];
    [_dataArray[0] addObject:model];
    NSUInteger taskIndex = [_dataArray[0] indexOfObject:model];
    
    [JYNetworkRequest downloadFileWithURL:url progress:^(NSProgress *progress) {
        
        NSString *fileName = [url componentsSeparatedByString:@"/"].lastObject;
        NSString *fileSize = [self sizeString:progress.totalUnitCount];
        NSString *percent = [progress.localizedDescription componentsSeparatedByString:@" "].lastObject;
        
        NSDictionary *dic = @{@"fileURL":url,
                              @"fileName":fileName,
                              @"fileSize":fileSize,
                              @"downloadPercent":percent
                              };
        
        [_dataArray[0][taskIndex] updateDataModelWithDict:dic];
    
        NSLog(@"%@",percent);
        
    } success:^(NSURLResponse *response, NSURL *filePath) {
        NSLog(@"%@",filePath);
        [_dataArray[0] removeObject:model];
        [_tableViews[0] reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


-(NSString *)sizeString:(int64_t)size
{
    if (size > 1024 * 1024 * 1024) {
        return [NSString stringWithFormat:@"%.1f GB",(float)size/(1024*1024*1024)];
    }
    else if (size > 1024 * 1024){
        return [NSString stringWithFormat:@"%.1f MB",(float)size/(1024*1024)];
    }
    else if (size > 1024){
        return [NSString stringWithFormat:@"%.1f KB",(float)size/(1024)];
    }
    else{
        return [NSString stringWithFormat:@"%.0f B",(float)size];
    }
}




#pragma mark - Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger selectIndex = scrollView.contentOffset.x / scrollView.bounds.size.width;
    [_sectionHeader moveToSelectIndex:selectIndex];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger index = [_tableViews indexOfObject:tableView];
    
    return [_dataArray[index] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [_tableViews indexOfObject:tableView];
    
    DownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DownloadCell class])];
    
    cell.fileDataModel = _dataArray[index][indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return downloadCellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(void)dealloc
{
    [_reloadTimer invalidate];
    _reloadTimer = nil;
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
