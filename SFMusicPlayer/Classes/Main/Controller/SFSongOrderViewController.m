//
//  SFSongOrderViewController.m
//  SFMusicPlayer
//
//  Created by yake on 15-3-26.
//  Copyright (c) 2015年 yake. All rights reserved.
//

#import "SFSongOrderViewController.h"
#import "SFRequest.h"
#import "SFSongItemModel.h"
#import <MJExtension.h>
#import "SFSongOrderCell.h"
#import "SFSongOrderDetailViewController.h"

@interface SFSongOrderViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    //请求参数
    NSString * _page_no;
    NSString * _page_size;
}
@end

@implementation SFSongOrderViewController

static NSString * const reuseIdentifier = @"songOrder";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
    [self requestSongOrder];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)requestSongOrder
{
    self.songItemArray = [[NSMutableArray alloc] init];
    
    _page_no = @"1";
    _page_size = @"30";
    NSString * urlString = [NSString stringWithFormat:@"%@?method=%@&page_size=%@&page_size=%@&from=ios&version=5.2.1&from=ios&channel=appstore",URL_SERVER_ADDRESS_1,@"baidu.ting.diy.gedan",_page_no,_page_size];
    SFRequest * songOrderRequest = [[SFRequest alloc] init];
    [songOrderRequest request:urlString params:nil success:^(id json) {
        NSArray * contentArray = [json objectForKey:@"content"];
        YKLog(@"contentArray = %@",contentArray);
        [self dealWithSongItemArray:contentArray];
        [self.songOrderCollection reloadData];
    } failure:^(NSError *error) {
        YKLog(@"songItemError = %@",error);
    }];
}
- (void)setupSubviews
{
    //标签背景
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(MARGIN, MARGIN, MAIN_W-MARGIN *2, 30+MARGIN)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.alpha = 0.8;
    [self.view addSubview:bgView];
    
    //语言标签
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN, MARGIN, 70, 30)];
    self.nameLabel.text = @"全部歌单";
    [bgView addSubview:_nameLabel];
    
    //切换按钮
    self.changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _changeButton.frame = CGRectMake(90, MARGIN, 25, 25);
    _changeButton.center = CGPointMake(_changeButton.center.x, self.nameLabel.center.y);
   // _changeButton.backgroundColor = [UIColor yellowColor];
    [_changeButton setBackgroundImage:[UIImage imageNamed:@"bt_playlist_choice_normal"] forState:UIControlStateNormal];
    [_changeButton setBackgroundImage:[UIImage imageNamed:@"bt_playlist_choice_press"] forState:UIControlStateSelected];
    
    [bgView addSubview:_changeButton];
    
    //collectionview
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake(139, 200);
    if(IPHONE6){
        layout.itemSize = CGSizeMake(165, 220);
    }
    layout.sectionInset = UIEdgeInsetsMake(MARGIN, MARGIN, MARGIN, MARGIN);

    self.songOrderCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(MARGIN, 30+MARGIN*2, MAIN_W-MARGIN*2, MAIN_H-108-30-MARGIN*2-49) collectionViewLayout:layout];
    self.songOrderCollection.backgroundColor = [UIColor whiteColor];
    self.songOrderCollection.dataSource = self;
    self.songOrderCollection.delegate = self;
    [self.songOrderCollection registerNib:[UINib nibWithNibName:@"SFSongOrderCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    [self.view addSubview:_songOrderCollection];
    
    
}
#pragma mark -- 处理请求回来的数据
- (void)dealWithSongItemArray:(NSArray *)array
{
    for(NSDictionary * dic in array){
        SFSongItemModel * model = [SFSongItemModel objectWithKeyValues:dic];
        [self.songItemArray addObject:model];
    }
}

#pragma mark -- <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    YKLog(@"array = %@",self.songItemArray);
    return self.songItemArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SFSongOrderCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"songOrder"forIndexPath:indexPath];
    
    SFSongItemModel * model = [self.songItemArray objectAtIndex:indexPath.row];
    cell.songItemModel = model;
    return cell;
}

#pragma mark -- <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
        SFSongOrderDetailViewController * orderDetailVC = [[SFSongOrderDetailViewController alloc] init];
        [self.navigationController pushViewController:orderDetailVC animated:YES];
}
@end
