//
//  SFSingerViewController.m
//  SFMusicPlayer
//
//  Created by yake on 15-3-26.
//  Copyright (c) 2015年 yake. All rights reserved.
//

#import "SFSingerViewController.h"
#import "SFSingerModel.h"
#import <UIImageView+WebCache.h>
#import "SFRequest.h"
#import <MJExtension.h>
#import "SFSingerListViewController.h"

@interface SFSingerViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@end

@implementation SFSingerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self setupSubviews];
    [self requestHotSinger];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
/**
 * 绘制子视图
 */
- (void)setupSubviews
{
    //创建底部scrollview
    UIScrollView * bgScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MAIN_W, MAIN_H-49)];
    bgScrollview.contentSize = CGSizeMake(MAIN_W, MAIN_H*2);
    bgScrollview.scrollEnabled = YES;
    bgScrollview.alwaysBounceVertical = YES;
    bgScrollview.alwaysBounceHorizontal = NO;
    [self.view addSubview:bgScrollview];
    
    //上方背景view
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(MARGIN, MARGIN, MAIN_W-MARGIN*2, 230)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.userInteractionEnabled = YES;
    [bgScrollview addSubview:bgView];
    
    //热门歌手标签
    UILabel * hotSingerLabel = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN, MARGIN*2, 100, 30)];
    hotSingerLabel.text = @"热门歌手";
    [bgView addSubview:hotSingerLabel];
    
    //热门歌手滚动图
    self.hotSingerScroll = [[UIScrollView alloc] init];
    self.hotSingerScroll.pagingEnabled = YES;
    self.hotSingerScroll.delegate = self;
    [bgView addSubview:_hotSingerScroll];
    [self createImageview];
    
    //pageControl
    self.hotSingerPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    self.hotSingerPageControl.center = CGPointMake(MAIN_W/2, self.hotSingerScroll.frame.origin.y+self.hotSingerScroll.frame.size.height+15);
    self.hotSingerPageControl.numberOfPages = 4;
    self.hotSingerPageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    [bgScrollview addSubview:self.hotSingerPageControl];
    
    //创建歌手分类的tableview
    self.singerTableview = [[UITableView alloc] initWithFrame:CGRectMake(MARGIN, bgView.frame.origin.y+bgView.frame.size.height, MAIN_W-MARGIN*2, 690) style:UITableViewStyleGrouped];
    self.singerTableview.scrollEnabled = NO;
    self.singerTableview.rowHeight = 50;
    self.singerTableview.dataSource = self;
    self.singerTableview.delegate = self;
    //设置header的背景色
    self.singerTableview.tableHeaderView.backgroundColor = YKColor(235, 240, 245);
    [bgScrollview addSubview:_singerTableview];
    
    //重新调整scrollview的contentsize
    bgScrollview.contentSize = CGSizeMake(MAIN_W, _singerTableview.frame.origin.y+_singerTableview.frame.size.height+108);
}

- (void)initData
{
    self.singerArray = [[NSMutableArray alloc] initWithObjects:@"华语男歌手",@"华语女歌手",@"华语乐队组合",@"欧美男歌手",@"欧美女歌手",@"欧美乐队组合",@"韩国男歌手",@"韩国女歌手",@"韩国乐队组合",@"日本男歌手",@"日本女歌手",@"日本乐队组合",@"其他歌手", nil];
}
/**
 * 绘制scrollview中的图片
 */
- (void)createImageview
{
    //不同设备中图像宽度不同
    NSInteger imageWidth = 90;
    if(IPHONE6){
        imageWidth = 100;
    }else if (IPHONE6PLUS){
        imageWidth = 110;
    }
    
    //计算每张imageview的间距
    NSInteger totalLength = (MAIN_W-MARGIN*4)/3;
    NSInteger gap = (totalLength-imageWidth)/2;
    
    //重新调整scrollview的frame
    self.hotSingerScroll.frame = CGRectMake(MARGIN, 50, totalLength*3, 130);
    self.hotSingerScroll.contentSize = CGSizeMake(totalLength*12, 130);
    
    //创建数组
    self.imageArray = [[NSMutableArray alloc] init];
    self.nameLabelArray = [[NSMutableArray alloc] init];
    
    //创建热门歌手头像和名字标签
    for(int i = 0;i<12;i++){
        //歌手头像
        UIImageView * imageview = [[UIImageView alloc] initWithFrame:CGRectMake(gap+imageWidth*i+gap*2*i, 0, imageWidth, imageWidth)];
        imageview.backgroundColor = YKRandomColor;
        [self.hotSingerScroll addSubview:imageview];
        [self.imageArray addObject:imageview];
        
        //歌手姓名标签
        UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, totalLength, 30)];
        nameLabel.center = CGPointMake(imageview.frame.origin.x + imageWidth/2, imageview.frame.size.height+15);
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.text = @"123";
        [self.nameLabelArray addObject:nameLabel];
        [self.hotSingerScroll addSubview:nameLabel];
        
    }
}

/**
 * 给头像和姓名标签赋值
 */
- (void)setPhotoAndNameWithArray:(NSArray *)array
{
    for(int i = 0;i<12;i++){
        NSDictionary * dic = [array objectAtIndex:i];
        //取出一个歌手模型
        SFSingerModel * singer = [SFSingerModel objectWithKeyValues:dic];
        
        [self.hotSingerArray addObject:singer];
        
        //取出对应的头像和名字标签
        UIImageView * imageview = [self.imageArray objectAtIndex:i];
        UILabel * nameLabel = [self.nameLabelArray objectAtIndex:i];
        
        //给头像和姓名赋值
        [imageview sd_setImageWithURL:[NSURL URLWithString:singer.avatar_big] placeholderImage:[UIImage imageNamed:@"img_default_singer354"]];
        nameLabel.text = singer.name;
        
    }
}
#pragma mark -- 请求数据
- (void)requestHotSinger
{
    NSString  * urlString = [NSString stringWithFormat:@"%@?method=%@&format=json&order=1&limit=12&offset=0&area=0&sex=0&abc=&from=ios&version=5.2.1&from=ios&channel=appstore",URL_SERVER_ADDRESS_1,@"baidu.ting.artist.getList"];
    SFRequest * request = [[SFRequest alloc] init];
    [request request:urlString params:nil success:^(id json) {
        NSArray * artistArray = [json objectForKey:@"artist"];
        [self setPhotoAndNameWithArray:artistArray];
    } failure:^(NSError *error) {
        YKLog(@"error = %@",error);
    }];
}
#pragma mark -- 处理返回的数据

#pragma mark -- <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == _singerTableview){
        if(section == 5){
            return 1;
        }else{
            return 3;
        }
    }
    return 0;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == _singerTableview){
         return 5;
    }
    return 0;
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView == _singerTableview){
       return MARGIN;
    }
    return 0;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.000001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _singerTableview){
        static NSString * ID = @"singer";
        UITableViewCell *  cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.textLabel.text = [self.singerArray objectAtIndex:(indexPath.section)*3+indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    return nil;
    
}

#pragma mark -- <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFSingerListViewController * singerListVC = [[SFSingerListViewController alloc] init];
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [self setSingerListVC:singerListVC Text:cell.textLabel.text];
//    singerListVC.area = @"6";
//    singerListVC.sex = @"1";
//    singerListVC.navBarTitle = @"华语男歌手";
    [self.navigationController pushViewController:singerListVC animated:YES];
    cell.selected = NO;
    
    
}
#pragma mark -- 私有方法
/**
 * 处理歌手列表参数
 */
- (void)setSingerListVC:(SFSingerListViewController *)singerListVC Text:(NSString *)text
{
    //area
    NSRange chinaRange = [text rangeOfString:@"华语"];
    NSRange europeRange = [text rangeOfString:@"欧美"];
    NSRange koreaRange = [text rangeOfString:@"韩国"];
    NSRange japanRange = [text rangeOfString:@"日本"];
    NSRange otherRange = [text rangeOfString:@"其他"];
    
    if(chinaRange.length > 0){
        singerListVC.area = @"6";
    }else if (europeRange.length > 0){
        singerListVC.area = @"3";
    }else if (koreaRange.length > 0){
        singerListVC.area = @"7";
    }else if (japanRange.length > 0){
        singerListVC.area = @"60";
    }else if(otherRange.length > 0){
        singerListVC.area = @"5";
    }
    
    //sex
    NSRange maleRange = [text rangeOfString:@"男"];
    NSRange femaleRange = [text rangeOfString:@"女"];
    
    if(maleRange.length > 0){
        singerListVC.sex = @"1";
    }else if (femaleRange.length > 0){
        singerListVC.sex = @"2";
    }else{
        singerListVC.sex = @"3";
    }
    
    //title
    singerListVC.navBarTitle = text;
    
}

#pragma mark -- <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == self.hotSingerScroll){
        NSInteger width = (MAIN_W-MARGIN*4);
        NSInteger pageNumber = self.hotSingerScroll.contentOffset.x/width;
        self.hotSingerPageControl.currentPage = pageNumber+1;
    }
  
}
@end
