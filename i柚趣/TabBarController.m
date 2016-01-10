//
//  TabBarController.m
//  i柚趣
//
//  Created by luyoudui on 15/10/6.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import "TabBarController.h"
#import "BaseViewController.h"
#import "TabBarButton.h"
@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTabBar];
    [self setUpControllers];
    
}

//创建tabbar
- (void)setUpTabBar{
    self.tabBar.hidden = YES;
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, __kScreenHeight-49, __kScreenWidth, 49)];

    backgroundImageView.backgroundColor = [UIColor whiteColor];
    backgroundImageView.userInteractionEnabled = YES;
    backgroundImageView.tag = 400;
    [self.view addSubview:backgroundImageView];
    NSArray *titles = @[@"精选",@"发现",@"旅行",@"我"];
    NSArray *images = @[@"chosen.png",@"discover.png",@"travel.png",@"user.png"];
    NSArray *selectedImages = @[@"chosenSelected.png",@"discoverSelected.png",@"travelSelected.png",@"userSelected.png"];
    for (int i = 0; i < titles.count; i++) {
        TabBarButton *tabBarbutton = [[TabBarButton alloc] initWithFrame:CGRectMake(i *__kScreenWidth/4, 0, __kScreenWidth/4, 49)];
        [tabBarbutton setTitle:titles[i] forState:UIControlStateNormal];
        [tabBarbutton addTarget:self action:@selector(buttonSelected:) forControlEvents:UIControlEventTouchUpInside];
        [tabBarbutton setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [tabBarbutton setImage:[UIImage imageNamed:selectedImages[i]] forState:UIControlStateSelected];
        tabBarbutton.tag = 200 + i;
        [backgroundImageView addSubview:tabBarbutton];
        if (i == 0) {
            tabBarbutton.selected = YES;
        }
    }
    //定义文字下的小条子
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 47, __kScreenWidth/4, 2)];
    label.backgroundColor = [UIColor colorWithRed:212/255.0 green:35/255.0 blue:121/255.0 alpha:1];
    label.tag = 300;
    [backgroundImageView addSubview:label];
}
- (void)buttonSelected:(UIButton *)sender{
    NSInteger index = sender.tag - 200;
    self.selectedIndex = index;
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:400];
    for (UIView *view in imageView.subviews) {
        if ([view isKindOfClass:[TabBarButton class]]) {
            TabBarButton *button = (TabBarButton *)view;
            if (button.tag == sender.tag) {
                button.selected = YES;
            }else{
                button.selected = NO;
            }
        }
    }
    UILabel *label = (UILabel *)[self.view viewWithTag:300];
    if (index == 0){
        label.backgroundColor = [UIColor colorWithRed:212/255.0 green:35/255.0 blue:121/255.0 alpha:1];
    }
    if (index == 1) {
        label.backgroundColor = [UIColor colorWithRed:225/255.0 green:101/255.0 blue:49/255.0 alpha:1];
    }
    if (index == 2){
        label.backgroundColor = [UIColor colorWithRed:16/255.0 green:85/255.0 blue:236/255.0 alpha:1];
    }
    if (index == 3){
        label.backgroundColor = [UIColor colorWithRed:17/255.0 green:32/255.0 blue:121/255.0 alpha:1];
    }
    [UIView animateWithDuration:0.3 animations:^{
        label.frame = CGRectMake(index * __kScreenWidth / 4, 47, __kScreenWidth/4, 2);
    } completion:^(BOOL finished) {
        
    }];
}

//创建视图
- (void)setUpControllers{
    NSArray *classArray = @[@"ChosenViewController",@"DiscoverViewController",@"TravelViewController",@"UserViewController"];
    NSMutableArray *viewControllers = [NSMutableArray array];
    for (int i = 0; i < classArray.count ; i++) {
        Class class = NSClassFromString(classArray[i]);
        BaseViewController *base = [[class alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:base];
        [viewControllers addObject:nav];
    }
    self.viewControllers = viewControllers;
}
//显示tabBar
- (void)show{
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:400];
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame = imageView.frame;
        frame.origin.y = __kScreenHeight - 49;
        imageView.frame = frame;
    }];
}
//隐藏tabBar
- (void)hide{
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:400];
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame = imageView.frame;
        frame.origin.y = __kScreenHeight;
        imageView.frame = frame;
    }];

}

@end
