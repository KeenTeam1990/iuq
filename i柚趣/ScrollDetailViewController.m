//
//  ScrollDetailViewController.m
//  i柚趣
//
//  Created by luyoudui on 15/10/13.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import "ScrollDetailViewController.h"
#import "UMSocial.h"
#import "AutoToFitSize.h"
@interface ScrollDetailViewController ()<UMSocialUIDelegate>{
    UIScrollView *_scrollView;
}

@end

@implementation ScrollDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [(TabBarController *)self.tabBarController hide];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavTitle];
    [self createUI];
    [self myImageView];
    [self createMoreBtn];
}
//创建导航栏title
- (void)createNavTitle{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    label.text = @"精品";
    label.textColor = [UIColor orangeColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:22];
    self.navigationItem.titleView = label;
}
//创建整体scrollView
- (void)createUI{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    _scrollView.showsVerticalScrollIndicator = NO;
    CGSize size = _image.size;
    float H = size.height/1.50;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, __kScreenWidth, H)];
    imageView.userInteractionEnabled = YES;
    imageView.tag = 100;
    imageView.image = _image;
    [_scrollView addSubview:imageView];
    
    //创建描述label
    UILabel *titleLabel = [[UILabel alloc] init];
    CGSize descSize = [AutoToFitSize string:_detailTitle];
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, H+5, __kScreenWidth-5, descSize.height)];
    titleLabel.numberOfLines = 0;
    titleLabel.text = _detailTitle;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
    [_scrollView addSubview:titleLabel];
    
    //创建喜欢button
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(5, H+5+descSize.height, 25, 25);
    [btn setImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:btn];
    //喜欢人数
    UILabel *likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, H+5+3+descSize.height, 40, 20)];
    likeLabel.tag = 200;
    likeLabel.text = _like;
    likeLabel.textColor = [UIColor grayColor];
    likeLabel.font =[UIFont systemFontOfSize:12];
    [_scrollView addSubview:likeLabel];
    
    //时间
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, H+descSize.height+5+3, 200, 20)];
    timeLabel.text = _time;
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.textColor = [UIColor grayColor];
    [_scrollView addSubview:timeLabel];
    _scrollView.contentSize = CGSizeMake(__kScreenWidth, H+descSize.height+30);
}
//点击喜欢按钮事件
- (void)btnClick:(UIButton *)sender{
    
    [sender setImage:[UIImage imageNamed:@"liked.png"] forState:UIControlStateNormal];
    UILabel *label = (UILabel *)[_scrollView viewWithTag:200];
    label.text = [NSString stringWithFormat:@"%ld",[_like integerValue]+1];
}

//点击图片
- (void)myImageView{
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:100];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scaleImage)];
    [imageView addGestureRecognizer:tap];
}
//点击图片事件
- (void)scaleImage{
    if (self.navigationController.navigationBarHidden) {
        //如果导航栏隐藏，就让他出现
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }else {
        //如果导航栏没有隐藏
        [self prefersStatusBarHidden];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

-(BOOL)prefersStatusBarHidden{
    if (self.navigationController.navigationBarHidden) {
        //如果导航栏隐藏，就让状态栏隐藏
        return YES;
    }else{
        return NO;
    }
}
- (void)createMoreBtn{
    //创建更多按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 30);
    [btn setImage:[UIImage imageNamed:@"more.png"] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(more) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = item;
}
//点击更多事件
- (void)more{
    UIAlertController * alertContoller = [[UIAlertController alloc]init];
    UIAlertAction * cancelAciton = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * favouriteAciton = [UIAlertAction actionWithTitle:@"保存到相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImageWriteToSavedPhotosAlbum(_image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }];
    UIAlertAction * shareAciton = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:@"56162a62e0f55a5c2e002a23"
                                          shareText:@"爱混搭，爱生活,爱柚趣到AppStore下载"
                                         shareImage:_image
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToTwitter,nil]
                                           delegate:self];
    }];
    //会根据添加顺序来显示
    [alertContoller addAction:favouriteAciton];
    [alertContoller addAction:shareAciton];
    [alertContoller addAction:cancelAciton];
    [self presentViewController:alertContoller animated:YES completion:nil];
}
//点击保存到相册的事件
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error == nil) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已存入手机相册" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [alert show];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
}





@end
