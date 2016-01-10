//
//  DiscoverDetailCell.m
//  i柚趣
//
//  Created by luyoudui on 15/10/13.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import "DiscoverDetailCell.h"
#import "UIImageView+WebCache.h"
@implementation DiscoverDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(DiscoverDetailModel *)model{
    [_PicImageView sd_setImageWithURL:[NSURL URLWithString:model.photo.path]];
}
@end
