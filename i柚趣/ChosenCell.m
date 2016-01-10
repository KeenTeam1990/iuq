//
//  ChosenCell.m
//  i柚趣
//
//  Created by luyoudui on 15/10/6.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import "ChosenCell.h"
#import "UIImageView+WebCache.h"
#import "ChosenModel.h"
@implementation ChosenCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (NSString *)ID{
    return @"chosenCell";
}

+ (id)cell{
    return [[NSBundle mainBundle] loadNibNamed:@"ChosenCell" owner:nil options:nil][0];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self layoutIfNeeded];
    _userLogoImage.layer.cornerRadius = 15;
    _userLogoImage.layer.masksToBounds = YES;
}

- (void)setModel:(ChosenModel *)model{
    _model = model;
    [_userLogoImage sd_setImageWithURL:[NSURL URLWithString:model.userLogo]];
    _userNameLabel.text = model.userName;
    
    [_contentImg sd_setImageWithURL:[NSURL URLWithString:model.contentImg]];
    _titleLabel.text = model.title;
    _typedNameLabel.text = model.typeName;
    
    //求时间
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *string = [NSString stringWithFormat:@"%@:00",model.date];
    NSDate *lastDate = [f dateFromString:string];
    NSTimeInterval lastTime = [lastDate timeIntervalSince1970];
    NSDate *nowDate = [NSDate date];
    
    NSTimeInterval nowTime = [nowDate timeIntervalSince1970];
    
    int time = nowTime - lastTime;
    if (time<60) {
        _timeLabel.text = [NSString stringWithFormat:@"%d秒前",time];
    }else if (time<3600){
       _timeLabel.text = [NSString stringWithFormat:@"%d分钟前",time/60];
    }else if (time<86400){
        _timeLabel.text = [NSString stringWithFormat:@"%d小时前",time/3600];
    }else{
        _timeLabel.text = [NSString stringWithFormat:@"%d天前",time/86400];
    }

}
@end
