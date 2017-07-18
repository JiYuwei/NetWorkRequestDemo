//
//  SectionHeaderView.m
//  NetWorkRequestDemo
//
//  Created by 纪宇伟 on 2017/7/17.
//  Copyright © 2017年 jyw. All rights reserved.
//

#import "SectionHeaderView.h"

@interface SectionHeaderView ()

@property(nonatomic,strong)NSMutableArray <UIButton *> *itemArray;

@end


@implementation SectionHeaderView

-(instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 0.5, frame.size.width, 0.5)];
        view.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:view];
        
        [self createItems:items];
    }
    
    return self;
}

-(void)createItems:(NSArray *)items
{
    if (items.count > 0) {
        
        _itemArray = [NSMutableArray array];
        
        CGFloat itemWidth = self.bounds.size.width/items.count;
        
        for (NSInteger i = 0; i < items.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(itemWidth * i, 0, itemWidth, self.bounds.size.height);
            [btn setTitle:items[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithRed:0.2 green:0.49 blue:0.99 alpha:1] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(selectChanged:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            
            [_itemArray addObject:btn];
        }
        
        _itemArray[0].selected = YES;
        
    }
}

-(void)selectChanged:(UIButton *)sender
{
    NSInteger index = [_itemArray indexOfObject:sender];
    [self moveToSelectIndex:index];
    if (_moveCompleteHandler) {
        _moveCompleteHandler(index);
    }
}


-(void)moveToSelectIndex:(NSInteger)selectIndex
{
    for (UIButton *btn in _itemArray) {
        btn.selected = NO;
    }
    
    _itemArray[selectIndex].selected = YES;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
