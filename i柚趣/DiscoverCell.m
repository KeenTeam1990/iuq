//
//  DiscoverCell.m
//  i柚趣
//
//  Created by luyoudui on 15/10/13.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import "DiscoverCell.h"
#import "UIImageView+WebCache.h"
@implementation DiscoverCell

- (void)awakeFromNib {
    _titleImageView.layer.cornerRadius = 10;
    _titleImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (NSString *)ID{
    return @"DiscoverCell";
}

+ (id)cell{
    return [[NSBundle mainBundle] loadNibNamed:@"DiscoverCell" owner:nil options:nil][0];
}

- (void)setModel:(DiscoverModel *)model{
    _model = model;
    
    [_titleImageView sd_setImageWithURL:[NSURL URLWithString:model.pic]];
    _descLabel.text = model.desc;
    _nameLable.text = model.name;
}
@end
