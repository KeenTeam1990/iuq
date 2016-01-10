//
//  DestinationViewController.m
//  i柚趣
//
//  Created by luyoudui on 15/10/15.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import "DestinationViewController.h"
#import "YDRequestManager.h"
#import "DestinaModel.h"
#import "DestinaCell.h"
#import "TravelDetailViewController.h"
#import "GMDCircleLoader.h"
@interface DestinationViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
}

@end

@implementation DestinationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = _myTitle;
    [self createUI];
    [GMDCircleLoader setOnView:self.view withTitle:@"正在加载..." animated:YES];
    [self prepareData];
}
//创建视图
- (void)createUI{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, __kScreenWidth, __kScreenHeight-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _dataArray = [NSMutableArray array];
}
//获取数据源
- (void)prepareData{
    NSString *url = [NSString stringWithFormat:kDestinationUrl,_key];
    [[YDRequestManager sharedManager]GETWithUrl:nil httpUrl:url api:nil finished:^(NSData *data) {
        NSArray *array = [DestinaModel arrayOfModelsFromData:data error:nil];
        [_dataArray addObjectsFromArray:array];
        [self.view addSubview:_tableView];
        [GMDCircleLoader hideFromView:self.view animated:YES];
        [_tableView reloadData];
    } failed:^(NSString *errorMessage) {
        if (errorMessage) {
            UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"抱歉 !" message:@"网络请求失败 ！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [GMDCircleLoader hideFromView:self.view animated:YES];
            [view show];

        }
        NSLog(@"%@",errorMessage);
    }];
}
#pragma mark -- TableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DestinaCell *cell = [tableView dequeueReusableCellWithIdentifier:[DestinaCell ID]];
    if (cell == nil) {
        cell = [DestinaCell cell];
    }
    cell.model = _dataArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 250/375.0*__kScreenWidth;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TravelDetailViewController *detail = [[TravelDetailViewController alloc] init];
    detail.key = [_dataArray[indexPath.row] myId];
    detail.myTitle =  [_dataArray[indexPath.row] name_zh_cn];
    DestinaCell *cell = (DestinaCell *)[tableView cellForRowAtIndexPath:indexPath];
    detail.image = cell.iconImageView.image;
    detail.model = _dataArray[indexPath.row];

    [self.navigationController pushViewController:detail animated:YES];
}
//通过滑动来控制tabBar的隐藏
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (velocity.y>0) {
        [(TabBarController *)self.tabBarController hide];
    }else if (velocity.y<0){
        [(TabBarController *)self.tabBarController show];
    }
}
@end
