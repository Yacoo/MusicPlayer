//
//  SFRadioViewController.m
//  SFMusicPlayer
//
//  Created by yake on 15-3-30.
//  Copyright (c) 2015年 yake. All rights reserved.
//

#import "SFRadioViewController.h"

@interface SFRadioViewController ()
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@end

@implementation SFRadioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
