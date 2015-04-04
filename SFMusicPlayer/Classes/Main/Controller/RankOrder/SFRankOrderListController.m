//
//  SFRankOrderListControllerViewController.m
//  SFMusicPlayer
//
//  Created by yake on 15-4-2.
//  Copyright (c) 2015年 yake. All rights reserved.
//

#import "SFRankOrderListController.h"
#import "SFRequest.h"
#import "SFSongModel.h"
#import <MJExtension.h>
#import "SFRankListItemCell.h"
#import <UIImageView+WebCache.h>
#import "SFTool.h"

@interface SFRankOrderListController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIImageView * _bgImageview;
    UIScrollView * _mainScrollview;
    
    //连接参数
    
    NSString * _size;
}
@end

@implementation SFRankOrderListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏
    [SFTool setNavBarWithNavagationBar:self];
    
    //创建背景imageview
    [self createBgImageview];
    
    //创建滚动视图
    [self createMainScrollview];
    
    //初始化数据
    [self initRankData];
    
    //请求数据
    [self requestRankList];
    
}
- (void)initRankData
{
    self.rankListArray = [[NSMutableArray alloc] init];
    _size = @"50";
}
- (void)createBgImageview
{
    _bgImageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MAIN_W, 300)];
    [_bgImageview sd_setImageWithURL:[NSURL URLWithString:_contentItemModel.pic_s192] placeholderImage:[UIImage imageNamed:@"img_default_playlist546"]];
    [self.view addSubview:_bgImageview];
}
- (void)createMainScrollview
{
    _mainScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MAIN_W, MAIN_H)];
    _mainScrollview.backgroundColor = [UIColor clearColor];
    _mainScrollview.contentSize = CGSizeMake(MAIN_W, 700);
    [self.view addSubview:_mainScrollview];
    
    //下方背景图
    UIView * bottomColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 250, MAIN_W,600)];
    bottomColorView.backgroundColor = YKColor(219, 229, 234);
    [_mainScrollview addSubview:bottomColorView];
    
    //播放按钮
    UIButton * playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    playButton.frame = CGRectMake(0, 0, 60, 60);
    playButton.center = CGPointMake(bottomColorView.frame.size.width-45, bottomColorView.frame.origin.y-45);
    [playButton addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    [playButton setBackgroundImage:[UIImage imageNamed:@"bt_playlist_play_normal"] forState:UIControlStateNormal];
    [playButton setBackgroundImage:[UIImage imageNamed:@"bt_playlist_play_press"] forState:UIControlStateHighlighted];

    [_mainScrollview addSubview:playButton];
    
    //tableview上方标签
    UIView * downLoadView = [[UIView alloc] initWithFrame:CGRectMake(MARGIN,MARGIN, MAIN_W-MARGIN*2, 60)];
    downLoadView.backgroundColor = [UIColor whiteColor];
    [bottomColorView addSubview:downLoadView];
    
    //标签内文字
    //更新时间标签
    UILabel * updateTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN*2, 15, 290, 30)];
    updateTimeLabel.text = @"4月2日更新";
    [downLoadView addSubview:updateTimeLabel];
    
    //下载按钮
    UIButton * downLoadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    downLoadButton.frame = CGRectMake(updateTimeLabel.frame.origin.x+updateTimeLabel.frame.size.width, updateTimeLabel.frame.origin.y, 25, 25);
    [downLoadButton setBackgroundImage:[UIImage imageNamed:@"bt_playlist_download_normal"] forState:UIControlStateNormal];
    [downLoadButton setBackgroundImage:[UIImage imageNamed:@"bt_playlist_download_press"] forState:UIControlStateSelected];
    [downLoadView addSubview:downLoadButton];
    
    //下方分割线
    UIView * separatorLine = [[UIView alloc] initWithFrame:CGRectMake(MARGIN, downLoadView.frame.size.height-1, MAIN_W-MARGIN*3, 1)];
    separatorLine.backgroundColor = [UIColor lightGrayColor];
    [downLoadView addSubview:separatorLine];
    
    //创建tableview
    self.rankListTableview = [[UITableView alloc] initWithFrame:CGRectMake(MARGIN, downLoadView.frame.origin.y+downLoadView.frame.size.height, MAIN_W-MARGIN*2, 500) style:UITableViewStylePlain];
    self.rankListTableview.scrollEnabled = NO;
    self.rankListTableview.delegate = self;
    self.rankListTableview.dataSource = self;
    [bottomColorView addSubview:self.rankListTableview];
}
#pragma mark -- 播放按钮的点击事件
-(void)playAction:(UIButton *)playButton
{
    
}
#pragma mark -- 网络请求
- (void)requestRankList
{
    /*
   method=baidu.ting.billboard.billList&type=200&format=json&offset=0&size=50&from=ios&fields=title,song_id,author,resource_type,havehigh,is_new,has_mv_mobile,album_title,ting_uid,album_id,charge,all_rate&version=5.2.1&from=ios&channel=appstore
     */
    NSString * urlString = [NSString stringWithFormat:@"%@?method=%@&&type=%@&format=json&offset=0&size=%@&from=ios&fields=title,song_id,author,resource_type,havehigh,is_new,has_mv_mobile,album_title,ting_uid,album_id,charge,all_rate&version=5.2.1&from=ios&channel=appstore",URL_SERVER_ADDRESS_1,@"baidu.ting.billboard.billList",_contentItemModel.type,_size];
    SFRequest * request = [[SFRequest alloc] init];
    [request request:urlString params:nil success:^(id json) {
        
        NSMutableArray * array = [json objectForKey:@"song_list"];
        [self dealRequestDataWithArray:array];
        [self.rankListTableview reloadData];
        
    } failure:^(NSError *error) {
        YKLog(@"error = %@",error);
    }];
}

/**
 *  处理请求回来的数据
 */
- (void)dealRequestDataWithArray:(NSMutableArray *)array
{
    //设置tableview数据
    for(NSDictionary * dic in array){
        SFSongModel * oneModel = [SFSongModel objectWithKeyValues:dic];
        [self.rankListArray addObject:oneModel];
    }
    
    
}
#pragma mark -- <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rankListArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString  * identifier = @"rankListCell";
    SFRankListItemCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SFRankListItemCell" owner:self options:nil] lastObject];
    }
    SFSongModel * oneModel = [self.rankListArray objectAtIndex:indexPath.row];
    NSString * rankStr = [NSString stringWithFormat:@"%d",indexPath.row +1];
    cell.rankNumLabel.text = [self dealWithRankNumWithString:rankStr];
    [self setTextColorForLabel:cell.rankNumLabel];
    cell.songNameLabel.text = oneModel.title;
    cell.singerNameLabel.text = oneModel.author;
    
    return cell;
}
#pragma mark -- 私有方法
- (NSString *)dealWithRankNumWithString:(NSString *)string
{
    if(string.length == 1){
        //如果是一位前方自动补零
     NSString * newString = [NSString stringWithFormat:@"0%@",string];
        return newString;
    }else{
       return string;
    }
    
}
/**
 *  处理label颜色
 */
- (void)setTextColorForLabel:(UILabel *)label
{
    YKLog(@"label.text = %@",label.text);
    if([label.text isEqualToString:@"01"]){
        label.textColor = YKColor(230, 0, 0);
    }else if([label.text isEqualToString:@"02"]){
        label.textColor = YKColor(234, 119, 0);
    }else if ([label.text isEqualToString:@"03"]){
        label.textColor = YKColor(238, 199, 0);
    }
}
#pragma mark -- <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
