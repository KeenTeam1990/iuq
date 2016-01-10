//
//  ChosenCell.h
//  i柚趣
//
//  Created by luyoudui on 15/10/6.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChosenModel;
@interface ChosenCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userLogoImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contentImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typedNameLabel;

@property (nonatomic,strong) ChosenModel *model;
+ (NSString *)ID;
+ (id)cell;
@end
