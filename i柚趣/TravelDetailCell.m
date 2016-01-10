//
//  TravelDetailCell.m
//  i柚趣
//
//  Created by luyoudui on 15/10/15.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import "TravelDetailCell.h"
#import "UIImageView+WebCache.h"
@implementation TravelDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (CGFloat)string:(NSString *)string{
    UIFont *font=[UIFont systemFontOfSize:15];
    NSDictionary *dict=@{NSFontAttributeName:font};
    //计算显示desc字符串内容需要的大小
    CGSize descSize=[string boundingRectWithSize:CGSizeMake(__kScreenWidth, 9999) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
    
    _descLabel.text = string;
//    _descLabel.frame = CGRectMake(15, 210, 345, descSize.height);
    
    
    _descLabel.font = font;
    
    _descLabel.lineBreakMode=NSLineBreakByWordWrapping;
    return 200/355.0*(__kScreenWidth-20)+8+descSize.height+10;
}

- (void)setModel:(TravelDetailModel *)model{
    
    
    _descLabel.font = [UIFont systemFontOfSize:15];
    
    _descLabel.lineBreakMode=NSLineBreakByWordWrapping;
    _descLabel.text = model.desc;
   
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.image_url]];
    _nameLabel.text = model.name;
    _timeLabel.text = [NSString stringWithFormat:@"%@旅行地|%@天",model.plan_nodes_count,model.plan_days_count];
}
+ (NSString *)ID{
    return @"TravelDetailCell";
}

+ (id)cell{
    return [[NSBundle mainBundle] loadNibNamed:@"TravelDetailCell" owner:nil options:nil][0];
}
@end
