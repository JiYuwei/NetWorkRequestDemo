//
//  DownloadCell.m
//  NetWorkRequestDemo
//
//  Created by 纪宇伟 on 2017/7/15.
//  Copyright © 2017年 jyw. All rights reserved.
//

#import "DownloadCell.h"

@interface DownloadCell ()

@property (weak, nonatomic) IBOutlet UIImageView *fileImgView;
@property (weak, nonatomic) IBOutlet UILabel *fileTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *fileSizeLabel;

@end

@implementation DownloadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
