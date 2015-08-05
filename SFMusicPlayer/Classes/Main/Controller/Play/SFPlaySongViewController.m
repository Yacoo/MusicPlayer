//
//  SFPlaySongViewController.m
//  SFMusicPlayer
//
//  Created by yake on 15-4-4.
//  Copyright (c) 2015年 yake. All rights reserved.
//

#import "SFPlaySongViewController.h"
#import "SFPlayViewController.h"
@interface SFPlaySongViewController ()

@end

@implementation SFPlaySongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
  //  [self setupSubviews];
}

-(void)setupSubviews
{
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tapGesture];
}
- (void)tapAction:(UITapGestureRecognizer *)tapGesture
{
    SFPlayViewController * playVC = [SFPlayViewController sharedInstance];
    [self presentViewController:playVC animated:YES completion:nil];
}
YKSingleton_M

@end
