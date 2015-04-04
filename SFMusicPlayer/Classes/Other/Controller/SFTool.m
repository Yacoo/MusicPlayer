//
//  SFTool.m
//  SFMusicPlayer
//
//  Created by yake on 15-4-4.
//  Copyright (c) 2015年 yake. All rights reserved.
//

#import "SFTool.h"
#import <UIKit/UIKit.h>

@implementation SFTool

+(instancetype )setNavBarWithNavagationBar:(UIViewController *)controller
{
    //自定义返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 20, 20);
    [backButton setBackgroundImage:[UIImage imageNamed:@"bt_playlistdetails_return_normal"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"bt_playlistdetails_return_press"] forState:UIControlStateSelected];
    [backButton setTag:YES];
    [backButton addTarget:controller.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
   
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    controller.navigationItem.leftBarButtonItem = rightItem;
    return nil;
}
- (void)buttonAction:(UIButton *)button
{
    
}
@end
