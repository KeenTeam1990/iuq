//
//  TravelDetailViewController.m
//  i柚趣
//
//  Created by luyoudui on 15/10/15.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import "TravelDetailViewController.h"
#import "YDRequestManager.h"
#import "TravelDetailModel.h"
#import "TravelDetailCell.h"
#import "TravelToDetailController.h"
#import "MJRefresh.h"
#import "GMDCircleLoader.h"
#import "UMSocial.h"
#import "TravelDBManager.h"
#import "WKAlertView.h"
@interface TravelDetailViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate,UMSocialUIDelegate>{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSInteger _curPage;
    BOOL _isLoading;
    //刷新的头、尾视图
    MJRefreshHeaderView *_headerView;
    MJRefreshFooterView *_footerView;
    
    BOOL _isFavorite;
    
    UIWindow *_sheetWindow;
}

@end

@implementation TravelDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"%@行程",_myTitle];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
     [GMDCircleLoader setOnView:self.view withTitle:@"正在加载..." animated:YES];
    [self createData];
}
//创建视图
- (void)createUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, __kScreenWidth, __kScreenHeight-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _dataArray = [NSMutableArray array];
    _curPage = 1;
    _headerView=[MJRefreshHeaderView header];
    _headerView.scrollView=_tableView;
    _headerView.delegate=self;
    _footerView=[MJRefreshFooterView footer];
    _footerView.scrollView=_tableView;
    _footerView.delegate=self;
    _isLoading=NO;
    //数据库有无
    _isFavorite = [[TravelDBManager sharedManager] isAppExists:_model.myId];
    
    UIButton *favoriteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [favoriteBtn setImage:[UIImage imageNamed:@"more.png"] forState:UIControlStateNormal];
    favoriteBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:favoriteBtn];
    self.navigationItem.rightBarButtonItem = item;
    [favoriteBtn addTarget:self action:@selector(favorite:) forControlEvents:UIControlEventTouchUpInside];
    
  
}

//收藏
- (void)favorite:(UIButton *)sender{
    UIAlertController *alertControll = [[UIAlertController alloc] init];
    UIAlertAction *favorite = [UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        _isFavorite = [[TravelDBManager sharedManager] isAppExists:_model.myId];
        if (_isFavorite) {
            _sheetWindow = [WKAlertView showAlertViewWithStyle:WKAlertViewStyleFail title:@"失败" detail:@"已经收藏过了,请到收藏列表查看!" canleButtonTitle:nil okButtonTitle:@"OK" callBlock:^(MyWindowClick buttonIndex) {
                _sheetWindow.hidden = YES;
                _sheetWindow = nil;
            }];


//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已经收藏过了,请到收藏列表查看!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alert show];
        }else{
            [[TravelDBManager sharedManager] insertFavoriteData:_model];
            _sheetWindow = [WKAlertView showAlertViewWithStyle:WKAlertViewStyleSuccess title:@"成功" detail:@"收藏成功!" canleButtonTitle:nil okButtonTitle:@"OK" callBlock:^(MyWindowClick buttonIndex) {
                _sheetWindow.hidden = YES;
                _sheetWindow = nil;
            }];
//            [[TravelDBManager sharedManager] insertFavoriteData:_model];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"收藏成功!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alert show];
        }

    }];
    UIAlertAction *share = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [UMSocialSnsService presentSnsIconSheetView:self appKey:@"56162a62e0f55a5c2e002a23"shareText:_myTitle shareImage:_image shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToTwitter,nil]delegate:self];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertControll addAction:favorite];
    [alertControll addAction:share];
    [alertControll addAction:cancel];
    [self presentViewController:alertControll animated:YES completion:nil];

}
//获取数据源
- (void)createData{
    NSString *url = [NSString stringWithFormat:kTravelDetail,_key,_curPage];
    [[YDRequestManager sharedManager]GETWithUrl:nil httpUrl:url api:nil finished:^(NSData *data) {
        NSArray *array = [TravelDetailModel arrayOfModelsFromData:data error:nil];
        if (_curPage == 1) {
            [_dataArray removeAllObjects];
        }
        [_dataArray addObjectsFromArray:array];
        [GMDCircleLoader hideFromView:self.view animated:YES];
        [self.view addSubview:_tableView];
        _isLoading=NO;
        //加载数据成功后停止刷新
        [_headerView endRefreshing];
        [_footerView endRefreshing];
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
    TravelDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:[TravelDetailCell ID]];
    if (cell == nil) {
        cell = [TravelDetailCell cell];
    }
    cell.model = _dataArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TravelDetailModel *model = _dataArray[indexPath.row];
    TravelDetailCell *cell = [[TravelDetailCell alloc] init];
    CGFloat H = [cell string:model.desc];
    return H;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TravelDetailModel *model = _dataArray[indexPath.row];
    TravelToDetailController *detail = [[TravelToDetailController alloc] init];
    detail.key = model.myId;
    detail.myTilte = model.name;
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
#pragma mark --mj刷新代理
//开始进入刷新时调用的协议方法
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if(_isLoading){
        return;
    }
    _isLoading=YES;
    //    如果是头部刷新（下拉刷新，重新加载第1页数据）
    if(refreshView==_headerView){
        _curPage = 1;
    }else if (refreshView==_footerView){
        _curPage++;
    }
    [self createData];
}
//释放刷新视图
- (void)dealloc
{
    [_headerView free];
    [_footerView free];
}

@end
