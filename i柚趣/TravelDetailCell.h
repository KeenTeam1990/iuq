//
//  TravelDetailCell.h
//  i柚趣
//
//  Created by luyoudui on 15/10/15.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TravelDetailModel.h"
@interface TravelDetailCell : UITableViewCell
- (CGFloat)string:(NSString *)string ;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic,strong)TravelDetailModel *model;
+ (NSString *)ID;
+ (id)cell;
@end
