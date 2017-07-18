//
//  DownloadCell.m
//  NetWorkRequestDemo
//
//  Created by 纪宇伟 on 2017/7/15.
//  Copyright © 2017年 jyw. All rights reserved.
//

#import "DownloadCell.h"
#import "DownloadModel.h"

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

-(void)setFileDataModel:(DownloadModel *)fileDataModel
{
    if (_fileDataModel != fileDataModel) {
        _fileDataModel = fileDataModel;
    }
    
    _fileTitleLabel.text = _fileDataModel.fileName;
    _fileSizeLabel.text = [NSString stringWithFormat:@"%@  %@",_fileDataModel.fileSize,_fileDataModel.downloadPercent];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
