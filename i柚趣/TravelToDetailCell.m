//
//  TravelToDetailCell.m
//  i柚趣
//
//  Created by luyoudui on 15/10/15.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import "TravelToDetailCell.h"
#import "UIImageView+WebCache.h"
@implementation TravelToDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configModel:(TravelToDetailModel *)model index:(NSInteger)index{
    _titleLabel.text = [NSString stringWithFormat:@"第%ld站:%@",index,model.entry_name];

    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.image_url]];

    _descLabel.text = model.tips;
    UIFont *font=[UIFont systemFontOfSize:15];
//    NSDictionary *dict=@{NSFontAttributeName:font};
//    //计算显示desc字符串内容需要的大小
//    CGSize descSize=[model.tips boundingRectWithSize:CGSizeMake(__kScreenWidth, 9999) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
//    
//    
//    _descLabel.frame = CGRectMake(10, 245, 355, descSize.height);
    
    
    _descLabel.font = font;
    
    _descLabel.lineBreakMode=NSLineBreakByWordWrapping;
}
- (CGFloat)string:(NSString *)string{
    UIFont *font=[UIFont systemFontOfSize:15];
    NSDictionary *dict=@{NSFontAttributeName:font};
    //计算显示desc字符串内容需要的大小
    CGSize descSize=[string boundingRectWithSize:CGSizeMake(__kScreenWidth, 9999) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
    
    _descLabel.text = string;
   
    
    
    _descLabel.font = font;
    
    _descLabel.lineBreakMode=NSLineBreakByWordWrapping;
    return (200/355.0)*(__kScreenWidth-20)+5+descSize.height;
}
+ (NSString *)ID{
    return @"TravelToDetailCell";
}

+ (id)cell{
    return [[NSBundle mainBundle] loadNibNamed:@"TravelToDetailCell" owner:nil options:nil][0];
}
@end
