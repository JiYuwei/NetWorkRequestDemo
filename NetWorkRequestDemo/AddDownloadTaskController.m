//
//  AddDownloadTaskController.m
//  NetWorkRequestDemo
//
//  Created by 纪宇伟 on 2017/7/15.
//  Copyright © 2017年 jyw. All rights reserved.
//

#import "AddDownloadTaskController.h"

@interface AddDownloadTaskController () <UITextViewDelegate>

@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,strong)UIButton *actBtn;

@end

@implementation AddDownloadTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closeVC)];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10 + 64, self.view.bounds.size.width - 20, 120)];
    _textView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
    _textView.font = [UIFont systemFontOfSize:14];
    _textView.layer.cornerRadius = 5;
    _textView.delegate = self;
    
    [self.view addSubview:_textView];
    
    _actBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _actBtn.frame = CGRectMake(10, _textView.frame.size.height + _textView.frame.origin.y + 10, self.view.bounds.size.width - 20, 35);
    _actBtn.backgroundColor = [UIColor colorWithRed:0.2 green:0.49 blue:0.99 alpha:1];
    _actBtn.layer.cornerRadius = 5;
    [_actBtn setTintColor:[UIColor whiteColor]];
    [_actBtn setTitle:@"开始下载" forState:UIControlStateNormal];
    _actBtn.enabled = NO;
    [_actBtn addTarget:self action:@selector(startDownload) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_actBtn];
}

-(void)closeVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)startDownload
{
    NSString *urlString = _textView.text;
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (_startDownloadHandler) {
            _startDownloadHandler(urlString);
        }
    }];
}

#pragma mark - Delegate

-(void)textViewDidChange:(UITextView *)textView
{
    BOOL hasValue = textView.text.length > 0;
    _actBtn.enabled = hasValue;
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
