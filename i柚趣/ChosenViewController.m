
//
//  ChosenViewController.m
//  i柚趣
//
//  Created by luyoudui on 15/10/6.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import "ChosenViewController.h"
#import "GMDCircleLoader.h"
#import "YDRequestManager.h"
#import "ChosenCell.h"
#import "ChosenModel.h"
#import "ChosenDetailViewController.h"
#import "MJRefresh.h"
#import "WKAlertView.h"
@interface ChosenViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,MJRefreshBaseViewDelegate>{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    //当前页
    NSInteger _currentPage;
    //搜索关键字
    NSString *_key;
    UISearchBar *_searchBar;
    //刷新
    MJRefreshFooterView *_footerView;
    MJRefreshHeaderView *_headerView;
    BOOL _isLonding;
    float H;
    
    UIWindow *_sheetWindow;
}

@end

@implementation ChosenViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //显示tabBar
    [(TabBarController *)self.tabBarController show];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpUI];
    [self prepareDataPage:_currentPage key:_key];
    //处理键盘的
    [self keyboardHide];
     [GMDCircleLoader setOnView:self.view withTitle:@"正在加载..." animated:YES];
    H = 120/375.0;
   
}
- (void)keyboardHide{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}
//点击其他任意让键盘隐藏
- (void)keyboardHide:(UITapGestureRecognizer *)sender{
    [_searchBar resignFirstResponder];
}
//获取数据
- (void)prepareDataPage:(NSInteger)page key:(NSString *)key{
    NSString *urlString = [NSString stringWithFormat:@"page=%ld&key=%@",page,key];
    [[YDRequestManager sharedManager]GETWithUrl:urlString httpUrl:kChosenUrl api:APIKEY finished:^(NSData *data) {
        NSDictionary *dict1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (_currentPage==1) {
            [_dataArray removeAllObjects];
        }
        NSDictionary *dict2 = dict1[@"showapi_res_body"];
        NSDictionary *dict3 = dict2[@"pagebean"];
        NSArray *array = dict3[@"contentlist"];

        array = [ChosenModel arrayOfModelsFromDictionaries:array error:nil];
        [_dataArray addObjectsFromArray:array];
        if (_dataArray) {
            [GMDCircleLoader hideFromView:self.view animated:YES];
        }
        
        [self.view addSubview:_tableView];
        _isLonding = NO;
        [_footerView endRefreshing];
        [_headerView endRefreshing];
        [_tableView reloadData];
    } failed:^(NSString *errorMessage) {
        if (errorMessage) {
            _sheetWindow = [WKAlertView showAlertViewWithStyle:WKAlertViewStyleFail title:@"抱歉" detail:@"你的网络歇菜了!"canleButtonTitle:nil okButtonTitle:@"OK!" callBlock:^(MyWindowClick buttonIndex) {
                _sheetWindow.hidden = YES;
                _sheetWindow = nil;
            }];
            [GMDCircleLoader hideFromView:self.view animated:YES];

        }
        NSLog(@"error:%@",errorMessage);
    }];
}
//创建视图
- (void)setUpUI{
    //创建tableView
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, __kScreenWidth, __kScreenHeight-60) style:UITableViewStylePlain];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _dataArray = [NSMutableArray array];
    
    //创建searchbar
    _searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 20, __kScreenWidth, 40)];
    [_searchBar setBackgroundColor:[UIColor whiteColor]];
    _searchBar.delegate=self;
    _searchBar.placeholder = @"搜索话题，如体育、娱乐";
    [self.view addSubview:_searchBar];
    _currentPage = 1;
    _key = @"热点";
    
    //创建刷新视图
    _headerView = [MJRefreshHeaderView header];
    _headerView.scrollView = _tableView;
    _headerView.delegate = self;
    _footerView = [MJRefreshFooterView footer];
    _footerView.scrollView = _tableView;
    _footerView.delegate = self;
    _isLonding = NO;
}
#pragma mark -- tableView的协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChosenCell *cell = [tableView dequeueReusableCellWithIdentifier:[ChosenCell ID]];
    if (cell == nil) {
        cell = [ChosenCell cell];
    }
    cell.model = _dataArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return H*__kScreenWidth;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChosenDetailViewController *detail = [[ChosenDetailViewController alloc] init];
    ChosenModel *model = _dataArray[indexPath.row];
    detail.url = model.url;
    detail.myTitle = model.userName;
    ChosenCell *cell = (ChosenCell *)[tableView cellForRowAtIndexPath:indexPath];
    detail.image = cell.contentImg.image;
    detail.text = model.title;
    detail.model = model;
    [self.navigationController pushViewController:detail animated:YES];
}
//向上向下滑动来控制tabBar的隐藏事件
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (velocity.y<0) {
        [(TabBarController *)self.tabBarController show];
    }else if (velocity.y>0){
        [(TabBarController *)self.tabBarController hide];
    }
}
#pragma mark -- search协议方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
  
    _currentPage = 1;
    _key = searchBar.text;
    [self prepareDataPage:_currentPage key:_key];
     _searchBar.showsCancelButton = NO;
    [_searchBar resignFirstResponder];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
   

    _searchBar.text = nil;
    _searchBar.showsCancelButton = NO;
    [_searchBar resignFirstResponder];
}
//让searchBar的cancel变成取消
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    _searchBar.showsCancelButton = YES;
    for(UIView *view in  [[[searchBar subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            UIButton * cancel =(UIButton *)view;
            [cancel setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
}

#pragma mark - mj
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    if (_isLonding) {
        return;
    }
    _isLonding = YES;
    if (refreshView == _headerView) {
        _currentPage = 1;
    }else if (refreshView == _footerView){
        _currentPage++;
    }
    [self prepareDataPage:_currentPage key:_key];
}
- (void)dealloc{
    [_footerView free];
    [_headerView free];
}
@end
