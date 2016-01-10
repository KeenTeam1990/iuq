//
//  DiscoverCell.h
//  i柚趣
//
//  Created by luyoudui on 15/10/13.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscoverModel.h"
@interface DiscoverCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (nonatomic,strong) DiscoverModel *model;

+ (NSString *)ID;
+ (id)cell;
@end
