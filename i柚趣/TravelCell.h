//
//  TravelCell.h
//  i柚趣
//
//  Created by luyoudui on 15/10/15.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TravelModel.h"
@interface TravelCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *chName;
@property (weak, nonatomic) IBOutlet UILabel *enName;

@property (nonatomic,strong) TravelModel *model;
@end
