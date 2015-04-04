//
//  SFSingerDetailViewController.m
//  SFMusicPlayer
//
//  Created by yake on 15-4-4.
//  Copyright (c) 2015年 yake. All rights reserved.
//

#import "SFSingerDetailViewController.h"
#import "SFRequest.h"
#import "SFSongModel.h"
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import "SFSongOrderDetailCell.h"

@interface SFSingerDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIScrollView * _bgScrollview;
    UIImageView * _bgImageview;
    UIScrollView * _uperScrollview;
    
    //请求参数
    NSString * _tinguid;
    NSString * _artistid;
    NSString * _limits;
    NSString * _order;
}
@end

@implementation SFSingerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createSubviews];
    [self initData];
    [self requestSongList];
    
   // self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
   // self.navigationController.navigationBar.hidden = YES;
}

- (void)createSubviews
{
    //背景scrollview
    _bgScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MAIN_W, MAIN_H)];
    _bgScrollview.contentSize = CGSizeMake(MAIN_W, MAIN_H*2);
    [self.view addSubview:_bgScrollview];
    _bgScrollview.backgroundColor = [UIColor greenColor];
    
    //背景imageview
    _bgImageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MAIN_W, 250)];
    _bgImageview.backgroundColor = [UIColor redColor];
    [_bgScrollview addSubview:_bgImageview];
    
    //上层scrollview
    _uperScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MAIN_W, MAIN_H)];
    _uperScrollview.contentSize = CGSizeMake(MAIN_W, MAIN_H*2);
    [self.view addSubview:_uperScrollview];
    
    //上部分的标签底图
    UIView * labelBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_W, 200)];
    labelBgView.backgroundColor = [UIColor clearColor];
    [_uperScrollview addSubview:labelBgView];
    
    //下方背景色底图
    UIView * bgColorView = [[UIView alloc] initWithFrame:CGRectMake(0, labelBgView.frame.size.height, MAIN_W, MAIN_H)];
    bgColorView.backgroundColor = YKColor(235, 240, 245);
    [_uperScrollview addSubview:bgColorView];
    
    //下方背景底图
    UIView * tableviewBgView = [[UIView alloc] initWithFrame:CGRectMake(MARGIN, MARGIN, MAIN_W-MARGIN*2, MAIN_H)];
    tableviewBgView.backgroundColor = [UIColor whiteColor];
    [bgColorView addSubview:tableviewBgView];
    
    //下方选择按钮底图
    UIView * selectionView = [[UIView alloc] initWithFrame:CGRectMake(MARGIN*2, MARGIN*2,MAIN_W-MARGIN*6 , 40)];
    selectionView.layer.borderColor = [UIColor grayColor].CGColor;
    selectionView.layer.cornerRadius = 4.0;
    selectionView.userInteractionEnabled = YES;
    selectionView.layer.borderWidth = 1.0;
    [tableviewBgView addSubview:selectionView];
    
    //选择按钮
    UIButton * songButton = [UIButton buttonWithType:UIButtonTypeCustom];
    songButton.frame =  CGRectMake(0,0, 80, 40);
    songButton.center = CGPointMake(selectionView.frame.size.width/4, selectionView.frame.size.height/2);
    [songButton setTitle:@"单曲" forState:UIControlStateNormal];
    [songButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    songButton.backgroundColor = [UIColor redColor];
    [selectionView addSubview:songButton];
    
    UIButton * albumButton = [UIButton buttonWithType:UIButtonTypeCustom];
    albumButton.frame = CGRectMake(selectionView.frame.size.width/2, 0, 80, 40);
    albumButton.center = CGPointMake(selectionView.frame.size.width/4*3, selectionView.frame.size.height/2);
    [albumButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [albumButton setTitle:@"专辑" forState:UIControlStateNormal];
    [selectionView addSubview:albumButton];
                         
    //播放热门按钮
    UIButton * hotSongButton = [UIButton buttonWithType:UIButtonTypeCustom];
    hotSongButton.frame = CGRectMake(MARGIN*2, selectionView.frame.origin.y+selectionView.frame.size.height+30, 120, 40);
    [hotSongButton setImage:[UIImage imageNamed:@"bt_singerdetails_play_normal"] forState:UIControlStateNormal];
  //  [hotSongButton setBackgroundImage:[UIImage imageNamed:@"bt_singerdetails_play_normal"] forState:UIControlStateNormal];
    [hotSongButton setImage:[UIImage imageNamed:@"bt_singerdetails_play_press"] forState:UIControlStateHighlighted];
     hotSongButton.imageEdgeInsets = UIEdgeInsetsMake(0,-20,0,hotSongButton.titleLabel.bounds.size.width);
    [hotSongButton setTitle:@"播放热门" forState:UIControlStateNormal];
    hotSongButton.titleLabel.textColor = [UIColor blackColor];
    [hotSongButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [hotSongButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    hotSongButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
     hotSongButton.titleEdgeInsets = UIEdgeInsetsMake(0,6, 0, 0);
    hotSongButton.backgroundColor = [UIColor whiteColor];
    [tableviewBgView addSubview:hotSongButton];
    
    //收藏按钮
    UIButton * collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    collectionButton.frame = CGRectMake(hotSongButton.frame.origin.x+hotSongButton.frame.size.width+100, hotSongButton.frame.origin.y, 20, 20);
    [collectionButton setBackgroundImage:[UIImage imageNamed:@"bt_playlist_collection_normal"] forState:UIControlStateNormal];
    [collectionButton setBackgroundImage:[UIImage imageNamed:@"bt_playlist_collection_press"] forState:UIControlStateSelected];
    [tableviewBgView addSubview:collectionButton];
    
    
    //下载按钮
    UIButton * downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    downloadButton.frame = CGRectMake(collectionButton.frame.origin.x+collectionButton.frame.size.width+30, hotSongButton.frame.origin.y, 20, 20);
    [downloadButton setBackgroundImage:[UIImage imageNamed:@"bt_playlist_download_normal"] forState:UIControlStateNormal];
    [downloadButton setBackgroundImage:[UIImage imageNamed:@"bt_playlist_download_press"] forState:UIControlStateSelected];
    [tableviewBgView addSubview:downloadButton];
    
    //下方分割线
    UIView * separatorLine = [[UIView alloc] initWithFrame:CGRectMake(MARGIN, 150, MAIN_W-MARGIN*3, 1)];
    separatorLine.backgroundColor = [UIColor lightGrayColor];
    [tableviewBgView addSubview:separatorLine];
    
    //下方歌曲tableview
    self.songsTableview = [[UITableView alloc] initWithFrame:CGRectMake(0,separatorLine.frame.origin.y+separatorLine.frame.size.height, MAIN_W-MARGIN*2, 10000)];
    _songsTableview.backgroundColor = [UIColor whiteColor];
    self.songsTableview.delegate = self;
    self.songsTableview.dataSource = self;
    self.songsTableview.rowHeight = 64;
    [tableviewBgView addSubview:self.songsTableview];
    
}
#pragma mark -- 初始化数据
- (void)initData
{
    self.songsArray = [[NSMutableArray alloc] init];
    
    _tinguid = @"1383";
    _limits = @"50";
    _order = @"2";
}
#pragma mark -- 请求数据
- (void)requestSongList
{
    /*
     method=baidu.ting.artist.getSongList&format=json&tinguid=1383&artistid=(null)&limits=50&order=2&offset=0&version=5.2.1&from=ios&channel=appstore

     */
    NSString  * urlString = [NSString stringWithFormat:@"%@?method=%@&format=json&tinguid=%@&artistid=%@&limits=%@&order=%@&offset=0&version=5.2.1&from=ios&channel=appstore",URL_SERVER_ADDRESS_1,@"baidu.ting.artist.getSongList",_tinguid,_artistid,_limits,_order];
    YKLog(@"url = %@",urlString);
    SFRequest * request = [[SFRequest alloc] init];
    [request request:urlString params:nil success:^(id json) {
        NSArray * songsArray = [json objectForKey:@"songlist"];
        [self setSongsListWithArray:songsArray];
        [self.songsTableview reloadData];
    } failure:^(NSError *error) {
        YKLog(@"error = %@",error);
    }];
}
#pragma mark -- 处理返回的数据
- (void)setSongsListWithArray:(NSArray *)array
{
    [self.songsArray removeAllObjects];
    for(NSDictionary * dic in array){
        SFSongModel * songModel = [SFSongModel objectWithKeyValues:dic];
        [self.songsArray addObject:songModel];
    }

    
    YKLog(@"array = %@",array);
}
#pragma mark -- <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.songsArray.count;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString  * identifier = @"songOrderDetailCell";
    SFSongOrderDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SFSongOrderDetailCell" owner:self options:nil] lastObject];
    }
    SFSongModel * songModel = [self.songsArray objectAtIndex:indexPath.row];
    cell.songNameLabel.text = songModel.title;
    cell.singerNameLabel.text = songModel.author;
    return cell;
    
}

#pragma mark -- <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}


@end
