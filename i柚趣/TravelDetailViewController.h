//
//  TravelDetailViewController.h
//  i柚趣
//
//  Created by luyoudui on 15/10/15.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DestinaModel.h"
@interface TravelDetailViewController : UIViewController
@property (nonatomic,copy) NSString *key;
@property (nonatomic,copy) NSString *myTitle;
@property (nonatomic,weak) UIImage *image;
@property (nonatomic,strong) DestinaModel *model;
@end
