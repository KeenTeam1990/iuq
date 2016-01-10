//
//  TravelToDetailController.m
//  i柚趣
//
//  Created by luyoudui on 15/10/15.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import "TravelToDetailController.h"
#import "TravelToDetailModel.h"
#import "TravelToDetailCell.h"
#import "YDRequestManager.h"
#import "GMDCircleLoader.h"
@interface TravelToDetailController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSMutableArray *_allArray;
}

@end

@implementation TravelToDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = _myTilte;
    [self createUI];
    [GMDCircleLoader setOnView:self.view withTitle:@"正在加载..." animated:YES];
    [self createData];

}
//创建视图
- (void)createUI{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, __kScreenWidth, __kScreenHeight-29) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    

    _allArray = [NSMutableArray array];
}
//获取数据源
- (void)createData{
    NSString *url = [NSString stringWithFormat:kTravelToDetil,_key];
    NSLog(@"%@",url);
    [[YDRequestManager sharedManager]GETWithUrl:nil httpUrl:url api:nil finished:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = dict[@"plan_days"];

        for (NSDictionary *dic in array) {
            _dataArray = [NSMutableArray array];
            NSArray *array1 = dic[@"plan_nodes"];
            array1 = [TravelToDetailModel arrayOfModelsFromDictionaries:array1 error:nil];
            if (array1) {
                [_dataArray addObjectsFromArray:array1];
                [_allArray addObject:_dataArray];
            }
            
        }
        NSLog(@"%ld",_allArray.count);
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
#pragma mark --tableView代理
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 25)];
    label.backgroundColor = [UIColor purpleColor];
    label.text = [NSString stringWithFormat:@"DAY%ld",section+1];
    label.textColor = [UIColor whiteColor];

    label.font = [UIFont boldSystemFontOfSize:17];
    return label;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return _allArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_allArray[section] count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TravelToDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:[TravelToDetailCell ID]];
    if (cell == nil) {
        cell = [TravelToDetailCell cell];
    }
    TravelToDetailModel *model = _allArray[indexPath.section][indexPath.row];
    [cell configModel:model index:indexPath.row+1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     TravelToDetailModel *model = _allArray[indexPath.section][indexPath.row];
    TravelToDetailCell *cell = [[TravelToDetailCell alloc] init];
    CGFloat H = [cell string:model.tips];
    return H;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}
//滑动控制
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (velocity.y>0) {
        [(TabBarController *)self.tabBarController hide];
    }else if (velocity.y<0){
        [(TabBarController *)self.tabBarController show];
    }
}
@end
