//
//  SFSingerListViewController.m
//  SFMusicPlayer
//
//  Created by yake on 15-4-3.
//  Copyright (c) 2015年 yake. All rights reserved.
//

#import "SFSingerListViewController.h"
#import "SFRequest.h"
#import "SFSingerModel.h"
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import "SFSingerListCell.h"

@interface SFSingerListViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    NSString * _order;
    NSString * _limit;
    
    UIScrollView * _bgScrollview;
    
    UILabel * _hotLabel;
    
}
@end

@implementation SFSingerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
    
    [self initData];
    
    [self requestSingerList];
    
}

- (void)setupSubviews
{
    
    self.view.backgroundColor = YKColor(235, 240, 245);
    
    //底部scrollview
    _bgScrollview  = [[UIScrollView alloc] initWithFrame:CGRectMake(MARGIN, MARGIN, MAIN_W-MARGIN*2, MAIN_H-MARGIN)];
    _bgScrollview.contentSize = CGSizeMake(MAIN_W-MARGIN*2, MAIN_H*2);
    _bgScrollview.backgroundColor = YKColor(235, 240, 245);
    _bgScrollview.delegate = self;
    [self.view addSubview:_bgScrollview];
    
    //上方热门标签
    _hotLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MAIN_W-MARGIN*2, 50)];
    _hotLabel.text = @"   热门";
    _hotLabel.backgroundColor = [UIColor whiteColor];
    _hotLabel.alpha = 0.9;
    [_bgScrollview addSubview:_hotLabel];
    
    //下方分割线
    UIView * separatorLine = [[UIView alloc] initWithFrame:CGRectMake(MARGIN, 5, MAIN_W-MARGIN*4, 1)];
    separatorLine.backgroundColor = [UIColor lightGrayColor];
    [_hotLabel addSubview:separatorLine];
    
    //下方tableview
    self.singerTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, _hotLabel.frame.size.height, MAIN_W-MARGIN*2, 10000)];
    self.singerTableview.delegate = self;
    self.singerTableview.dataSource = self;
    self.singerTableview.rowHeight = 64;
    [_bgScrollview addSubview:self.singerTableview];
}
#pragma mark -- 初始化数据
- (void)initData
{
    self.singerListArray = [[NSMutableArray alloc] init];
    _order = @"1";
    _limit = @"50";
    _keyword = @"热门";
}
#pragma mark -- 网络请求
- (void)requestSingerList
{
    /*
  method=baidu.ting.artist.getList&format=json&order=1&limit=50&offset=0&area=6&sex=1&abc=%E7%83%AD%E9%97%A8&from=ios&version=5.2.1&from=ios&channel=appstore
     */
    NSString * string = [NSString stringWithFormat:@"%@?method=%@&format=json&order=%@&limit=%@&offset=0&area=%@&sex=%@&abc=%@&from=ios&version=5.2.1&from=ios&channel=appstore",URL_SERVER_ADDRESS_1,@"baidu.ting.artist.getList",_order,_limit,_area,_sex,_keyword];
    
    NSString * urlString = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    YKLog(@"%@",urlString);
    SFRequest * request = [[SFRequest alloc] init];
    [request request:urlString params:nil success:^(id json) {
        
        NSArray * array = [json objectForKey:@"artist"];
        NSLog(@"array = %@",array);
        [self dealRequestDataWithArray:array];
        [self.singerTableview reloadData];
        
    } failure:^(NSError *error) {
        YKLog(@"error = %@",error);
    }];
}

/**
 *  处理请求回来的数据
 */
- (void)dealRequestDataWithArray:(NSArray *)array
{
    //设置tableview数据
    for(NSDictionary * dic in array){
        SFSingerModel * oneModel = [SFSingerModel objectWithKeyValues:dic];
        [self.singerListArray addObject:oneModel];
    }
    
    //调整tableview的高度和scrollview的contentsize
    CGRect rect = self.singerTableview.frame;
    self.singerTableview.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, self.singerListArray.count*self.singerTableview.rowHeight);

}
#pragma mark -- <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.singerListArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString  * identifier = @"singerCell";
    SFSingerListCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
         cell = [[[NSBundle mainBundle] loadNibNamed:@"SFSingerListCell" owner:self options:nil] lastObject];
        
    }
    SFSingerModel * oneModel = [self.singerListArray objectAtIndex:indexPath.row];
    [cell.avatarImage sd_setImageWithURL:[NSURL URLWithString:oneModel.avatar_big] placeholderImage:[UIImage imageNamed:@"img_default_singer354"]];
    cell.nameLabel.text = oneModel.name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}
#pragma mark -- <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == _bgScrollview){
        YKLog(@"y = %f",scrollView.contentOffset.y);
        UIView * superView = _hotLabel.superview;
        if(scrollView.contentOffset.y >= -49 && superView != self.view){
            [_hotLabel removeFromSuperview];
            _hotLabel.frame = CGRectMake(MARGIN, 64, MAIN_W-MARGIN*2, 50);
            [self.view addSubview:_hotLabel];
        }else if(scrollView.contentOffset.y < -49 && superView == self.view){
            [_hotLabel removeFromSuperview];
            _hotLabel.frame = CGRectMake(0, 0, MAIN_W-MARGIN*2, 50);
            [scrollView addSubview:_hotLabel];
        }
    }
}
@end
