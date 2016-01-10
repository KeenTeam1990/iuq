//
//  TravelViewController.m
//  i柚趣
//
//  Created by luyoudui on 15/10/15.
//  Copyright (c) 2015年 YDIT. All rights reserved.
//

#import "TravelViewController.h"
#import "YDRequestManager.h"
#import "TravelModel.h"
#import "TravelCell.h"
#import "DestinationViewController.h"
#import "GMDCircleLoader.h"
@interface TravelViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>{
    UICollectionView *_collectionView;
    NSArray *_ouArray;
    NSArray *_meiArray;
    NSArray *_yaArray;
    NSArray *_daArray;
    NSArray *_taiArray;
    //总数据源
    NSMutableArray *_dataArray;
}

@end

@implementation TravelViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [(TabBarController *)self.tabBarController show];
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"旅行日记";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [GMDCircleLoader setOnView:self.view withTitle:@"正在加载..." animated:YES];
    [self setUpUI];
    [self prepareData];
}
- (IBAction)destination:(UISegmentedControl *)sender {
    //每一次都先清理总数据，然后再加紧新数据
    if (sender.selectedSegmentIndex==0) {
        [_dataArray removeAllObjects];
        [_dataArray addObjectsFromArray:_daArray];
        [_collectionView reloadData];
    }else if (sender.selectedSegmentIndex==1){
        [_dataArray removeAllObjects];
        [_dataArray addObjectsFromArray:_taiArray];
        [_collectionView reloadData];
    }else if (sender.selectedSegmentIndex==2){
        [_dataArray removeAllObjects];
        [_dataArray addObjectsFromArray:_yaArray];
        [_collectionView reloadData];
    }else if (sender.selectedSegmentIndex==3){
        [_dataArray removeAllObjects];
        [_dataArray addObjectsFromArray:_ouArray];
        [_collectionView reloadData];
    }else if (sender.selectedSegmentIndex==4){
        [_dataArray removeAllObjects];
        [_dataArray addObjectsFromArray:_meiArray];
        [_collectionView reloadData];
    }
}
//创建视图
- (void)setUpUI{
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    flow.minimumInteritemSpacing = 5;
    flow.minimumLineSpacing = 10;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, __kScreenWidth, __kScreenHeight-100) collectionViewLayout:flow];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"TravelCell" bundle:nil] forCellWithReuseIdentifier:@"TravelCell"];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    _ouArray = [NSArray array];
    _meiArray = [NSArray array];
    _daArray  = [NSArray array];
    _yaArray = [NSArray array];
    _taiArray = [NSArray array];
    _dataArray = [NSMutableArray array];
}

- (void)prepareData{
    [[YDRequestManager sharedManager]GETWithUrl:nil httpUrl:kTravelUrl api:nil finished:^(NSData *data) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *yaZhouDic = array[0];
        NSArray *array1 = yaZhouDic[@"destinations"];
        _yaArray = [TravelModel arrayOfModelsFromDictionaries:array1 error:nil];
       
        NSDictionary *ouZhouDic = array[1];
        NSArray *array2 = ouZhouDic[@"destinations"];
        _ouArray = [TravelModel arrayOfModelsFromDictionaries:array2 error:nil];
        
        NSDictionary *meiZhouDic = array[2];
        NSArray *array3 = meiZhouDic[@"destinations"];
        _meiArray = [TravelModel arrayOfModelsFromDictionaries:array3 error:nil];
        
        NSDictionary *taiDic = array[3];
        NSArray *array4 = taiDic[@"destinations"];
        _taiArray = [TravelModel arrayOfModelsFromDictionaries:array4 error:nil];
        
        NSDictionary *daluDic = array[4];
         NSArray *array5 = daluDic[@"destinations"];
        _daArray = [TravelModel arrayOfModelsFromDictionaries:array5 error:nil];
        [GMDCircleLoader hideFromView:self.view animated:YES];
        [_dataArray addObjectsFromArray:_daArray];
        
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
#pragma mark -- collectionView代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TravelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TravelCell" forIndexPath:indexPath];
    cell.model = _dataArray[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((__kScreenWidth-20)/2.0, 217/177.0*(__kScreenWidth-20)/2.0);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DestinationViewController *des = [[DestinationViewController alloc] init];
    TravelModel *model = _dataArray[indexPath.row];
    des.key = model.myId;
    des.myTitle = model.name_zh_cn;
    [self.navigationController pushViewController:des animated:YES];
  
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (velocity.y>0) {
        [(TabBarController *)self.tabBarController hide];
    }else if (velocity.y<0){
        [(TabBarController *)self.tabBarController show];
    }
}

@end
