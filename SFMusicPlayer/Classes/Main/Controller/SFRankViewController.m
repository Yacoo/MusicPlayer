//
//  SFRankViewController.m
//  SFMusicPlayer
//
//  Created by yake on 15-3-26.
//  Copyright (c) 2015年 yake. All rights reserved.
//

#import "SFRankViewController.h"
#import "SFRequest.h"
#import <MJExtension.h>
#import "SFRankCell.h"
#import "SFContentItemModel.h"


@interface SFRankViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation SFRankViewController

static NSString * const reuseIdentifier = @"rank";

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setupSubviews];
    [self requestRankOrder];
}

- (void)setupSubviews
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(139, 200);
    if(IPHONE6){
        layout.itemSize = CGSizeMake(165, 220);
    }
    layout.sectionInset = UIEdgeInsetsMake(MARGIN, MARGIN, MARGIN, MARGIN);
    self.rankCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(MARGIN, MARGIN, MAIN_W-MARGIN*2, MAIN_H-108-MARGIN-49) collectionViewLayout:layout];
    self.rankCollectionView.backgroundColor = [UIColor whiteColor];
    [self.rankCollectionView registerNib:[UINib nibWithNibName:@"SFRankCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    self.rankCollectionView.dataSource = self;
    self.rankCollectionView.delegate = self;
    [self.view addSubview:_rankCollectionView];
}
#pragma mark -- 数据请求
- (void)requestRankOrder
{
    self.rankOrderArray = [[NSMutableArray alloc] init];
    /*
     method=baidu.ting.billboard.billCategory&format=json&from=ios&version=5.2.1&from=ios&channel=appstore
     */
    NSString * urlString = [NSString stringWithFormat:@"%@?method=%@&format=json&from=ios&version=5.2.1&from=ios&channel=appstore",URL_SERVER_ADDRESS_1,@"baidu.ting.billboard.billCategory"];
    SFRequest * rankRequest = [[SFRequest alloc] init];
    [rankRequest request:urlString params:nil success:^(id json) {
        NSArray * contentArray = [json objectForKey:@"content"];
        [self dealWithRankItemArray:contentArray];
        [self.rankCollectionView reloadData];
        
    } failure:^(NSError *error) {
        YKLog(@"error = %@",error);
    }];
}
#pragma mark -- 处理返回的数据
- (void)dealWithRankItemArray:(NSArray *)array
{
    for(NSDictionary * dic in array){
        SFContentItemModel * model = [SFContentItemModel objectWithKeyValues:dic];
        [self.rankOrderArray addObject:model];
    }
}
#pragma mark -- <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.rankOrderArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SFRankCell * cell = nil;

    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"rank" forIndexPath:indexPath];
    SFContentItemModel * model = [self.rankOrderArray objectAtIndex:indexPath.row];
    cell.contentItemModel = model;

    return cell;
}

#pragma mark -- <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    YKDetailViewController * detailVC = [[YKDetailViewController alloc] init];
    //    detailVC.deal = self.deals[indexPath.item];
    //    [self presentViewController:detailVC animated:YES completion:nil];
}
@end
