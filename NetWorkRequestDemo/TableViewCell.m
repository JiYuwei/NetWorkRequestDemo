//
//  TableViewCell.m
//  NetWorkRequestDemo
//
//  Created by 纪宇伟 on 2017/7/7.
//  Copyright © 2017年 jyw. All rights reserved.
//

#import "TableViewCell.h"
#import <UIImageView+WebCache.h>
#import "DataModel.h"

@interface TableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewA;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewB;
@property (weak, nonatomic) IBOutlet UILabel *titleLabelA;
@property (weak, nonatomic) IBOutlet UILabel *titleLabelB;
@property (weak, nonatomic) IBOutlet UILabel *typeLabelA;
@property (weak, nonatomic) IBOutlet UILabel *typeLabelB;

@end


@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setDataArray:(NSArray<DataModel *> *)dataArray
{
    if (_dataArray != dataArray) {
        _dataArray = dataArray;
    }
    
    [_imgViewA sd_setImageWithURL:[NSURL URLWithString:_dataArray[0].face]];
    _titleLabelA.text = _dataArray[0].title;
    _typeLabelA.text = _dataArray[0].tname;
    
    BOOL doubleData = _dataArray.count > 1;
    _imgViewB.hidden = !doubleData;
    _titleLabelB.hidden = !doubleData;
    _typeLabelB.hidden = !doubleData;
    
    if (doubleData) {
        [_imgViewB sd_setImageWithURL:[NSURL URLWithString:_dataArray[1].face]];
        _titleLabelB.text = _dataArray[1].title;
        _typeLabelB.text = _dataArray[1].tname;
    }
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
