//
//  DiscoverDetailViewController.m
//  i柚趣
//
//  Created by luyoudui on 15/10/13.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import "DiscoverDetailViewController.h"
#import "DiscoverDetailModel.h"
#import "MyLayout.h"
#import "DiscoverDetailCell.h"
#import "YDRequestManager.h"
#import "NSString+URL.h"
#import "ScrollDetailViewController.h"
#import "GMDCircleLoader.h"
#import "MJRefresh.h"
@interface DiscoverDetailViewController ()<MyLayoutDelegate,UICollectionViewDataSource,UICollectionViewDelegate,MJRefreshBaseViewDelegate>{
    NSMutableArray *_dataArray;
    UICollectionView *_collectionView;
    NSInteger _currentPage;
    BOOL _isLoading;
    //刷新的头、尾视图
    MJRefreshHeaderView *_headerView;
    MJRefreshFooterView *_footerView;
}

@end

@implementation DiscoverDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [GMDCircleLoader setOnView:self.view withTitle:@"正在加载..." animated:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavTitle];
    [self createCollectionView];
    [self createData];

}

//获取视图的数据
- (void)createData{
    NSString *path = [@"1.8%20rv%3A1808" URLEncodedString];
    NSString *url = [NSString stringWithFormat:@"http://www.duitang.com/napi/blog/list/by_category/?app_version=%@&cate_key=%@&limit=24&start=%ld",path,_key,_currentPage];
    [[YDRequestManager sharedManager]GETWithUrl:nil httpUrl:url api:nil finished:^(NSData *data) {
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (_currentPage == 0) {
            [_dataArray removeAllObjects];
        }
        NSDictionary *dic2 = dic1[@"data"];
        NSArray *array = dic2[@"object_list"];
        array = [DiscoverDetailModel arrayOfModelsFromDictionaries:array error:nil];
        [_dataArray addObjectsFromArray:array];
        [GMDCircleLoader hideFromView:self.view animated:YES];
         [self.view addSubview:_collectionView];
        _isLoading=NO;
        //加载数据成功后停止刷新
        [_headerView endRefreshing];
        [_footerView endRefreshing];
        [_collectionView reloadData];
    } failed:^(NSString *errorMessage) {
        if (errorMessage) {
            UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"抱歉 !" message:@"网络请求失败 ！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [GMDCircleLoader hideFromView:self.view animated:YES];
            [view show];

        }
        NSLog(@"%@",errorMessage);
    }];
}
//创建视图
- (void)createCollectionView{
    //自制layout
    MyLayout *layout = [[MyLayout alloc] initWithSectionInsets:UIEdgeInsetsMake(5, 5, 5, 5) itemSpace:10 lineSpace:10];
    layout.delegate = self;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, __kScreenWidth, __kScreenHeight-64) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    [_collectionView registerNib:[UINib nibWithNibName:@"DiscoverDetailCell" bundle:nil] forCellWithReuseIdentifier:@"DiscoverDetailCell"];
   
    _dataArray = [NSMutableArray array];
    _currentPage = 0;
    _headerView=[MJRefreshHeaderView header];
    _headerView.scrollView=_collectionView;
    _headerView.delegate=self;
    _footerView=[MJRefreshFooterView footer];
    _footerView.scrollView=_collectionView;
    _footerView.delegate=self;
    _isLoading=NO;

}
//创建导航栏title
- (void)createNavTitle{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    label.text = _name;
    label.textColor = [UIColor orangeColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:18];
    self.navigationItem.titleView = label;
   
}

#pragma mark -- UICOllectionView代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DiscoverDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DiscoverDetailCell" forIndexPath:indexPath];
    cell.model = _dataArray[indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ScrollDetailViewController *detail = [[ScrollDetailViewController alloc] init];
    DiscoverDetailModel *model = _dataArray[indexPath.row];
    detail.time = model.add_datetime_pretty;
    detail.like = model.favorite_count;
    detail.detailTitle = model.msg;
    DiscoverDetailCell *cell = (DiscoverDetailCell *)[collectionView cellForItemAtIndexPath:indexPath];
  
    detail.image = cell.PicImageView.image;
    [self.navigationController pushViewController:detail animated:YES];
   
}
#pragma mark -- Mylayout代理
- (NSInteger)numberOfColumns{
    return 3;
}
- (CGFloat)heightAtIndexPath:(NSIndexPath *)indexPath{
   return  95+arc4random()%60;
}
//开始进入刷新时调用的协议方法
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if(_isLoading){
        return;
    }
    _isLoading=YES;
    //    如果是头部刷新（下拉刷新，重新加载第1页数据）
    if(refreshView==_headerView){
        _currentPage=0;
    }else if (refreshView==_footerView){
        _currentPage++;
    }
    [self createData];
}
//通过滑动来控制tabBar的隐藏
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (velocity.y>0) {
        [(TabBarController *)self.tabBarController hide];
    }else if (velocity.y<0){
        [(TabBarController *)self.tabBarController show];
    }
}

//释放刷新视图不然会蹦
- (void)dealloc
{
    [_headerView free];
    [_footerView free];
}

@end
