//
//  TravelCell.m
//  i柚趣
//
//  Created by luyoudui on 15/10/15.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import "TravelCell.h"
#import "UIImageView+WebCache.h"
@implementation TravelCell

- (void)awakeFromNib {
    self.layer.cornerRadius = 10;
    self.layer.borderWidth = 2;
    self.layer.borderColor = [UIColor purpleColor].CGColor;
}

- (void)setModel:(TravelModel *)model{
    _model = model;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.image_url]];
    _chName.text = model.name_zh_cn;
    _enName.text = model.name_en;
}
@end
