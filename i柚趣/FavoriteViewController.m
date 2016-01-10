//
//  FavoriteViewController.m
//  i柚趣
//
//  Created by luyoudui on 15/10/17.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import "FavoriteViewController.h"
#import "ChosenDBManager.h"
#import "ChosenCell.h"
#import "ChosenModel.h"

#import "TravelDBManager.h"
#import "DestinaCell.h"
#import "DestinaModel.h"

#import "TravelDetailViewController.h"
#import "ChosenDetailViewController.h"
@interface FavoriteViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    UISegmentedControl *_seg;
    
    NSArray *_chosenArray;
    NSArray *_travelArray;
    
    NSMutableArray *_dataArray;
}

@end

@implementation FavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [(TabBarController *)self.tabBarController hide];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createUI];
    [self getDataFromDB1];
    [NSThread detachNewThreadSelector:@selector(getDataFromDB) toTarget:self withObject:nil];
}

-(void)getDataFromDB1
{
    //取出数据库中所有的模型数据
    _travelArray=[[TravelDBManager sharedManager]fetchAllData];
}

-(void)getDataFromDB
{
    //取出数据库中所有的模型数据
    _chosenArray=[[ChosenDBManager sharedManager]fetchAllData];
    [_dataArray addObjectsFromArray:_chosenArray];
    if(_dataArray.count>0){
        //通知主线程刷新显示界面
        [self performSelectorOnMainThread:@selector(refreshChosen) withObject:nil waitUntilDone:NO];
    }
}
- (void)refreshChosen{
    [_tableView reloadData];
}


- (void)createUI{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, __kScreenWidth, __kScreenHeight-64) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    NSArray *title = @[@"精  选",@"旅  行"];
    _seg = [[UISegmentedControl alloc] initWithItems:title];
    [_seg addTarget:self action:@selector(updateSeg:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _seg;
    _seg.selectedSegmentIndex = 0;
    _dataArray = [NSMutableArray array];
   
   
}
- (void)updateSeg:(UISegmentedControl *)sender{
    [_dataArray removeAllObjects];
    if (sender.selectedSegmentIndex == 0) {
        [_dataArray addObjectsFromArray:_chosenArray];
    }else if (sender.selectedSegmentIndex == 1){
        [_dataArray addObjectsFromArray:_travelArray];
    }
    [_tableView reloadData];
}
#pragma mark -- TableView的代理

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //一定要先删除数据库再删数组
        if (_seg.selectedSegmentIndex == 0) {
            ChosenModel *model = _dataArray[indexPath.row];
            [[ChosenDBManager sharedManager] deleteDataById:model.Id];
            
        }else if (_seg.selectedSegmentIndex == 1){
            DestinaModel *model = _dataArray[indexPath.row];
            [[TravelDBManager sharedManager] deleteDataById:model.myId];
        }
        
        [_dataArray removeObjectAtIndex:indexPath.row];
        [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataArray.count;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_seg.selectedSegmentIndex == 0) {
        ChosenCell *cell = [tableView dequeueReusableCellWithIdentifier:[ChosenCell ID]];
        if (cell == nil) {
            cell = [ChosenCell cell];
        }
        
        cell.model = _chosenArray[indexPath.row];

        return cell;
    }else if (_seg.selectedSegmentIndex == 1){
        DestinaCell *cell = [tableView dequeueReusableCellWithIdentifier:[DestinaCell ID]];
        if (cell == nil) {
            cell = [DestinaCell cell];
        }
        cell.model = _travelArray[indexPath.row];
        return cell;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_seg.selectedSegmentIndex == 0) {
        return 120;
    }else if(_seg.selectedSegmentIndex == 1){
        return 300;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_seg.selectedSegmentIndex == 0) {
        ChosenDetailViewController *detail = [[ChosenDetailViewController alloc] init];
        ChosenModel *model = _dataArray[indexPath.row];
        detail.url = model.url;
        detail.model = model;
         [self.navigationController pushViewController:detail animated:YES];
    }else if (_seg.selectedSegmentIndex == 1){
        TravelDetailViewController *detail = [[TravelDetailViewController alloc] init];
        detail.key = [_dataArray[indexPath.row] myId];
        detail.myTitle = [_dataArray[indexPath.row] name_zh_cn];
        detail.model = _dataArray[indexPath.row];
         [self.navigationController pushViewController:detail animated:YES];
    }
   
}
@end
