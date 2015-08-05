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

@interface SFSingerDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    UIScrollView * _bgScrollview;
    UIImageView * _bgImageview;
    UIScrollView * _uperScrollview;
    
    //请求参数
    NSString * _tinguid;
    NSString * _artistid;
    NSString * _limits;
    NSString * _order;
    
    UIButton * _songButton;
    UIButton * _albumButton;
    
    UILabel * _nameLabel;
    UILabel * _birthLabel;
    UILabel * _areaLabel;
    
    UINavigationBar * _navigationBar;
    UIPanGestureRecognizer * _panGesture;
    
    BOOL  _isDragging;
    
}
@end

@implementation SFSingerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self createSubviews];
    [self initData];
    [self requestSingerInfo];
    [self requestSongList];
    
    //设置系统导航栏
    [self setDefaultNavBar];
  
    [self createNavBar];
    _isDragging = YES;
}
- (void)setDefaultNavBar
{
     self.navigationController.navigationBar.hidden = YES;
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 20, 20);
    [backButton setBackgroundImage:[UIImage imageNamed:@"bt_playlistdetails_return_normal"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"bt_playlistdetails_return_press"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItem = leftBarItem;
}
- (void)createNavBar
{
    _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, MAIN_W, 64)];
    [_navigationBar setBackgroundImage:[UIImage imageNamed:@"bt_playpage_mask"] forBarMetrics:UIBarMetricsDefault];

    _navigationBar.shadowImage = [[UIImage alloc] init];
    UINavigationItem * item = [[UINavigationItem alloc] init];

    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 20, 20);
    [backButton setBackgroundImage:[UIImage imageNamed:@"bt_playlistdetails_return_normal"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"bt_playlistdetails_return_press"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    item.leftBarButtonItem = leftBarItem;
    
    [item setLeftBarButtonItem:leftBarItem];
    [_navigationBar pushNavigationItem:item animated:YES];
    [self.view addSubview:_navigationBar];
    
}
- (void)addPanGesture
{
  //  UIPanGestureRecognizer * panGestuer = [_uperScrollview.gestureRecognizers lastObject];
#define imagetransfer(str) ({if([str hasSuffix:@".jpg"]){\
[str stringByReplacingOccurrencesOfString:@".jpg" withString:@"_ppc.jpg"];\
}str;})

    NSString * str =  imagetransfer(@"123.jpg");
    
    
}

- (void)backButtonAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createSubviews
{
    //背景scrollview
    _bgScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MAIN_W, MAIN_H)];
    _bgScrollview.contentSize = CGSizeMake(MAIN_W, MAIN_H*2);
    [self.view addSubview:_bgScrollview];
    _bgScrollview.delegate = self;
    _bgScrollview.backgroundColor = [UIColor greenColor];
    
    //背景imageview
    _bgImageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MAIN_W, 360)];
    [self.view addSubview:_bgImageview];
    
    //上层scrollview
    _uperScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MAIN_W, MAIN_H)];
    _uperScrollview.contentSize = CGSizeMake(MAIN_W, MAIN_H*2);
    _uperScrollview.delegate = self;
    [self.view addSubview:_uperScrollview];
    
    //上部分的标签底图
    UIView * labelBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_W, 240)];
    labelBgView.backgroundColor = [UIColor clearColor];
    [_uperScrollview addSubview:labelBgView];
    
    //标签地图背景图
    UIImageView * shadowBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, labelBgView.frame.size.height-64, MAIN_W, 64)];
    shadowBgView.image = [UIImage imageNamed:@"img_scenarioplay_shadow_around"];
    [labelBgView addSubview:shadowBgView];
    
    //上部标签信息
    //姓名标签
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN*2, 0, MAIN_W-MARGIN*4, 25)];
    _nameLabel.text = @"李健";
    _nameLabel.font = [UIFont systemFontOfSize:20.0];
    _nameLabel.textColor = [UIColor whiteColor];
    [shadowBgView addSubview:_nameLabel];
    
    //生日标签
    _birthLabel = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN*2, _nameLabel.frame.origin.y+_nameLabel.frame.size.height, MAIN_W-MARGIN*4, 20)];
    _birthLabel.text = @"生日：";
    _birthLabel.font = [UIFont systemFontOfSize:14.0];
    _birthLabel.textColor = [UIColor whiteColor];
    [shadowBgView addSubview:_birthLabel];
    
    //姓名标签
    _areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN*2, _birthLabel.frame.origin.y+_birthLabel.frame.size.height, MAIN_W-MARGIN*4, 20)];
    _areaLabel.font = [UIFont systemFontOfSize:14.0];
    _areaLabel.text = @"地区：中国";
    _areaLabel.textColor = [UIColor whiteColor];
    [shadowBgView addSubview:_areaLabel];
    
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
    //单曲按钮
    _songButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _songButton.frame =  CGRectMake(0,0,(MAIN_W-MARGIN*6)/2, 40);
    _songButton.center = CGPointMake(selectionView.frame.size.width/4, selectionView.frame.size.height/2);
    [_songButton setTitle:@"单曲" forState:UIControlStateNormal];
    [_songButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    _songButton.backgroundColor = YKColor(230, 230, 230);
    _songButton.layer.cornerRadius = 4.0;
    selectionView.layer.borderColor = [UIColor grayColor].CGColor;
    [_songButton addTarget:self action:@selector(didClickSongButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [selectionView addSubview:_songButton];
    
    //修饰左半边圆角的view
    UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(_songButton.frame.size.width-5, 0, 5, 40)];
    [_songButton addSubview:leftView];
    leftView.tag = 11;
    leftView.backgroundColor = YKColor(230, 230, 230);
    
    //专辑按钮
    _albumButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _albumButton.frame = CGRectMake(selectionView.frame.size.width/2, 0, (MAIN_W-MARGIN*6)/2, 40);
    _albumButton.center = CGPointMake(selectionView.frame.size.width/4*3, selectionView.frame.size.height/2);
    _albumButton.backgroundColor = [UIColor whiteColor];
    _albumButton.layer.cornerRadius = 4.0;
    selectionView.layer.borderColor = [UIColor grayColor].CGColor;
    [_albumButton addTarget:self action:@selector(didClickAlbumButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_albumButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_albumButton setTitle:@"专辑" forState:UIControlStateNormal];
    [selectionView addSubview:_albumButton];
    
    //修饰右半边圆角的view
    UIView * rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 40)];
    [_albumButton addSubview:rightView];
    rightView.tag = 12;
    rightView.backgroundColor = [UIColor whiteColor];
                         
    //播放热门按钮
    UIButton * hotSongButton = [UIButton buttonWithType:UIButtonTypeCustom];
    hotSongButton.frame = CGRectMake(MARGIN*2, selectionView.frame.origin.y+selectionView.frame.size.height+10, 120, 40);
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
    
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 100, 30);
    //设置标题内容
    [button setTitle:@"点击" forState:UIControlStateNormal];
    //设置图片
    [button setImage:[UIImage imageNamed:@"bt_singerdetails_play_normal"] forState:UIControlStateNormal];
    //改变默认标题位置 上，左，下，右
    button.titleEdgeInsets = UIEdgeInsetsMake(0,6, 0, 0);
    //改变默认图片位置 上，左，下，右
    button.imageEdgeInsets = UIEdgeInsetsMake(0,-20,0,button.titleLabel.bounds.size.width);
    
    [self.view addSubview:button];
    
    //收藏按钮
    UIButton * collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    collectionButton.frame = CGRectMake(hotSongButton.frame.origin.x+hotSongButton.frame.size.width+130, hotSongButton.frame.origin.y, 25, 25);
    collectionButton.center = CGPointMake(collectionButton.center.x, hotSongButton.center.y);
    [collectionButton setBackgroundImage:[UIImage imageNamed:@"bt_playlist_collection_normal"] forState:UIControlStateNormal];
    [collectionButton setBackgroundImage:[UIImage imageNamed:@"bt_playlist_collection_press"] forState:UIControlStateSelected];
    [tableviewBgView addSubview:collectionButton];
    
    
    //下载按钮
    UIButton * downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    downloadButton.frame = CGRectMake(0, hotSongButton.frame.origin.y, 25, 25);
    downloadButton.center = CGPointMake(collectionButton.center.x+40, collectionButton.center.y);
    [downloadButton setBackgroundImage:[UIImage imageNamed:@"bt_playlist_download_normal"] forState:UIControlStateNormal];
    [downloadButton setBackgroundImage:[UIImage imageNamed:@"bt_playlist_download_press"] forState:UIControlStateSelected];
    [tableviewBgView addSubview:downloadButton];
    
    //下方分割线
    UIView * separatorLine = [[UIView alloc] initWithFrame:CGRectMake(MARGIN, 115, MAIN_W-MARGIN*3, 1)];
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
#pragma mark -- 自定义button点击事件
- (void)didClickSongButtonAction:(UIButton *)button
{
    //点击单曲按钮两边按钮交换颜色
    UIView * leftView = [button viewWithTag:11];
    UIView * rightView = [_albumButton viewWithTag:12];
    button.backgroundColor = YKColor(230, 230, 230);
    leftView.backgroundColor = YKColor(230, 230, 230);
    
    _albumButton.backgroundColor = [UIColor whiteColor];
    rightView.backgroundColor = [UIColor whiteColor];
    
}
- (void)didClickAlbumButtonAction:(UIButton *)button
{
    //点击单曲按钮两边按钮交换颜色
    UIView * leftView = [_songButton viewWithTag:11];
    UIView * rightView = [button viewWithTag:12];
    button.backgroundColor = YKColor(230, 230, 230);
    rightView.backgroundColor = YKColor(230, 230, 230);
    
    _songButton.backgroundColor = [UIColor whiteColor];
    leftView.backgroundColor = [UIColor whiteColor];
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
- (void)requestSingerInfo
{
    /*
     method=baidu.ting.artist.getinfo&format=json&tinguid=45561&artistid=%28null%29&from=ios&version=5.2.1&from=ios&channel=appstore
     */
    NSString * string = [NSString stringWithFormat:@"%@?method=%@&format=json&tinguid=%@&artistid=%@&from=ios&version=5.2.1&from=ios&channel=appstore",URL_SERVER_ADDRESS_1,@"baidu.ting.artist.getinfo",_singerModel.ting_uid,_singerModel.artist_id];
    
    NSString * urlString = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    YKLog(@"%@",urlString);
    SFRequest * request = [[SFRequest alloc] init];
    [request request:urlString params:nil success:^(id json) {
        
        [self setSingerInfoWithJson:json];
        
    } failure:^(NSError *error) {
        YKLog(@"error = %@",error);
    }];
}
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
- (void)setSingerInfoWithJson:(NSDictionary *)json
{
    //姓名
    NSString * name = [json objectForKey:@"name"];
    _nameLabel.text = name;
    //生日+星座
    NSString * birth = [json objectForKey:@"birth"];
    NSString * constellation = [json objectForKey:@"constellation"];
    _birthLabel.text = [NSString stringWithFormat:@"生日：%@（%@）",birth,constellation];
    
    //地区
    NSString * area = [json objectForKey:@"country"];
    _areaLabel.text = [NSString stringWithFormat:@"地区：%@",area];
    
    //设置背景图片
    [_bgImageview sd_setImageWithURL:[NSURL URLWithString:_singerModel.avatar_big] placeholderImage:[UIImage imageNamed:@"img_default_singer354"]];
    
    //设置导航栏title
    self.title = name;
}
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
#pragma mark -- <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    YKLog(@"y = %f",_uperScrollview.contentOffset.y);
//    if(_uperScrollview.contentOffset.y <= -100){
//      //  [scrollView setContentOffset:scrollView.contentOffset animated:NO];
//     //   scrollView.userInteractionEnabled = NO;
//        
//     //   [_uperScrollview removeFromSuperview];
//        if(_uperScrollview.gestureRecognizers.count != 0){
//            UIPanGestureRecognizer * gesture =  [_uperScrollview.gestureRecognizers lastObject];
//            YKLog(@"gesture = %@",gesture);
//            _uperScrollview.contentOffset = CGPointMake(0, -100);
//            [_bgScrollview addSubview:_uperScrollview];
//            _uperScrollview.contentOffset = CGPointMake(0, -100);
//            _uperScrollview.scrollEnabled = NO;
//            
//            //   _uperScrollview.contentOffset = scrollView.contentOffset;
//            //   _uperScrollview.contentOffset = point;
//            
//            
//            [_bgScrollview addGestureRecognizer:gesture];
//            
//        }else
//            return;
//        
//        
//        
//    }
    
  //  NSLog(@"%s",__FUNCTION__);
    
    NSArray * gestureArray = scrollView.gestureRecognizers;
 //   YKLog(@"gestureArray = %@",gestureArray);
    
    if(_uperScrollview.contentOffset.y > 240-64){
        [_navigationBar removeFromSuperview];
      //  [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.navigationController.navigationBar.hidden = NO;
    }else{
        [self.view addSubview:_navigationBar];
        self.navigationController.navigationBar.hidden = YES;
    }
    
    if(_uperScrollview.contentOffset.y < -120 && _isDragging == YES){
        _bgImageview.frame = CGRectMake(0, -_uperScrollview.contentOffset.y-120, MAIN_W, _bgImageview.frame.size.height);
    }
    if(_isDragging == NO){
        _bgImageview.frame = CGRectMake(0, -_uperScrollview.contentOffset.y-120, MAIN_W, _bgImageview.frame.size.height);
        if(_bgImageview.frame.origin.x <= 0){
            _bgImageview.frame = CGRectMake(0, 0, MAIN_W, _bgImageview.frame.size.height);
        }
    }
    
    if(_uperScrollview.contentOffset.y >0){
        _bgImageview.frame = CGRectMake(0, -_uperScrollview.contentOffset.y, MAIN_W, _bgImageview.frame.size.height);
    }
    
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"%s",__FUNCTION__);
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"%s",__FUNCTION__);
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSLog(@"%s",__FUNCTION__);
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
     NSLog(@"%s",__FUNCTION__);
    _isDragging = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
     NSLog(@"%s",__FUNCTION__);
    _isDragging = YES;
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
     NSLog(@"%s",__FUNCTION__);
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
     NSLog(@"%s",__FUNCTION__);
}
@end
