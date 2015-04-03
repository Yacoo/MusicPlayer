//
//  SFMainViewController.m
//  SFMusicPlayer
//
//  Created by yake on 15-3-23.
//  Copyright (c) 2015年 yake. All rights reserved.
//

#import "SFMainViewController.h"
#import "SFRecViewController.h"
#import "SFSongOrderViewController.h"
#import "SFRankViewController.h"
#import "SFSingerViewController.h"
#import "SFPlayViewController.h"

@interface SFMainViewController ()<UIScrollViewDelegate>
{
    UIScrollView * _indicatorScroll;
    
    //用来区别点击事件和滑动事件造成的scrollview的滚动
    BOOL clickAction;

}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIView *backgroundBarView;

//scrollview上的四个页面
@property (nonatomic, strong)SFRecViewController * recVC;
@property (nonatomic, strong)SFSongOrderViewController * songOrderVC;
@property (nonatomic, strong)SFRankViewController * rankVC;
@property (nonatomic, strong)SFSingerViewController * singerVC;

//上方button
@property (weak, nonatomic) IBOutlet UIButton *mainViewButton;
@property (weak, nonatomic) IBOutlet UIButton *songOrderButton;
@property (weak, nonatomic) IBOutlet UIButton *rankViewButton;
@property (weak, nonatomic) IBOutlet UIButton *singerButton;
@property (weak, nonatomic) IBOutlet UIView *bgBarView;

//歌手页面的数据
@property (nonatomic, strong)NSMutableArray * singerArray;

//当前选中button
@property (nonatomic, strong)UIButton * selectedButton;
@end

@implementation SFMainViewController

#pragma mark -- setter
- (void)setSelectedButton:(UIButton *)selectedButton
{
    _selectedButton = selectedButton;
    [selectedButton setTitleColor:YKColor(15, 121, 237) forState:UIControlStateNormal];
}
#pragma mark -- UI
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:YKColor(34, 145, 231)];
    self.navigationController.navigationBar.alpha = 0.8;
}
- (void)setupSubviews
{
    [self setupScrollview];
    [self setupbgBarView];
    [self setupPlayVC];
}
- (void)setupbgBarView
{
    //指示滚轮
    _indicatorScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, MAIN_W, 4)];
    _indicatorScroll.contentSize = CGSizeMake(MAIN_W*2, 4);
    _indicatorScroll.contentOffset = CGPointMake(MAIN_W, 0);
    _indicatorScroll.scrollEnabled = NO;
    
    //图标白色背景
    UIView * bgWhiteView = [[UIView alloc] initWithFrame:CGRectMake(MAIN_W, 0, MAIN_W/4, 4)];
    
    //指示小图标
    UIImageView * indicatorView = [[UIImageView alloc] initWithFrame:CGRectMake(MARGIN*2, 0, MAIN_W/4-MARGIN*4, 4)];
    [bgWhiteView addSubview:indicatorView];
    indicatorView.image = [UIImage imageNamed:@"bg_onlinemusic_second-class-navigation_hl"];
    indicatorView.backgroundColor = YKColor(34, 145, 231);
    indicatorView.alpha = 0.8;
    [_indicatorScroll addSubview:bgWhiteView];
    [self.bgBarView addSubview:_indicatorScroll];
    
}
- (void)setupScrollview
{
    self.scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 108, MAIN_W, MAIN_H-108)];
    self.scrollview.contentSize = CGSizeMake(MAIN_W*4, MAIN_H-108);
    self.scrollview.backgroundColor = YKColor(235, 240, 245);
    self.scrollview.pagingEnabled = YES;
    self.scrollview.delegate = self;
    [self.view addSubview:_scrollview];
    [self setupSubviewsInScrollview];
    
}

- (void)setupSubviewsInScrollview
{
    //添加主页
    self.recVC = [[SFRecViewController alloc] init];
    [self addChildViewController:self.recVC];
    [self.scrollview addSubview:self.recVC.view];
    
    self.songOrderVC = [[SFSongOrderViewController alloc] init];
    self.songOrderVC.view.frame = CGRectMake(MAIN_W, 0, MAIN_W, MAIN_H-44-49);
    
    self.rankVC = [[SFRankViewController alloc] init];
    self.rankVC.view.frame = CGRectMake(MAIN_W*2, 0, MAIN_W, MAIN_H-44-49);
    
    self.singerVC = [[SFSingerViewController alloc] init];
    self.singerVC.view.frame = CGRectMake(MAIN_W*3, 0, MAIN_W, MAIN_H-44-49);
}

- (void)setupPlayVC
{
    SFPlayViewController * playVC = [SFPlayViewController sharedInstance];
    playVC.view.frame = CGRectMake(0, 0, MAIN_W, 49);
    playVC.view.center = CGPointMake(MAIN_W/2, MAIN_H-49/2);
    [self.view addSubview:playVC.view];
    [self addChildViewController:playVC];
    
}
#pragma mark -- 初始化数据


- (IBAction)buttonAction:(id)sender {
    
    UIButton * button = (UIButton *)sender;
    [self initButtonColor];
    self.selectedButton = button;
    clickAction = YES;
    if(button.tag == 10){
        self.scrollview.contentOffset = CGPointMake(0, 0);
    }else if (button.tag == 11){
        self.scrollview.contentOffset = CGPointMake(MAIN_W, 0);
    }else if (button.tag == 12){
        self.scrollview.contentOffset = CGPointMake(MAIN_W*2, 0);
    }else{
        self.scrollview.contentOffset = CGPointMake(MAIN_W*3, 0);
    }
}

- (void)setTitleColorForButton:(UIButton *)button color:(UIColor *)color
{
    [button setTitleColor:color forState:UIControlStateNormal];
}

//初始化按钮颜色
- (void)initButtonColor
{
    [self setTitleColorForButton:_mainViewButton color:[UIColor blackColor]];
    [self setTitleColorForButton:_songOrderButton color:[UIColor blackColor]];
    [self setTitleColorForButton:_rankViewButton color:[UIColor blackColor]];
    [self setTitleColorForButton:_singerButton color:[UIColor blackColor]];
}

#pragma mark -- <UIScrollViewDelegate>
//开始滑动scrollview触发此方法。

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //将指示器的偏移量与下方的偏移量同步
    CGPoint point = scrollView.contentOffset;
    _indicatorScroll.contentOffset = CGPointMake(MAIN_W-point.x/4, 0);
    
    //只要scrollview开始滚动初始化所有的button
    [self initButtonColor];
    if(clickAction == YES){
        
        //点击事件不触发此方法，主动调用将最终指向的button置为蓝色。
        [self scrollViewDidEndDecelerating:scrollView];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    clickAction = NO;
    NSInteger index = scrollView.contentOffset.x/MAIN_W;
//    if(self.recVC.timer != nil){
//        [self.recVC.timer invalidate];
//        self.recVC.timer = nil;
//    }
   
    if(index == 0){
        self.selectedButton = _mainViewButton;
       // [self.recVC addTimer];
    }else if (index == 1){
        self.selectedButton = _songOrderButton;
        //添加歌单页面
        [self addChildViewController:self.songOrderVC];
        [self.scrollview addSubview:self.songOrderVC.view];
       
    }else if (index == 2){
        self.selectedButton = _rankViewButton;
        //排行榜
        
        [self addChildViewController:_rankVC];
        [self.scrollview addSubview:_rankVC.view];
       
    }else if(index == 3){
        self.selectedButton = _singerButton;
        //歌手页面
        
        [self addChildViewController:self.singerVC];
        [self.scrollview addSubview:self.singerVC.view];

    }
}

@end
