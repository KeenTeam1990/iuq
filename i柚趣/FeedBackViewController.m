//
//  FeedBackViewController.m
//  i柚趣
//
//  Created by luyoudui on 15/10/16.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import "FeedBackViewController.h"

@interface FeedBackViewController ()

@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"反馈";
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, __kScreenHeight/2-50, __kScreenWidth-40, 50)];
    label.text = @"如果有发现Bug了,柚子不有趣了,请联系作者.Email:3062484492@qq.com";
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [self.view addSubview:label];
    [(TabBarController *)self.tabBarController hide];
}

@end
