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
@property (weak, nonatomic) IBOutlet UIImageView *singerAvatar;
@property (weak, nonatomic) IBOutlet UILabel *songName;

@property (weak, nonatomic) IBOutlet UILabel *songDuration;
@property (weak, nonatomic) IBOutlet UILabel *singer;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *listButton;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageview;

@end

@implementation SFPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.bgImageview.userInteractionEnabled = YES;
    //添加手势
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
    [self.bgImageview addGestureRecognizer:tapGesture];
    
}
- (void)gestureAction:(UIGestureRecognizer *)gesture
{
    SFRadioViewController * radioVC = [[SFRadioViewController alloc] init];
    [self.parentViewController presentViewController:radioVC animated:YES completion:nil];
    YKLog(@"self = %@",self.parentViewController);
}
#pragma mark -- button的点击事件
- (IBAction)startAction:(id)sender {
}
- (IBAction)nextAction:(id)sender {
}
- (IBAction)listAction:(id)sender {
}

YKSingleton_M


@end
