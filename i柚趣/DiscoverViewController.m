//
//  DiscoverViewController.m
//  i柚趣
//
//  Created by luyoudui on 15/10/6.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import "DiscoverViewController.h"
#import "YDRequestManager.h"
#import "ScrollModel.h"
#import "UIImageView+WebCache.h"
#import "ScrollDetailViewController.h"
#import "DiscoverModel.h"
#import "DiscoverCell.h"
#import "DiscoverDetailViewController.h"
#import "GMDCircleLoader.h"
@interface DiscoverViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    UIScrollView *_scrollView;
    //scrollView的数据源
    NSMutableArray *_scrollArray;
    UIPageControl *_pagecontrol;
    UITableView *_tableView;
    //tableView的数据源
    NSMutableArray *_dataArray;
    //定时器
    NSTimer *_timer;
    //定时器数字变化
    UILabel *_label;
    
    float H;
}

@end

@implementation DiscoverViewController

- (void)viewWillAppear:(BOOL)animated{
    [(TabBarController *)self.tabBarController show];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //设置比例来匹配同机型
    float proportion = 196/667.0;
    H = proportion*__kScreenHeight;
    _dataArray = [NSMutableArray array];
    self.title = @"发现";
    self.view.backgroundColor = [UIColor whiteColor];
    [GMDCircleLoader setOnView:self.view withTitle:@"正在加载..." animated:YES];
    [self prepareScrollData];
    [self prepareTableViewData];
}

//获取scrollView的数据源
- (void)prepareScrollData{
    _scrollArray = [NSMutableArray array];
    [[YDRequestManager sharedManager]GETWithUrl:nil httpUrl:kFashion api:nil finished:^(NSData *data) {
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dic2 = dic1[@"data"];
        NSArray *array = dic2[@"object_list"];
        array = [ScrollModel arrayOfModelsFromDictionaries:array error:nil];
        for (int i = 0; i < 7; i++) {
            [_scrollArray addObject:array[i]];
        }
        //创建scroView
        [self createScrollView];
    } failed:^(NSString *errorMessage) {
        if (errorMessage) {
            UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"抱歉 !" message:@"网络请求失败 ！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [GMDCircleLoader hideFromView:self.view animated:YES];
            [view show];

        }
        NSLog(@"%@",errorMessage);
    }];
}
//创建scroView
- (void)createScrollView{
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, __kScreenWidth,H)];
    //将最后一个Model加到第一个来实现无缝轮播
    ScrollModel *model1 = [_scrollArray lastObject];
    [_scrollArray insertObject:model1 atIndex:0];
    for (int i = 0; i < _scrollArray.count; i++) {
          ScrollModel *model = _scrollArray[i];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*__kScreenWidth, 0, __kScreenWidth, H)];
        //创建描述image的Label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, H-20, __kScreenWidth-70, 20)];
        label.font = [UIFont boldSystemFontOfSize:15];
        label.text = model.msg;
        [imageView addSubview:label];
        
        //创建label默认隐藏供后面用
        UILabel *favorite = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 20)];
        favorite.text = model.favorite_count;
        favorite.hidden = YES;
        [imageView addSubview:favorite];
        UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        time.text = model.add_datetime_pretty;
        [imageView addSubview:time];
        time.hidden = YES;
        //点击图片
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [imageView addGestureRecognizer:tap];
        imageView.userInteractionEnabled = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.photo.path]];
        [_scrollView addSubview:imageView];
    }
 
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.contentSize = CGSizeMake(_scrollArray.count*__kScreenWidth, 0);
    [self.view addSubview:_scrollView];
    
    //创建数字变化
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(__kScreenWidth-40, H+64-20, 40, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"/7";
    label.textColor = [UIColor orangeColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    [self.view addSubview:label];
    _label = [[UILabel alloc] initWithFrame:CGRectMake(__kScreenWidth-60, H+64-20-10, 60, 20)];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont boldSystemFontOfSize:22];
    _label.textColor = [UIColor orangeColor];
    _label.text = @"1";
    [self.view addSubview:_label];
}
//点击图片事件处理
- (void)tapClick:(UITapGestureRecognizer *)sender{
    UIImageView *imageView = (UIImageView *)sender.view;
    //去imageVIew上元素给后面用
    UILabel *label = imageView.subviews[0];
    UILabel *favorite = imageView.subviews[1];
    UILabel *time = imageView.subviews[2];
    ScrollDetailViewController *detail = [[ScrollDetailViewController alloc] init];
    detail.image = imageView.image;
    detail.detailTitle = label.text;
    detail.like = favorite.text;
    detail.time = time.text;
    [self.navigationController pushViewController:detail animated:YES];
}
//创建视图
- (void)setUpUI{
    //创建pageControl
    _pagecontrol = [[UIPageControl alloc] init];
    _pagecontrol.center = CGPointMake(__kScreenWidth/2, H+64+10);
    _pagecontrol.numberOfPages = 7;
    _pagecontrol.currentPage = 0;
    _pagecontrol.currentPageIndicatorTintColor = [UIColor redColor];
    _pagecontrol.pageIndicatorTintColor = [UIColor purpleColor];
    [self.view addSubview:_pagecontrol];
    //创建精品推荐label
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, H+64+10+10, __kScreenWidth, 20)];
    titleLabel.text = @"精品推荐";
    titleLabel.textColor = [UIColor greenColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:titleLabel];
    
    //创建tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, H+64+10+10+20, __kScreenWidth, __kScreenHeight-(H+64+10+10+20)) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //创建定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerclick) userInfo:nil repeats:YES];
}
//定时器事件
- (void)timerclick{
    NSInteger index = _pagecontrol.currentPage;
    index++;
    if (index == _scrollArray.count) {
        index = 0;
    }
    [_scrollView setContentOffset:CGPointMake(__kScreenWidth*index, 0) animated:YES];
}

//获取tableview的数据
- (void)prepareTableViewData{
    [[YDRequestManager sharedManager]GETWithUrl:nil httpUrl:kDiscoverList api:nil finished:^(NSData *data) {
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dic2 = dic1[@"data"];
        NSArray *array = dic2[@"categories"];
        array = [DiscoverModel arrayOfModelsFromDictionaries:array error:nil];
        [_dataArray addObjectsFromArray:array];
        
        NSArray *indexArray = @[@1,@5,@11,@13,@14,@17,@22];
        NSMutableArray *removerArray = [NSMutableArray array];
        for (int i = 0 ; i < indexArray.count; i++) {
            [removerArray addObject:_dataArray[[indexArray[i]integerValue]]];
        }//删除不要的数据
        [_dataArray removeObjectsInArray:removerArray];
        
        [GMDCircleLoader hideFromView:self.view animated:YES];
        [self setUpUI];
        [self.view addSubview:_tableView];
        
        [_tableView reloadData];
       
    } failed:^(NSString *errorMessage) {
        NSLog(@"%@",errorMessage);
    }];
}
#pragma mark -- UIScrollView代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger index = _scrollView.contentOffset.x/__kScreenWidth;
    _pagecontrol.currentPage = index;
    _label.text = [NSString stringWithFormat:@"%ld",index+1];
    if (index == _scrollArray.count-1) {
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
}

#pragma mark --TableView代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DiscoverCell *cell = [tableView dequeueReusableCellWithIdentifier:[DiscoverCell ID]];
    if (cell == nil) {
        cell = [DiscoverCell cell];
    }
   
    cell.model = _dataArray[indexPath.row];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70/375.0*__kScreenWidth;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DiscoverModel *model = _dataArray[indexPath.row];
    DiscoverDetailViewController *detail = [[DiscoverDetailViewController alloc] init];
    detail.key = model.Id;
    detail.name = model.name;
    [self.navigationController pushViewController:detail animated:YES];
}
//tableView的滑动来控制tabBar的隐藏
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (scrollView == _tableView) {
        if (velocity.y<0) {
            [(TabBarController *)self.tabBarController show];
        }else if (velocity.y>0){
            [(TabBarController *)self.tabBarController hide];
        }
    }
   
}
@end
