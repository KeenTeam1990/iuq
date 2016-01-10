//
//  DestinaCell.h
//  i柚趣
//
//  Created by luyoudui on 15/10/15.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DestinaModel.h"
@interface DestinaCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *chName;
@property (weak, nonatomic) IBOutlet UILabel *enName;

@property (nonatomic,strong)DestinaModel *model;
+ (NSString *)ID;
+ (id)cell;
@end
