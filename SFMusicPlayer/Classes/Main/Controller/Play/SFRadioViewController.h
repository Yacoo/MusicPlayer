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
#import "SongInfo.h"

@interface SFRadioViewController : UIViewController
YKSingleton_H
@property (weak, nonatomic) IBOutlet UIView *songInfoView;
@property (nonatomic, strong)UIScrollView * lrcScrollview;
@property (nonatomic, strong)UITableView * lrcTableview;
@property (weak, nonatomic) IBOutlet UIView *navigationView;
@property (weak, nonatomic) IBOutlet UIView *downButtonView;
@property (nonatomic, strong)AVPlayer * mp3Player;
@property (nonatomic, strong)SongInfo * songInfo;
- (void)playMusicWithFileLink:(NSString *)fileLink;
@end
