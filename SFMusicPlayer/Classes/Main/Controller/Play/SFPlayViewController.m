//
//  SFPlayViewController.m
//  SFMusicPlayer
//
//  Created by yake on 15-3-30.
//  Copyright (c) 2015年 yake. All rights reserved.
//

#import "SFPlayViewController.h"
#import "SFRadioViewController.h"

@interface SFPlayViewController ()

@property (strong, nonatomic)  UIImageView *singerAvatar;
@property (strong, nonatomic)  UILabel *songName;

@property (strong, nonatomic)  UILabel *songDuration;
@property (strong, nonatomic)  UILabel *singer;
@property (strong, nonatomic)  UIButton *startButton;
@property (strong, nonatomic)  UIButton *nextButton;
@property (strong, nonatomic)  UIButton *listButton;
@property (strong, nonatomic)  UIImageView *bgImageview;
@end

@implementation SFPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
// //   self.bgImageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//    _bgImageview.image = [UIImage imageNamed:@"bt_scenarioplay_pause"];
//    _bgImageview.center = self.view.center;
//    [self.view addSubview:_bgImageview];
//    self.bgImageview.userInteractionEnabled = YES;
//    //添加手势
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
    [self.view addGestureRecognizer:tapGesture];
}
- (void)gestureAction:(UITapGestureRecognizer *)tapGesture
{
    SFRadioViewController * radioVC = [SFRadioViewController sharedInstance];
    [self presentViewController:radioVC animated:YES completion:nil];
}

YKSingleton_M


@end
