//
//  ChosenDetailViewController.h
//  i柚趣
//
//  Created by luyoudui on 15/10/6.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChosenModel.h"
@interface ChosenDetailViewController : UIViewController
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *myTitle;
@property (nonatomic,weak) UIImage *image;
@property (nonatomic,copy) NSString *text;

@property (nonatomic,strong) ChosenModel *model;
@end
