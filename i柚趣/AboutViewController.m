//
//  AboutViewController.m
//  i柚趣
//
//  Created by luyoudui on 15/10/16.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    float proportion = 250/667.0;
    float H = proportion*__kScreenHeight;
    self.title = @"关于爱柚趣";
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 74, __kScreenWidth-20, H)];
    imageView.image = [UIImage imageNamed:@"bg.png"];
    [self.view addSubview:imageView];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, H+25, __kScreenWidth-40, 300)];
    label.text = @"  叶子新鲜时是一种丰润的绿，是那种我们在北方很少看到的绿。当它枯萎时，蒙上了灰尘，它仍没有失去它的美，因为那个时候整片景色已经染上了各种色调的金 色，绿色的金，黄色的金，粉色的金…这种金色色调与蓝色相结合，有水的宝蓝，勿忘我的靛蓝，特别是亮丽明艳的钴蓝。大多数的画家对色彩的研究不深…";
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label];
    
    UILabel *email = [[UILabel alloc] initWithFrame:CGRectMake(0, __kScreenHeight-50, __kScreenWidth, 30)];
    email.text = @"联系邮箱:3062484492@qq.com";
    email.font = [UIFont systemFontOfSize:13];
    email.textAlignment = NSTextAlignmentCenter;
    email.textColor = [UIColor grayColor];
    [self.view addSubview:email];
    
    [(TabBarController *)self.tabBarController hide];
}

@end
