//
//  TravelToDetailCell.h
//  i柚趣
//
//  Created by luyoudui on 15/10/15.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TravelToDetailModel.h"
@interface TravelToDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

- (CGFloat)string:(NSString *)string ;
- (void)configModel:(TravelToDetailModel *)model index:(NSInteger)index;
+ (NSString *)ID;
+ (id)cell;
@end
