//
//  SFRadioViewController.m
//  SFMusicPlayer
//
//  Created by yake on 15-3-30.
//  Copyright (c) 2015年 yake. All rights reserved.
//

#import "SFRadioViewController.h"
#import "YKSingleton.h"
#import "SongInfo.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "SFBlueIconView.h"
#import "SFRequest.h"
#import "SFPlayIndicatorView.h"
@interface SFRadioViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@end

@implementation SFRadioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createLRCScrollview];
    [self createLrcTableview];
    
    //创建指示播放时间的标签
    
    [self createIndicatorView];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(self.moviePlayer != nil){
        YKLog(@"%f",self.moviePlayer.currentPlaybackTime);
        [_playProgressView setProgress:self.moviePlayer.currentPlaybackTime/[_songInfo.file_duration floatValue] animated:YES];
     //   self.indicatorView.currentPlayTime = [NSString stringWithFormat:@"%d",(int)self.moviePlayer.currentPlaybackTime/60];
        float a = 3.76666;
        NSLog(@"%d",(int)a);
        
      //  [self addTimer];
    }
}
- (void)addTimer
{
    _timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(moveWithTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}
- (void)moveWithTime
{
    self.indicatorView.currentPlayTime = [NSString stringWithFormat:@"%f",self.moviePlayer.currentPlaybackTime];
 //   self.moviePlayer
//_playProgressView
}
- (void)createLRCScrollview
{
    _lrcScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _navigationView.frame.size.height, MAIN_W, MAIN_H - _navigationView.frame.size.height - _downButtonView.frame.size.height)];
    _lrcScrollview.contentSize = CGSizeMake(MAIN_W*2, _lrcScrollview.frame.size.height);
    [self.view addSubview:_lrcScrollview];
}
- (void)createLrcTableview
{
    _lrcTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAIN_W, _lrcScrollview.frame.size.height) style:UITableViewStylePlain];
    _lrcTableview.delegate = self;
    _lrcTableview.dataSource = self;
    _lrcTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_lrcScrollview addSubview:_lrcTableview];
}
- (void)createIndicatorView
{
    _indicatorView = [[SFPlayIndicatorView alloc] initWithFrame:CGRectMake(0, -7.5, 50, 15)];
    
  //  [_playProgressView addSubview:_indicatorView];
}
- (void)playMusic
{
    if(_songUrlArray.count != 0){
        SFSongUrl * songUrl = [_songUrlArray objectAtIndex:0];
        NSURL * link = [NSURL URLWithString:songUrl.file_link];
        
        self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:link];
        
        [self.moviePlayer play];
        
        
        
        
     //   YKLog(@"lrc = %@",_songInfo.lrclink);
     //   [self requestLrcWithLrcLink:_songInfo.lrclink];
    
        [self getLrcWithUrl];
    }
}
- (void)getLrcWithUrl
{
    if(self.songInfo == nil)
    {
      //  _lrcLabel.text = @"请选择您要播放的歌曲";
    }
    else
    {
        YKLog(@"lrcLink = %@",self.songInfo.lrclink);
        if([self.songInfo.lrclink isEqualToString:@""])
        {
            //  NSLog(@"lalalalalala");
//            _lrcLabel.text = @"对不起,未搜索到歌词!";
//            CGRect frame = _lrcScroll.frame;
//            frame.origin = CGPointMake(0, 0);
//            _lrcLabel.frame = frame;
//            _lrcScroll.contentSize = _lrcLabel.frame.size;
        }
        else
        {
            NSString * lrcLink = self.songInfo.lrclink;
            //  NSLog(@"LRCLINK = %@",lrcLink);
            NSURL * lrcUrl = [NSURL URLWithString:lrcLink];
            NSURLRequest * request = [NSURLRequest requestWithURL:lrcUrl];
            // 先将歌词文件下载到本地文件夹,再读取
            NSFileManager * manager = [[NSFileManager alloc] init];
            NSString * cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            NSString * tingid_path = [cachesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",self.songInfo.ting_uid]];
            NSString * songid_path = [tingid_path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",self.songInfo.song_id]];
            
            [manager createDirectoryAtPath:tingid_path withIntermediateDirectories:YES attributes:nil error:nil];
            [manager createDirectoryAtPath:songid_path withIntermediateDirectories:YES attributes:nil error:nil];
            AFURLConnectionOperation * operation = [[AFURLConnectionOperation alloc] initWithRequest:request];
            NSString * filePath = [songid_path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.lrc",self.songInfo.song_id]];
            operation.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];
              NSLog(@"filePath = %@",filePath);
            [operation.outputStream open];
            [operation start];
            [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
                if(totalBytesRead == totalBytesExpectedToRead)
                {
                    NSString * LRCContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
                  NSArray * contentArray = [LRCContent componentsSeparatedByString:@"\n"];
                    
                    YKLog(@"lrcContent = %@",LRCContent);
                    
                    [self convertToKeyArrayWithContentArray:contentArray];
                    
                    //   NSLog(@"lrccontent = %@",LRCContent);
                  //  [self convertToKeyArrayWithContentArray:contentArray];
                    //   NSLog(@"keysArray = %@",_keysArray);
                    //   NSLog(@"lrcArray = %@",_lrcArray);
//                    // _lrcLabel.text = _lrcArray;
//                    NSString * showStr = @"";
//                    _numberofLines = 0;
//                    for(NSString * lrcStr in _lrcArray)
//                    {
//                        CGRect lrcRect = [self lrcStrTextHeight:lrcStr];
//                        CGFloat lrcWidth = lrcRect.size.width;
//                        if(lrcWidth > 300)
//                        {
//                            _numberofLines++;
//                        }
//                        
//                        showStr = [showStr stringByAppendingString:[NSString stringWithFormat:@"%@\n",lrcStr]];
//                    }
//                    
//                    NSLog(@"showstr = %@",showStr);
//                    NSLog(@"timeStr = %@",_keysArray);
//                    CGRect lrcRect = [self lrcStrTextHeight:showStr];
//                    CGFloat height = lrcRect.size.height;
//                    if(height > _lrcScroll.frame.size.height)
//                    {
//                        CGRect labelRect = _lrcLabel.frame;
//                        labelRect.size.height = height;
//                        _lrcLabel.frame = labelRect;
//                        labelRect.size.height = 2*height;
//                        _lrcScroll.contentSize = labelRect.size;
//                        
//                    }
//                    _standardHeight = height/_lrcArray.count+_numberofLines;
//                    _lrcLabel.text = showStr;
//                    
//                    
//                    // 播放过程中开始修改scrollview的contentsize
//                    
//                    //  long long int totalTime = self.playVC.musicPlayer.playerItem.duration.value/(self.playVC.musicPlayer.playerItem.duration.timescale+0.0000001);
//                    
//                    //    long long int currentTime =self.playVC.musicPlayer.playerItem.currentTime.value/(self.playVC.musicPlayer.playerItem.currentTime.timescale+0.0000001);
//                    
//                    
//                    _timeValueArray = [[NSMutableArray alloc] init];
//                    NSInteger index = [self getIndex];
//                    // 遍历数组,将数组中得时间字符串转换为以秒为单位的字符串在存放到一个字典中
//                    for(int i = (int) index;i < _keysArray.count;i++)
//                    {
//                        NSString * timeStr = [_keysArray objectAtIndex:i];
//                        if(timeStr.length > 2)
//                        {
//                            char minute = [timeStr characterAtIndex:2];
//                            
//                            NSString * secondsStr = [timeStr substringWithRange:NSMakeRange(4, 2)];
//                            NSInteger seconds = [[NSString stringWithFormat:@"%c",minute] integerValue]*60 + [secondsStr integerValue];
//                            
//                            [_timeValueArray addObject:[NSString stringWithFormat:@"%ld",(long)seconds]];
//                            
//                        }
//                        
//                    }
//                    _doubleLine = 0;
//                    _timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(moveWithTime) userInfo:nil repeats:YES];
//                    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
                    
                    
                }
            }];
            
        }
    }
}
// 处理数组中的字符串
- (void)convertToKeyArrayWithContentArray:(NSArray *)contentArray
{
    _lrcStrArray = [NSMutableArray array];
    _lrcKeysArray = [NSMutableArray array];
    for(NSString * oneStr in contentArray)
    {
//        if(oneStr.length == 0)
//        {
//            [_keysArray addObject:@""];
//            [_lrcArray addObject:@""];
//        }
//        else
//        {
            NSRange range = [oneStr rangeOfString:@"]"];
            NSArray * divideStrArr = [oneStr componentsSeparatedByString:@"]"];
            if(range.length > 0)
            {
                [_lrcKeysArray addObject:[divideStrArr objectAtIndex:0]];
                [_lrcStrArray addObject:[divideStrArr objectAtIndex:1]];
            }
//            else
//            {
//                [_keysArray addObject:[divideStrArr objectAtIndex:0]];
//                [_lrcArray addObject:[divideStrArr objectAtIndex:1]];
//            }
        
      //  }
        
    }
    
    [_lrcTableview reloadData];
}
- (void)requestLrcWithLrcLink:(NSString *)lrcLink
{
    
   
    SFRequest * request = [[SFRequest alloc] init];
    [request request:lrcLink params:nil success:^(id json) {
       
        NSString * lrcStr = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
         NSLog(@"json = %@",lrcStr);
    } failure:^(NSError *error) {
        YKLog(@"error = %@",error);
    }];
}
- (IBAction)closeAction:(id)sender {

    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SFBlueIconView * blueIcon = [SFBlueIconView sharedInstance];
    
  //  [self dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:^{
        [delegate.window addSubview:blueIcon];
    }];
}

YKSingleton_M
#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _lrcStrArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [_lrcStrArray objectAtIndex:indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}
@end
