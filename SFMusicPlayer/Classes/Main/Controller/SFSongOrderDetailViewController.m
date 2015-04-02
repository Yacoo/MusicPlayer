//
//  SFSongOrderDetailViewController.m
//  SFMusicPlayer
//
//  Created by yake on 15-4-1.
//  Copyright (c) 2015年 yake. All rights reserved.
//

#import "SFSongOrderDetailViewController.h"
#import "SFRequest.h"
#import "SFSongOrderListModel.h"
#import "SFSongModel.h"
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import "UIImage+MostColor.h"

@interface SFSongOrderDetailViewController ()
{
   
    BOOL _close;
    BOOL _stopScrolling;
    UIView * _tapGestureView;
    UITapGestureRecognizer * _tapGesture;
    
    SFSongOrderListModel * _songOrderListModel;
    
    //创建imageview
    UIImageView * _bgImageview;
    
    //底层view下方标题文字
    UILabel * _bottomTitleLabel;
    
    //歌单名称
    UILabel * _titleLabel;
    
    //tag
    UILabel * _tagLabel;
    
    //介绍
    UILabel * _deacLabel;
    
    //听歌人数
    UILabel * _onLineNumLabel;
    
    //收藏人数
    UILabel * _collectionNum;
    
    //歌曲总数
    UILabel * _totalNumLabel;
}
@end

@implementation SFSongOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _stopScrolling = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置背景图片和文字
    [self createBgTextAndView];
    
    //设置上方蒙版scrollview
    [self createScrollList];
    
    [self requestSongOrder];
}
#pragma mark -- UI
- (void)createBgTextAndView
{
    //创建imageview
   _bgImageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MAIN_W, MAIN_H/2+40)];
    _bgImageview.image = [UIImage imageNamed:@"img_default_playlist546"];
    [self.view addSubview:_bgImageview];
    
    //下方文字
    _bottomTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN *2, _bgImageview.frame.size.height+MARGIN*2, MAIN_W-MARGIN*4, 30)];
    _bottomTitleLabel.text = @"";
    _bottomTitleLabel.font = [UIFont fontWithName:@"Times New Roman" size:19.0];
    _bottomTitleLabel.textColor = YKColor(245, 245, 220);
    [self.view addSubview:_bottomTitleLabel];
    
    //标签
    _tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN*2, _bottomTitleLabel.frame.origin.y+_bottomTitleLabel.frame.size.height+MARGIN*2, MAIN_W-MARGIN*4, 25)];
    _tagLabel.text = @"";
    _tagLabel.font = [UIFont fontWithName:@"Times New Roman" size:14.0];
    _tagLabel.backgroundColor = [UIColor clearColor];
    _tagLabel.textColor = YKColor(245, 245, 220);
    [self.view addSubview:_tagLabel];
    
    //介绍
    _deacLabel = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN*2, _tagLabel.frame.origin.y+_tagLabel.frame.size.height, MAIN_W-MARGIN*4, 100)];
    _deacLabel.font = [UIFont fontWithName:@"Times New Roman" size:14.0];
    _deacLabel.numberOfLines = 0;
    //米黄色 YKColor(247, 238, 214)
    // 杏仁白  255, 235, 205
    // 米色 245, 245, 220
    _deacLabel.textColor = YKColor(245, 245, 220);
    _deacLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_deacLabel];
    
    
}
- (void)createScrollList
{
    self.songListScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(MARGIN, 0, MAIN_W-MARGIN*2, MAIN_H)];
    self.songListScroll.contentSize = CGSizeMake(MAIN_W-MARGIN*2, 800);
    self.songListScroll.backgroundColor = [UIColor clearColor];
    self.songListScroll.delegate = self;
    [self.view addSubview:self.songListScroll];
    
    //scrollview上方背景view
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_W-MARGIN*2, MAIN_H/2-40)];
    _bgView.backgroundColor = [UIColor clearColor];
    _bgView.userInteractionEnabled = YES;
    [self.songListScroll addSubview:_bgView];
    
    //标题label
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN*2, 150, 200, 50)];
    _titleLabel.text = @"";
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.backgroundColor = [UIColor clearColor];
    [_bgView addSubview:_titleLabel];
    
    //听歌imageview
    UIImageView * onLineImage = [[UIImageView alloc] initWithFrame:CGRectMake(MARGIN*2, _titleLabel.frame.origin.y+_titleLabel.frame.size.height, 15, 15)];
    onLineImage.image = [UIImage imageNamed:@"ic_onlinemusic_listen_number"];
    [_bgView addSubview:onLineImage];
    
    //听歌人数
    _onLineNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(onLineImage.frame.origin.x+onLineImage.frame.size.width, onLineImage.frame.origin.y, 50, 15)];
    _onLineNumLabel.text = @"";
    _onLineNumLabel.font = [UIFont systemFontOfSize:12.0];
    _onLineNumLabel.textColor = [UIColor whiteColor];
    [_bgView addSubview:_onLineNumLabel];
    
    //收藏image
    UIImageView * collectionImage = [[UIImageView alloc] initWithFrame:CGRectMake(_onLineNumLabel.frame.origin.x+_onLineNumLabel.frame.size.width+15, onLineImage.frame.origin.y, 15, 15)];
    collectionImage.image = [UIImage imageNamed:@"bt_playpage_collection_normal"];
    [_bgView addSubview:collectionImage];
    
    _collectionNum = [[UILabel alloc] initWithFrame:CGRectMake(collectionImage.frame.origin.x+collectionImage.frame.size.width+5, onLineImage.frame.origin.y, 40, 15)];
    _collectionNum.text = @"";
    _collectionNum.font = [UIFont systemFontOfSize:12.0];
    _collectionNum.textColor = [UIColor whiteColor];
    [_bgView addSubview:_collectionNum];
    
    
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
    _totalNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN*2, 10, 60, 20)];
    _totalNumLabel.text = @"";
    _totalNumLabel.textColor = [UIColor grayColor];
    [tagBgView addSubview:_totalNumLabel];
    
    //收藏按钮
    UIButton * collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    collectionButton.frame = CGRectMake(_totalNumLabel.frame.origin.x+_totalNumLabel.frame.size.width+100, 10, 20, 20);
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
#pragma mark -- 网络请求
- (void)requestSongOrder
{
    /*
    method=baidu.ting.diy.gedanInfo&from=ios&listid=5238&version=5.2.1&from=ios&channel=appstore
     */
    NSString * urlString = [NSString stringWithFormat:@"%@?method=%@&from=ios&listid=%@&version=5.2.1&from=ios&channel=appstore",URL_SERVER_ADDRESS_1,@"baidu.ting.diy.gedanInfo",_listid];
    SFRequest * request = [[SFRequest alloc] init];
    [request request:urlString params:nil success:^(id json) {
       _songOrderListModel = [SFSongOrderListModel objectWithKeyValues:json];
       
        [self dealWithRequestData];
        
    } failure:^(NSError *error) {
        YKLog(@"error = %@",error);
    }];
}

/**
 *  处理请求回来的数据
 */
- (void)dealWithRequestData
{
    [self.songListTableview reloadData];
    
    //歌单名称
    _titleLabel.text = _songOrderListModel.title;
    
    //听歌人数
    _onLineNumLabel.text = _songOrderListModel.listenum;
    
    //收藏人数
    _collectionNum.text = _songOrderListModel.collectnum;
    
    //歌曲总数
    _totalNumLabel.text = [NSString stringWithFormat:@"共%ld首",_songOrderListModel.content.count];
    
    //底层标签
    _bottomTitleLabel.text = _songOrderListModel.title;
    
    //标签
    _tagLabel.text = [NSString stringWithFormat:@"标签：%@",_songOrderListModel.tag];
    
    //介绍
  //  _deacLabel.text = [NSString stringWithFormat:@"介绍：%@",_songOrderListModel.desc];
    //调整label的frame
    CGRect rect = [self contentHeight:[NSString stringWithFormat:@"介绍：%@",_songOrderListModel.desc]];
//    _deacLabel.frame = CGRectMake(MARGIN*2, _tagLabel.frame.origin.y+_tagLabel.frame.size.height, MAIN_W-MARGIN*4, height);
    
 //   [_deacLabel setFrame:rect];
    [_deacLabel setFrame:CGRectMake(MARGIN*2,  _tagLabel.frame.origin.y+_tagLabel.frame.size.height, rect.size.width, rect.size.height)];
    
    //底层图片
  //  [_bgImageview sd_setImageWithURL:[NSURL URLWithString:_songOrderListModel.pic_300] placeholderImage:[UIImage imageNamed:@"img_default_playlist546"]];
    [_bgImageview sd_setImageWithURL:[NSURL URLWithString:_songOrderListModel.pic_300] placeholderImage:[UIImage imageNamed:@"img_default_playlist546"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
         //获取底层图片主要颜色,设置下方图片背景色
        UIColor * mostColor = [image mostColor];
        const CGFloat * c = CGColorGetComponents(mostColor.CGColor);
        //红
        CGFloat c1 =  c[0];
        //绿
        CGFloat c2 = c[1];
        //蓝
        CGFloat c3 = c[2];
        
        UIColor * resultColor = [UIColor colorWithRed:c1-0.2 green:c2-0.2 blue:c3-0.3 alpha:1.0];
        self.view.backgroundColor = resultColor;
    }];
}
/**
 *  动态设置label的宽高
 */
-(CGRect)contentHeight:(NSString *)content;
{
    NSMutableAttributedString *contentString = [[NSMutableAttributedString alloc] initWithString:content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = 4;
    [contentString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, content.length)];
    [contentString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Times New Roman" size:14.0] range:NSMakeRange(0, content.length)];
    NSDictionary *attribute = @{ NSFontAttributeName:[UIFont fontWithName:@"Times New Roman" size:14.0], NSParagraphStyleAttributeName:paragraphStyle};
    
    CGRect textRext = [content boundingRectWithSize:CGSizeMake(MAIN_W-MARGIN*4, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    [_deacLabel setAttributedText:contentString];
    return textRext;
   
}
#pragma mark -- button点击事件
- (void)closeButtonAction:(UIButton *)button
{
    if(_close == NO)
    {
        [self.songListScroll setContentOffset:CGPointMake(0, -280) animated:YES];
        [_bgView setHidden:YES];
        
        [self.view addSubview:_tapGestureView];
        _close = YES;
       
    }else{
        [self.songListScroll setContentOffset:CGPointMake(0, 0) animated:YES];
        [_bgView setHidden:NO];
        _close = NO;
       
    }

}
- (void)tapGesture:(UITapGestureRecognizer *)tapGesture
{
    [self.songListScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    _bgView.hidden = NO;
    _close = NO;
    
    [_tapGestureView removeFromSuperview];
}
#pragma mark -- 背景view消失与出现的动画效果
- (void)hiddenAnimatedWithScrollview:(UIScrollView *)scrollview
{
  //  CAAnimationGroup * group = [CAAnimationGroup animation];
//    [UIView animateWithDuration:3.0 animations:^{
//        scrollview.contentOffset = CGPointMake(0, -280);
//    } completion:<#^(BOOL finished)completion#>]
    
 //   CABasicAnimation * animationOffset = [CABasicAnimation animationWithKeyPath:@"contentOffset.y"];
    
    [UIView animateWithDuration:3.0 animations:^{
        _bgView.alpha = 0.0;
    } completion:^(BOOL finished) {
        
    }];
//    [UIView beginAnimations:@"hide animation" context:(__bridge void *)(_bgView)];
//    [UIView setAnimationDuration:3.0];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationWillStartSelector:@selector(animationWillStart:context:)];
//    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
}
//动画开始时,代理要执行的方法,不是协议提供的,需要根据UIView规定的格式声明
-(void)animationWillStart:(NSString *)animationID context:(void *)context
{
    _bgView.alpha = 1.0;
   
    NSLog(@"animationID = %@,context = %@",animationID,context);
}
-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
  //  _bgView.hidden = YES;
    _bgView.alpha = 0.0;
}
- (void)showAnimated
{
    
}
#pragma mark -- <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    YKLog(@"content = %@",_songOrderListModel.content);
    return _songOrderListModel.content.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString  * identifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    SFSongModel * songModel = _songOrderListModel.content[indexPath.row];
    cell.textLabel.text = songModel.title;
    return cell;
}
#pragma mark -- <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark -- <UIScrollViewDelegate>
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
   // NSLog(@"%s",__FUNCTION__);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   //  NSLog(@"%s",__FUNCTION__);

}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // NSLog(@"%s",__FUNCTION__);
}

-(void)scrollViewWillBeginDecelerating: (UIScrollView *)scrollView{

  //  NSLog(@"%s",__FUNCTION__);
    if(self.songListScroll.contentOffset.y < -100){
      //  [self hiddenAnimated];
        
          [scrollView setContentOffset:CGPointMake(0, -280) animated:YES];
     //   [UIView performSystemAnimation:(UISystemAnimation) onViews:<#(NSArray *)#> options:<#(UIViewAnimationOptions)#> animations:<#^(void)parallelAnimations#> completion:<#^(BOOL finished)completion#>]
        _close = YES;
        _bgView.hidden = YES;
        [self.view addSubview:_tapGestureView];
        
    }
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSLog(@"%s",__FUNCTION__);
}
@end
