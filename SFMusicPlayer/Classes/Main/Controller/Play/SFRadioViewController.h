//
//  SFRadioViewController.h
//  SFMusicPlayer
//
//  Created by yake on 15-3-30.
//  Copyright (c) 2015年 yake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKSingleton.h"
#import <AVFoundation/AVFoundation.h>
#import "MediaPlayer/MediaPlayer.h"
#import "SongInfo.h"
#import "SFSongUrl.h"
#import "SFPlayIndicatorView.h"
@interface SFRadioViewController : UIViewController
YKSingleton_H
@property (weak, nonatomic) IBOutlet UIView *songInfoView;
@property (nonatomic, strong)UIScrollView * lrcScrollview;
@property (nonatomic, strong)UITableView * lrcTableview;
@property (weak, nonatomic) IBOutlet UIView *navigationView;
@property (weak, nonatomic) IBOutlet UIView *downButtonView;
@property (weak, nonatomic) IBOutlet UIProgressView *playProgressView;
@property (nonatomic, strong)AVPlayer * mp3Player;
@property (nonatomic, strong)SongInfo * songInfo;
@property (nonatomic, strong)NSMutableArray * songUrlArray;
@property (nonatomic, strong)MPMoviePlayerController * moviePlayer;
@property (nonatomic, strong)NSMutableArray * lrcStrArray;
@property (nonatomic, strong)NSMutableArray* lrcKeysArray;
@property (nonatomic, strong)SFPlayIndicatorView * indicatorView;
@property (nonatomic, strong)NSTimer * timer;
- (void)playMusic;
@end
