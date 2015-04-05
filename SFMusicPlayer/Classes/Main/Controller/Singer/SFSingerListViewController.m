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
#import "SFTool.h"
#import "SFSingerSelectViewController.h"
#import "AppDelegate.h"
#import "SFSingerDetailViewController.h"

@interface SFSingerListViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate>
{
    NSString * _order;
    NSString * _limit;
    
    UIScrollView * _bgScrollview;
    
    //scrollview大背景
    UIView * _bgView;
    UIView * _hotBgView;
    UILabel * _hotLabel;
    
    
    
  
}
@end

@implementation SFSingerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
    
    [self initData];
    
    [self requestSingerList];
    
    //创建选择页面
    [self createSelectView];
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)setupSubviews
{
    
    self.view.backgroundColor = YKColor(235, 240, 245);
    
    //底部scrollview
    _bgScrollview  = [[UIScrollView alloc] initWithFrame:CGRectMake(MARGIN, 0, MAIN_W-MARGIN*2, MAIN_H)];
    _bgScrollview.contentSize = CGSizeMake(MAIN_W-MARGIN*2, MAIN_H*2);
    _bgScrollview.backgroundColor = YKColor(235, 240, 245);
    _bgScrollview.delegate = self;
    [self.view addSubview:_bgScrollview];
    
    //上方热门标签
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, MARGIN, MAIN_W-MARGIN*2, 50)];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.alpha = 0.9;
    _bgView.userInteractionEnabled = YES;
    [_bgScrollview addSubview:_bgView];
    
    
    //上方热门标签背景
    _hotBgView = [[UIView alloc] initWithFrame:CGRectMake(MARGIN*2, 0, MAIN_W-MARGIN*6, 50)];
    _hotBgView.backgroundColor = [UIColor whiteColor];
    _hotBgView.alpha = 0.9;
    _hotBgView.userInteractionEnabled = YES;
    [_bgView addSubview:_hotBgView];
    
    //热门标签
    _hotLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _hotBgView.frame.size.width, 30)];
    _hotLabel.text = @"热门";
    _hotLabel.center = CGPointMake(_hotLabel.center.x, _hotBgView.center.y);
    [_hotBgView addSubview:_hotLabel];
    
    //下方分割线
    UILabel * separatorLine = [[UILabel alloc] initWithFrame:CGRectMake(0,_hotBgView.frame.size.height-0.5, MAIN_W-MARGIN*6, 0.5)];
    separatorLine.backgroundColor = [UIColor lightGrayColor];
    [_hotBgView addSubview:separatorLine];
    
    //下方tableview
    self.singerTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, _hotBgView.frame.size.height, MAIN_W-MARGIN*2, 10000)];
    _singerTableview.backgroundColor = [UIColor whiteColor];
    self.singerTableview.delegate = self;
    self.singerTableview.dataSource = self;
    self.singerTableview.rowHeight = 64;

    [_bgView addSubview:self.singerTableview];
}
- (void)createSelectView
{
    _singerSelectVC = [[SFSingerSelectViewController alloc] init];
    _singerSelectVC.view.frame = CGRectMake(0, 0, MAIN_W, MAIN_H);
    
    _singerSelectVC.selectDelegate = self;
    //给选择页面添加手势
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectSinger)];
    [_singerSelectVC.view addGestureRecognizer:tapGesture];
}
#pragma mark -- 初始化数据
- (void)initData
{
    self.title = self.navBarTitle;
    
    //设置右侧排序按钮
    UIButton * orderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    orderButton.frame = CGRectMake(0, 0, 20, 20);
    [orderButton setBackgroundImage:[UIImage imageNamed:@"bt_hot_az_normal"] forState:UIControlStateNormal];
    [orderButton setBackgroundImage:[UIImage imageNamed:@"bt_hot_az_press"] forState:UIControlStateHighlighted];
    [orderButton addTarget:self action:@selector(selectFirstCharactorAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:orderButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
  //  [SFTool setNavBarWithNavagationBar:self];
    //自定义返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 20, 20);
    [backButton setBackgroundImage:[UIImage imageNamed:@"bt_playlistdetails_return_normal"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"bt_playlistdetails_return_press"] forState:UIControlStateSelected];
    [backButton setTag:YES];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.singerListArray = [[NSMutableArray alloc] init];
    _order = @"1";
    _limit = @"50";
    _keyword = @"热门";
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
   // _bgScrollview = nil;
}
#pragma mark -- 自定义button点击事件
- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)selectFirstCharactorAction:(UIButton *)button
{
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow * keyWindow = delegate.window;
    [keyWindow addSubview:_singerSelectVC.view];
  //  [self addChildViewController:_singerSelectVC];
    
}
- (void)selectSinger
{
      [_singerSelectVC.view removeFromSuperview];
}
#pragma mark -- 选择首字母代理事件
- (void)selectSingerWithClickedButton:(UIButton *)button
{
    NSString * title = button.titleLabel.text;
    [_singerSelectVC.view removeFromSuperview];
    _keyword = title;
    [self requestSingerList];
}
#pragma mark -- 网络请求

- (void)requestSingerList
{
    NSString * string = [NSString stringWithFormat:@"%@?method=%@&format=json&order=%@&limit=%@&offset=0&area=%@&sex=%@&abc=%@&from=ios&version=5.2.1&from=ios&channel=appstore",URL_SERVER_ADDRESS_1,@"baidu.ting.artist.getList",_order,_limit,_area,_sex,_keyword];

    NSString * urlString = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    YKLog(@"%@",urlString);
    SFRequest * request = [[SFRequest alloc] init];
    [request request:urlString params:nil success:^(id json) {
        YKLog(@"json = %@",json);
        NSNumber * nums = [json objectForKey:@"nums"];
        NSString * numStr = [NSString stringWithFormat:@"%@",nums];

        if([numStr isEqualToString:@"0"]){
            [self alert];
            return ;
        }
        NSArray * array = [json objectForKey:@"artist"];
        
        [self dealRequestDataWithArray:array];
        [self.singerTableview reloadData];
        _hotLabel.text = _keyword;
        
    } failure:^(NSError *error) {
        YKLog(@"error = %@",error);
    }];
}
- (void)alert
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有符合条件的歌手" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alert.delegate = self;
    [alert show];
}
/**
 *  处理请求回来的数据
 */
- (void)dealRequestDataWithArray:(NSArray *)array
{
    YKLog(@"array = %@",array);
    //设置tableview数据
    [self.singerListArray removeAllObjects];
    for(NSDictionary * dic in array){
        SFSingerModel * oneModel = [SFSingerModel objectWithKeyValues:dic];
        [self.singerListArray addObject:oneModel];
    }
    
    //调整tableview的高度和scrollview的contentsize
    CGRect rect = self.singerTableview.frame;
    self.singerTableview.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, self.singerListArray.count*self.singerTableview.rowHeight);
    _bgScrollview.contentSize = CGSizeMake(MAIN_W-MARGIN*2, MARGIN+_hotBgView.frame.size.height+_singerTableview.frame.size.height);
    
    _bgView.frame = CGRectMake(0, MARGIN, MAIN_W-MARGIN*2, _singerTableview.frame.origin.y+_singerTableview.frame.size.height);

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
#pragma mark -- <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFSingerDetailViewController * singerDetailVC = [[SFSingerDetailViewController alloc] init];
    SFSingerModel * singerModel = [self.singerListArray objectAtIndex:indexPath.row];
    singerDetailVC.singerModel = singerModel;
    [self.navigationController pushViewController:singerDetailVC animated:YES];
    
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
}
#pragma mark -- <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(_bgScrollview != nil && scrollView == _bgScrollview){
        if(_hotBgView != nil && _bgView != nil){
            UIView * superView = _hotBgView.superview;
            if(scrollView.contentOffset.y >= -49 && superView != self.view){
                
                [_hotBgView removeFromSuperview];
                _hotBgView.frame = CGRectMake(MARGIN*3, 64, MAIN_W-MARGIN*6, 50);
                [self.view addSubview:_hotBgView];
                
            }else if(scrollView.contentOffset.y < -49 && superView == self.view){
                
                [_hotBgView removeFromSuperview];
                _hotBgView.frame = CGRectMake(MARGIN*2, 0, MAIN_W-MARGIN*6, 50);
                [_bgView addSubview:_hotBgView];
            }
        }
       
    }
}
- (void)dealloc
{
//    _singerTableview = nil;
//    _bgScrollview = nil;
//    _bgView = nil;
//    _hotBgView = nil;
//    //  _singerSelectVC = nil;
//    _hotLabel = nil;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}
@end
