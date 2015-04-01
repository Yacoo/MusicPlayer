//
//  SFRecViewController.m
//  SFMusicPlayer
//
//  Created by yake on 15-3-26.
//  Copyright (c) 2015年 yake. All rights reserved.
//

#import "SFRecViewController.h"
#import <UIImageView+WebCache.h>
#import <AFNetworking.h>
#import "SFRequest.h"
#import <MJExtension.h>
#import "SFRandPicModel.h"
#import "SFHeaderView.h"
#import "SFSongOrderModel.h"
#import "SFSongOrderCell.h"
#import "SFRecItemCell.h"
#import "SFDiscModel.h"
#import "SFSongOrderDetailViewController.h"

@interface SFRecViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
{
    //轮播图相关
    NSInteger _currentPage;

}
@end

@implementation SFRecViewController

#pragma mark -- 配置轮播图
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
    [self initData];

    
    //请求数据
    [self sendRequest];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [_timer invalidate];
}
/**
 *设置子视图
 */
- (void)setupSubviews
{
    //背景scrollview
    UIScrollView * bgScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MAIN_W, MAIN_H-49)];
    bgScrollview.contentSize = CGSizeMake(MAIN_W, MAIN_H*2);
    bgScrollview.backgroundColor = YKColor(235, 240, 245);
    [self.view addSubview:bgScrollview];
    
    
    //轮播图
    self.randomScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MAIN_W, 180)];
    self.randomScrollview.contentSize = CGSizeMake(MAIN_W*6, 180);
    self.randomScrollview.backgroundColor = [UIColor grayColor];
    self.randomScrollview.pagingEnabled = YES;
    self.randomScrollview.alwaysBounceHorizontal = YES;
    self.randomScrollview.alwaysBounceVertical = NO;
    
    [bgScrollview addSubview:_randomScrollview];
    
    //collectionview
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(139, 200);
    if(IPHONE6){
        layout.itemSize = CGSizeMake(165, 220);
    }
    layout.sectionInset = UIEdgeInsetsMake(MARGIN, MARGIN, MARGIN, MARGIN);
    [layout setHeaderReferenceSize:CGSizeMake(MAIN_W-MARGIN*2, 50)];
    self.recCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(MARGIN, 180, MAIN_W-MARGIN*2, 100+layout.itemSize.height*4+MARGIN*7) collectionViewLayout:layout];
    
    //设置数据源和代理
    self.recCollection.dataSource = self;
    self.recCollection.delegate = self;
    self.recCollection.scrollEnabled = NO;
    
    //注册cell和headerview
    [self.recCollection registerNib:[UINib nibWithNibName:@"SFRecItemCell" bundle:nil] forCellWithReuseIdentifier:@"recCell"];
    [self.recCollection registerNib:[UINib nibWithNibName:@"SFSongOrderCell" bundle:nil] forCellWithReuseIdentifier:@"songOrder"];
    [self.recCollection registerNib:[UINib nibWithNibName:@"SFHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    
    self.recCollection.showsVerticalScrollIndicator = NO;
    self.recCollection.backgroundColor = [UIColor whiteColor];
    
    [bgScrollview addSubview:self.recCollection];
   
    bgScrollview.contentSize = CGSizeMake(MAIN_W, _recCollection.frame.origin.y+_recCollection.frame.size.height+108);
    
    //添加pageControl
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0 , 0, 80, 20)];
    _pageControl.center = CGPointMake(_randomScrollview.frame.size.width-40, _randomScrollview.frame.size.height-10);
    _pageControl.numberOfPages = 5;
    _pageControl.currentPage = 0;
    [bgScrollview addSubview:_pageControl];
    
}
#pragma mark -- 请求数据
- (void)sendRequest
{
    //请求轮播图数据
    NSString * urlString = [NSString stringWithFormat:@"%@?method=%@&format=json&from=ios&version=5.2.1&from=ios&channel=appstore",URL_SERVER_ADDRESS_1,@"baidu.ting.plaza.getFocusPic"];
    
    SFRequest * request = [[SFRequest alloc] init];
    [request request:urlString params:nil success:^(id json) {
        NSDictionary * dic = (NSDictionary *)json;
        YKLog(@"%@",dic);
        NSArray * picArray = [json objectForKey:@"pic"];
        [self setImageWithArray:picArray];
    } failure:^(NSError *error) {
        YKLog(@"error = %@",error);
    }];
    
  
    //热门歌单数据
    NSString * collectionString = [NSString stringWithFormat:@"%@?method=%@&num=4&version=5.2.1&from=ios&channel=appstore",URL_SERVER_ADDRESS_1,@"baidu.ting.diy.getHotGeDanAndOfficial"];
    SFRequest * hotRequest = [[SFRequest alloc] init];
    [hotRequest request:collectionString params:nil success:^(id json) {
        NSDictionary * contentDic = [json objectForKey:@"content"];
        NSArray * listArray = [contentDic objectForKey:@"list"];
        [self dealWithSongOrderArray:listArray];
        [self.recCollection reloadData];
        
    } failure:^(NSError *error) {
        YKLog(@"error = %@",error);
    }];
    
    //请求新碟
    /*
method=baidu.ting.plaza.getRecommendAlbum&format=json&offset=0&limit=4&type=2&from=ios&version=5.2.1&from=ios&channel=appstore     */
    
    NSString * discString = [NSString stringWithFormat:@"%@?method=%@&format=json&offset=0&limit=4&type=2&from=ios&version=5.2.1&from=ios&channel=appstore",URL_SERVER_ADDRESS_1,@"baidu.ting.plaza.getRecommendAlbum"];
    SFRequest * discRequest = [[SFRequest alloc] init];
    [discRequest request:discString params:nil success:^(id json) {
        NSDictionary * albumListDic = [json objectForKey:@"plaze_album_list"];
        NSDictionary * rmDic = [albumListDic objectForKey:@"RM"];
        NSDictionary * albumDic = [rmDic objectForKey:@"album_list"];
        NSArray * listArray = [albumDic objectForKey:@"list"];
        [self dealWithDiscOnlineArray:listArray];
    } failure:^(NSError *error) {
        YKLog(@"error = %@",error);
    }];
    
}
#pragma mark -- 配置轮播图
- (void)initData
{
    _currentPage = 1;
    _showImageviewArray = [[NSMutableArray alloc] init];
    
    [self addImageview];
    [self addTimer];
    
    //创建承装轮播图的数组
    self.randPicModelArray = [[NSMutableArray alloc] init];
    self.songOrderArray = [[NSMutableArray alloc] init];
    self.discOnlineArray = [[NSMutableArray alloc] init];
    
}
- (void)addPageControl
{
   
}
- (void)addImageview
{
    // 创建了5个imageview装入showImageviewArray中，在展示图片时取出其中三个。也可以将图片地址存入数组，取出三张图片之后，再创建UIImageview。
    
    for(int i = 0;i < 6;i++){
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(MAIN_W*i, 0, MAIN_W, 180)];
        imageView.backgroundColor = YKRandomColor;
        
        imageView.image = [UIImage imageNamed:@"123"];
        [_showImageviewArray addObject:imageView];
        [_randomScrollview addSubview:imageView];
    }
    self.randomScrollview.delegate = self;
}
- (void)setImageWithArray:(NSArray *)array
{
    for(int i = 0;i < _showImageviewArray.count;i++){
        NSDictionary * picdic = nil;
        UIImageView * imageview = [_showImageviewArray objectAtIndex:i];
        if(i < 5){
            picdic = [array objectAtIndex:i];
        }else if (i == 5){
            picdic = [array objectAtIndex:0];
        }
        SFRandPicModel * onePicModel = [SFRandPicModel objectWithKeyValues:picdic];
        if(IPHONE6){
            [imageview sd_setImageWithURL:[NSURL URLWithString:onePicModel.randpic_iphone6] placeholderImage:[UIImage imageNamed:@"123"]];
        }else{
            [imageview sd_setImageWithURL:[NSURL URLWithString:onePicModel.randpic] placeholderImage:[UIImage imageNamed:@"123"]];
        }
        [self.randPicModelArray addObject:onePicModel];
    }

}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //  当开始滑动scrollview时，关闭timer
    if(scrollView == _randomScrollview){
        [_timer invalidate];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger pageNumber = _randomScrollview.contentOffset.x/MAIN_W;
    if(pageNumber == 5){
        _randomScrollview.contentOffset = CGPointMake(0, 0);
        _pageControl.currentPage = 0;
        _currentPage = 0;
    }else
    {
        _pageControl.currentPage = pageNumber;
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    YKLog(@"contentoffset = %@",NSStringFromCGPoint(self.randomScrollview.contentOffset));
    
    NSInteger pageNumber = _randomScrollview.contentOffset.x/MAIN_W;
    _currentPage = pageNumber+1;
    if(_currentPage == 6){
        _currentPage = 1;
    }
   
    if(self.timer != nil){
        [self.timer invalidate];
        [self addTimer];
    }
}
- (void)addTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
}
- (void)nextImage
{
    if(_currentPage >= 6){
        self.randomScrollview.contentOffset = CGPointMake(0, 0);
        _currentPage = 1;
    }
    
    [self.randomScrollview setContentOffset:CGPointMake(MAIN_W*_currentPage, 0) animated:YES];
     _currentPage++;
}
#pragma mark -- <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return 4;
}     
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    SFHeaderView * headerView = nil;
    if(kind == UICollectionElementKindSectionHeader){
        headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerView" forIndexPath:indexPath];
    }
    if(indexPath.section == 0){
        headerView.headerLabel.text = @"热门歌单";
        headerView.moreLabel.hidden = YES;
    }else if (indexPath.section == 1){
        headerView.headerLabel.text = @"新碟上架";
        headerView.moreLabel.hidden = NO;
        headerView.moreLabel.layer.cornerRadius = 10.0;
        headerView.moreLabel.layer.borderColor = [UIColor blackColor].CGColor;
        headerView.moreLabel.layer.borderWidth = 1.0;
        headerView.moreLabel.text = @"更多";
    }
    return headerView;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(MAIN_W-MARGIN*2, 50);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0){
        SFSongOrderCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"songOrder" forIndexPath:indexPath];
        YKLog(@"%@",self.songOrderArray);
        if(self.songOrderArray.count != 0){
            SFSongOrderModel * model = [self.songOrderArray objectAtIndex:indexPath.row];
            cell.songOrderModel = model;
        }
        return cell;
        
    }else if(indexPath.section == 1){
        SFRecItemCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"recCell" forIndexPath:indexPath];
        if(self.discOnlineArray.count != 0){
            SFDiscModel * model = [self.discOnlineArray objectAtIndex:indexPath.row];
            cell.discModel = model;
        }
        return cell;
    }
    return nil;
    
}

#pragma mark -- 配置collectionview相关数据
- (void)dealWithSongOrderArray:(NSArray *)array
{
    for(NSDictionary * dic in array){
      SFSongOrderModel * model = [SFSongOrderModel objectWithKeyValues:dic];
        [self.songOrderArray addObject:model];
    }
}
- (void)dealWithDiscOnlineArray:(NSArray *)array
{
    for(NSDictionary * dic in array){
        SFDiscModel * model = [SFDiscModel objectWithKeyValues:dic];
        [self.discOnlineArray addObject:model];
    }
}
#pragma mark -- <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        SFSongOrderDetailViewController * orderDetailVC = [[SFSongOrderDetailViewController alloc] init];
        [self.navigationController pushViewController:orderDetailVC animated:YES];
    }
}
@end
