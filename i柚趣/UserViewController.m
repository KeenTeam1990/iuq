//
//  UserViewController.m
//  i柚趣
//
//  Created by luyoudui on 15/10/16.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import "UserViewController.h"
#import "UserCell.h"
#import "AboutViewController.h"
#import "FeedBackViewController.h"
#import "UMSocial.h"
#import "SDImageCache.h"
#import "FavoriteViewController.h"
#import "WKAlertView.h"
@interface UserViewController ()<UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate,UIAlertViewDelegate>{
    UITableView *_tableView;
    NSArray *_nameArray1;
    NSArray *_nameArray2;
    NSArray *_imageArray1;
    NSArray *_imageArray2;
    
    NSArray *_allImageArray;
    NSArray *_allNameArray;
    
    UIWindow *_sheetWindow;

}

@end

@implementation UserViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [(TabBarController *)self.tabBarController show];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor grayColor];
    self.title = @"我";
   
    [self createView];
    [self createData];
}

- (void)createView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, __kScreenWidth, __kScreenHeight-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"UserCell" bundle:nil] forCellReuseIdentifier:@"UserCell"];
    //不然tableView滑动
    _tableView.scrollEnabled = NO;

}
//准备数据
- (void)createData{
    _nameArray1 = @[@"我的收藏",@"清除缓存",@"推荐给好友"];
    _imageArray1 = @[@"shoucang.png",@"huancun.png",@"tuijian.png"];
    
    _nameArray2 = @[@"关于爱柚趣",@"作者",@"反馈"];
    _imageArray2 = @[@"guanyu.png",@"author.png",@"fankui.png"];
    _allImageArray = @[_imageArray1,_imageArray2];
    _allNameArray = @[_nameArray1,_nameArray2];
}
#pragma mark -- tableView 代理
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 5;
    }else if(section == 1){
        return 10;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
     return _allNameArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_allNameArray[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell" forIndexPath:indexPath];

    cell.iconImageView.image = [UIImage imageNamed:_allImageArray[indexPath.section][indexPath.row]];
    cell.descLabel.text = _allNameArray[indexPath.section][indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            cell.author.hidden = NO;
        }
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            AboutViewController *about = [[AboutViewController alloc] init];
            [self.navigationController pushViewController:about animated:YES];
        }else if (indexPath.row == 2){
            FeedBackViewController *feedBack = [[FeedBackViewController alloc] init];
            [self.navigationController pushViewController:feedBack animated:YES];
        }
    }else if (indexPath.section == 0){
        if (indexPath.row == 2) {
            [UMSocialSnsService presentSnsIconSheetView:self appKey:@"56162a62e0f55a5c2e002a23"shareText:@"爱柚趣是一款讲述生活的领悟的APP，很不错，推荐大家到APPStore下载爱柚趣"shareImage:[UIImage imageNamed:@"icon.png"]shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToTwitter,nil]delegate:self];
        }else if (indexPath.row == 1){
            [self clearCache];
        }else if (indexPath.row == 0){
            FavoriteViewController *favorite = [[FavoriteViewController alloc] init];
            [self.navigationController pushViewController:favorite animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44/375.0*__kScreenWidth;
}

-(void)clearCache{
    //===============清除缓存==============
   
     NSString *path  = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //获取缓存大小
    float size = [self folderSizeAtPath:path];
    NSString *string = [NSString stringWithFormat:@"%f",size];
    if ([string isEqualToString:@"0.000000"]) {
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"没有缓存" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }else{
        NSString *string = [NSString stringWithFormat:@"缓存大小为%.2fKB.确定要清理缓存吗?",size];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:string delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
}
- (float)folderSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize;
    if ([fileManager fileExistsAtPath:path]) {
               //SDWebImage框架自身计算缓存的实现
        folderSize+=[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
        
        return folderSize;
    }
    return 0;
}
//清除缓存点击确定时调用
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        return;
    }else if (buttonIndex == 1){
         NSString *path  = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSFileManager *fileManager=[NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:path]) {
            NSArray *childerFiles=[fileManager subpathsAtPath:path];
            for (NSString *fileName in childerFiles) {
                //如有需要，加入条件，过滤掉不想删除的文件
                NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
                [fileManager removeItemAtPath:absolutePath error:nil];
            }
        }
        [[SDImageCache sharedImageCache] cleanDisk];
        _sheetWindow = [WKAlertView showAlertViewWithStyle:WKAlertViewStyleSuccess title:@"成功" detail:@"您已经成功清除缓存!" canleButtonTitle:nil okButtonTitle:@"OK" callBlock:^(MyWindowClick buttonIndex) {
            _sheetWindow.hidden = YES;
            _sheetWindow = nil;
        }];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"清理成功!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
    }
}

@end
