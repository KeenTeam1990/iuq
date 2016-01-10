
//
//  ChosenDetailViewController.m
//  i柚趣
//
//  Created by luyoudui on 15/10/6.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import "ChosenDetailViewController.h"
#import "GMDCircleLoader.h"
#import "UMSocial.h"
#import "ChosenDBManager.h"
#import "WKAlertView.h"
@interface ChosenDetailViewController ()<UIWebViewDelegate,UMSocialUIDelegate>{
    UIWebView *_webView;
    //数据库
    BOOL _isFavorite;
    
    UIWindow *_sheetWindow;
}

@end

@implementation ChosenDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.tabBarController.tabBar.hidden = YES;
    [(TabBarController *)self.tabBarController hide];
    
    //让导航栏变成黑色并且状态栏不变色或白色
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, __kScreenWidth, 20)];
//    view.backgroundColor = [UIColor whiteColor];
//    [self.navigationController.view addSubview:view];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpView];
    //判断数据库的数据是否存在
    _isFavorite = [[ChosenDBManager sharedManager]isAppExists:_model.Id];
}
//创建视图
- (void)setUpView{
    //创建导航栏的title
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    label.text = _myTitle;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textColor = [UIColor blackColor];
    self.navigationItem.titleView = label;
    
    //创建webView
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, __kScreenWidth, __kScreenHeight-64)];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
    [_webView loadRequest:request];
    _webView.delegate = self;
    
    //创建更多按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 30);
    [btn setImage:[UIImage imageNamed:@"more.png"] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(more) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = item;

}
//更多按钮的处理事件
- (void)more{
    UIAlertController * alertContoller = [[UIAlertController alloc]init];
    UIAlertAction * cancelAciton = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    //收藏数据库
    UIAlertAction * favouriteAciton = [UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        _isFavorite = [[ChosenDBManager sharedManager]isAppExists:_model.Id];
        if (_isFavorite) {
            _sheetWindow = [WKAlertView showAlertViewWithStyle:WKAlertViewStyleFail title:@"失败" detail:@"已经收藏过了,请到收藏列表查看!" canleButtonTitle:nil okButtonTitle:@"OK" callBlock:^(MyWindowClick buttonIndex) {
                _sheetWindow.hidden = YES;
                _sheetWindow = nil;
            }];

//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已经收藏过了,请到收藏列表查看!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alert show];
        }else{
            [[ChosenDBManager sharedManager] insertFavoriteData:_model];
            _sheetWindow = [WKAlertView showAlertViewWithStyle:WKAlertViewStyleSuccess title:@"成功" detail:@"收藏成功!" canleButtonTitle:nil okButtonTitle:@"OK" callBlock:^(MyWindowClick buttonIndex) {
                _sheetWindow.hidden = YES;
                _sheetWindow = nil;
            }];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"收藏成功!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alert show];
        }
    }];
    //友盟分享
    UIAlertAction * shareAciton = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [UMSocialSnsService presentSnsIconSheetView:self appKey:@"56162a62e0f55a5c2e002a23"shareText:_text shareImage:_image shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToTwitter,nil]delegate:self];
    }];
    [alertContoller addAction:favouriteAciton];
    [alertContoller addAction:shareAciton];
    [alertContoller addAction:cancelAciton];
    [self presentViewController:alertContoller animated:YES completion:nil];
}
#pragma mark -- webView的代理
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [GMDCircleLoader setOnView:self.view withTitle:@"正在加载..." animated:YES];
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [GMDCircleLoader hideFromView:self.view animated:YES];
    [self.view addSubview:_webView];

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //    NSLog(@"[[[");
    UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"抱歉 !" message:@"网络请求失败 ！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [GMDCircleLoader hideFromView:self.view animated:YES];
    [view show];
}
@end
