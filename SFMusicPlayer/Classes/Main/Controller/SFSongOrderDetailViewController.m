//
//  SFSongOrderDetailViewController.m
//  SFMusicPlayer
//
//  Created by yake on 15-4-1.
//  Copyright (c) 2015年 yake. All rights reserved.
//

#import "SFSongOrderDetailViewController.h"

@interface SFSongOrderDetailViewController ()
{
    UIView * _bgView;
    BOOL _close;
    BOOL _stopScrolling;
    UIView * _tapGestureView;
    UITapGestureRecognizer * _tapGesture;
}
@end

@implementation SFSongOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _stopScrolling = NO;
    self.view.backgroundColor = YKRandomColor;
    
    //设置背景图片和文字
    [self createBgTextAndView];
    
    //设置上方蒙版scrollview
    [self createScrollList];
}
#pragma mark -- UI
- (void)createBgTextAndView
{
    //创建imageview
    UIImageView *bgImageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MAIN_W, MAIN_H/2)];
    bgImageview.backgroundColor = [UIColor blackColor];
    [self.view addSubview:bgImageview];
    
    //下方文字
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN *3, bgImageview.frame.size.height+MARGIN*2, MAIN_W, 30)];
    titleLabel.text = @"标题";
    titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    //tag
    UILabel * tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN*3, titleLabel.frame.origin.y+titleLabel.frame.size.height+MARGIN*2, MAIN_W, 30)];
    tagLabel.text = @"标签";
    tagLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:tagLabel];
    
    //介绍
    UILabel * deacLabel = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN*3, tagLabel.frame.origin.y+tagLabel.frame.size.height+MARGIN*2, MAIN_W, 30)];
    deacLabel.text = @"介绍";
    deacLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:deacLabel];
    
    
}
- (void)createScrollList
{
    self.songListScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(MARGIN, 0, MAIN_W-MARGIN*2, MAIN_H)];
    self.songListScroll.contentSize = CGSizeMake(MAIN_W-MARGIN*2, 800);
    self.songListScroll.backgroundColor = [UIColor clearColor];
    self.songListScroll.delegate = self;
   // self.songListScroll.decelerating = NO;
    [self.view addSubview:self.songListScroll];
    
    //scrollview上方背景view
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_W-MARGIN*2, MAIN_H/2-40)];
    _bgView.backgroundColor = [UIColor clearColor];
    _bgView.userInteractionEnabled = YES;
    [self.songListScroll addSubview:_bgView];
    
    //标题label
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN*2, 150, 200, 50)];
    titleLabel.text = @"假如爱有天意";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    [_bgView addSubview:titleLabel];
    
    //听歌imageview
    UIImageView * onLineImage = [[UIImageView alloc] initWithFrame:CGRectMake(MARGIN*2, titleLabel.frame.origin.y+titleLabel.frame.size.height, 15, 15)];
    onLineImage.image = [UIImage imageNamed:@"ic_onlinemusic_listen_number"];
    [_bgView addSubview:onLineImage];
    
    //听歌人数
    UILabel * onLineNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(onLineImage.frame.origin.x+onLineImage.frame.size.width, onLineImage.frame.origin.y, 40, 15)];
    onLineNumLabel.text = @"12345";
    onLineNumLabel.font = [UIFont systemFontOfSize:13.0];
    onLineNumLabel.textColor = [UIColor whiteColor];
    [_bgView addSubview:onLineNumLabel];
    
    //收藏image
    UIImageView * collectionImage = [[UIImageView alloc] initWithFrame:CGRectMake(onLineNumLabel.frame.origin.x+onLineNumLabel.frame.size.width+15, onLineImage.frame.origin.y, 15, 15)];
    collectionImage.image = [UIImage imageNamed:@"bt_playpage_collection_normal"];
    [_bgView addSubview:collectionImage];
    
    //收藏人数
    UILabel * collectionNum = [[UILabel alloc] initWithFrame:CGRectMake(collectionImage.frame.origin.x+collectionImage.frame.size.width+5, onLineImage.frame.origin.y, 40, 15)];
    collectionNum.text = @"34456";
    collectionNum.font = [UIFont systemFontOfSize:13.0];
    collectionNum.textColor = [UIColor whiteColor];
    [_bgView addSubview:collectionNum];
    
    
    //标签背景view
    UIView * tagBgView = [[UIView alloc] initWithFrame:CGRectMake(0, _bgView.frame.size.height, MAIN_W-MARGIN*2, 50)];
    tagBgView.backgroundColor = [UIColor whiteColor];
    [self.songListScroll addSubview:tagBgView];
    tagBgView.userInteractionEnabled = YES;
    //下方tableview
    self.songListTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, tagBgView.frame.origin.y+tagBgView.frame.size.height, MAIN_W-MARGIN*2, 500)];
    
    //收起按钮
    UIButton * closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(0, 0, 50, 15);
    closeButton.center = CGPointMake(tagBgView.center.x+MARGIN, tagBgView.frame.origin.y-5);
    closeButton.layer.cornerRadius = 4.0;
    [closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _close = NO;
    closeButton.backgroundColor = [UIColor whiteColor];

    //中心图片
    UIImageView * centerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 11, 6)];
    centerImage.image = [UIImage imageNamed:@"bt_localmusic_arrow_normal"];
    centerImage.backgroundColor = [UIColor whiteColor];
    centerImage.center = CGPointMake(closeButton.frame.size.width/2, closeButton.frame.size.height/2-2);
    [closeButton addSubview:centerImage];
    [self.songListScroll addSubview:closeButton];
    
    //下方分割线
    UIView * separatorLine = [[UIView alloc] initWithFrame:CGRectMake(MARGIN*2, tagBgView.frame.size.height-1, MAIN_W-MARGIN*4, 1)];
    separatorLine.backgroundColor = [UIColor lightGrayColor];
    [tagBgView addSubview:separatorLine];
    
    //歌曲总数label
    UILabel * totalNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN*2, 10, 60, 20)];
    totalNumLabel.text = @"共10首";
    totalNumLabel.textColor = [UIColor grayColor];
    [tagBgView addSubview:totalNumLabel];
    
    //收藏按钮
    UIButton * collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    collectionButton.frame = CGRectMake(totalNumLabel.frame.origin.x+totalNumLabel.frame.size.width+100, 10, 20, 20);
    [collectionButton setBackgroundImage:[UIImage imageNamed:@"bt_playlist_collection_normal"] forState:UIControlStateNormal];
    [collectionButton setBackgroundImage:[UIImage imageNamed:@"bt_playlist_collection_press"] forState:UIControlStateSelected];
    [tagBgView addSubview:collectionButton];
    
    
    //下载按钮
    UIButton * downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    downloadButton.frame = CGRectMake(collectionButton.frame.origin.x+collectionButton.frame.size.width+30, 10, 20, 20);
    [downloadButton setBackgroundImage:[UIImage imageNamed:@"bt_playlist_download_normal"] forState:UIControlStateNormal];
    [downloadButton setBackgroundImage:[UIImage imageNamed:@"bt_playlist_download_press"] forState:UIControlStateSelected];
    [tagBgView addSubview:downloadButton];
    
    //分享按钮
    UIButton * shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(downloadButton.frame.origin.x+downloadButton.frame.size.width+30, 10, 20, 20);
    [shareButton setBackgroundImage:[UIImage imageNamed:@"bt_playlistdetails_share_normal"] forState:UIControlStateNormal];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"bt_playlistdetails_share_press"] forState:UIControlStateSelected];
    [tagBgView addSubview:shareButton];
    
    self.songListTableview.delegate = self;
    self.songListTableview.dataSource = self;
    self.songListTableview.scrollEnabled = NO;
    self.songListTableview.backgroundColor = [UIColor whiteColor];
    [self.songListScroll addSubview:self.songListTableview];
    
    //创建点击上滑手势
    _tapGestureView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_W, MAIN_H)];
    _tapGestureView.userInteractionEnabled = YES;
    _tapGestureView.backgroundColor = [UIColor clearColor];
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [_tapGestureView addGestureRecognizer:_tapGesture];
}
#pragma mark -- button点击事件
- (void)closeButtonAction:(UIButton *)button
{
    if(_close == NO)
    {
        [self.songListScroll setContentOffset:CGPointMake(0, -280) animated:YES];
      //  self.songListScroll.contentOffset = CGPointMake(0, -280);
        [_bgView setHidden:YES];
        _close = YES;
        [self.songListScroll addGestureRecognizer:_tapGesture];
    }else{
        [self.songListScroll setContentOffset:CGPointMake(0, 0) animated:YES];
        [_bgView setHidden:NO];
        _close = NO;
        [self.songListScroll removeGestureRecognizer:_tapGesture];
    }

}
- (void)tapGesture:(UITapGestureRecognizer *)tapGesture
{
    [self.songListScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    _bgView.hidden = NO;
    _close = NO;
    
    [_tapGestureView removeFromSuperview];
}
#pragma mark -- <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString  * identifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
#pragma mark -- <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark -- <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    

}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}
-(void)scrollViewWillBeginDecelerating: (UIScrollView *)scrollView{

    if(self.songListScroll.contentOffset.y < -100){
          [scrollView setContentOffset:CGPointMake(0, -280) animated:YES];
        _close = YES;
        _bgView.hidden = YES;
        
    }
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if(self.songListScroll == scrollView){
        [self.view addSubview:_tapGestureView];
    }
}
@end
