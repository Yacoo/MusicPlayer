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

@interface SFRadioViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@end

@implementation SFRadioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createLRCScrollview];
    [self createLrcTableview];
    
}
- (void)createLRCScrollview
{
    _lrcScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _navigationView.frame.size.height, MAIN_W, MAIN_H - _navigationView.frame.size.height - _downButtonView.frame.size.height)];
    _lrcScrollview.contentSize = CGSizeMake(MAIN_W*2, _lrcScrollview.frame.size.height);
    [self.view addSubview:_lrcScrollview];
}
- (void)createLrcTableview
{
    _lrcTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAIN_W, _lrcScrollview.frame.size.height) style:UITableViewStyleGrouped];
    _lrcTableview.delegate = self;
    _lrcTableview.dataSource = self;
    [_lrcScrollview addSubview:_lrcTableview];
    
}
- (void)playMusicWithFileLink:(NSString *)fileLink
{
   // self.songInfo = songInfo;
    NSURL * url = [NSURL URLWithString:fileLink];
    AVPlayerItem * item = [[AVPlayerItem alloc] initWithURL:url];
    self.mp3Player = [[AVPlayer alloc] initWithPlayerItem:item];
    [self.mp3Player play];
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
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
@end
