//
//  ADViewController.m
//  NetWorkRequestDemo
//
//  Created by 纪宇伟 on 2017/7/18.
//  Copyright © 2017年 jyw. All rights reserved.
//

#import "ADViewController.h"

static const NSInteger skipTimeInterval = 5;

@interface ADViewController ()

@property(nonatomic,strong)UIImageView *adImageView;
@property(nonatomic,strong)UIButton *skipBtn;

@end

@implementation ADViewController
{
    dispatch_source_t _timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _adImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _adImageView.backgroundColor = [UIColor greenColor];
    _adImageView.userInteractionEnabled = YES;
    
    [self.view addSubview:_adImageView];
    
    _skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _skipBtn.frame = CGRectMake(self.view.bounds.size.width - 120, 30, 100, 30);
    _skipBtn.layer.cornerRadius = _skipBtn.bounds.size.height/2;
    _skipBtn.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:0.6];
    [_skipBtn setTitle:[NSString stringWithFormat:@"%ld 跳过",skipTimeInterval] forState:UIControlStateNormal];
    [_skipBtn addTarget:self action:@selector(skipToHomePage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_skipBtn];
    
    [self startCountingTimeWithInterval:skipTimeInterval];
}

-(void)startCountingTimeWithInterval:(NSInteger)interval
{
    __block NSInteger timeOut = interval;
    __weak typeof(self) weakSelf = self;
    
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        if (timeOut <= 0) {
            [weakSelf skipToHomePage];
        }
        else{
//            NSInteger fireTime = timeOut % interval;
            NSString *timeStr = [NSString stringWithFormat:@"%ld 跳过",timeOut];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_skipBtn setTitle:timeStr forState:UIControlStateNormal];
            });
            
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}

-(void)skipToHomePage
{
    dispatch_source_cancel(_timer);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_completeShowADHandler) {
            _completeShowADHandler();
        }
    });
}

-(void)dealloc
{
    NSLog(@"ADVC dealloc");
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
