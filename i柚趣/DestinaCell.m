//
//  DestinaCell.m
//  i柚趣
//
//  Created by luyoudui on 15/10/15.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import "DestinaCell.h"
#import "UIImageView+WebCache.h"
@implementation DestinaCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (NSString *)ID{
    return @"DestinaCell";
}

+ (id)cell{
    return [[NSBundle mainBundle] loadNibNamed:@"DestinaCell" owner:nil options:nil][0];
}
- (void)setModel:(DestinaModel *)model{
    _model = model;
    _chName.text = model.name_zh_cn;
    _enName.text = model.name_en;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.image_url]];
    _desLabel.text = [NSString stringWithFormat:@"出发去%@",model.name_zh_cn];
}
@end
