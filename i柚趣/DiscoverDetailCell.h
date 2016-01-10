//
//  DiscoverDetailCell.h
//  i柚趣
//
//  Created by luyoudui on 15/10/13.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscoverDetailModel.h"
@interface DiscoverDetailCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *PicImageView;

@property (nonatomic,strong) DiscoverDetailModel *model;
@end
