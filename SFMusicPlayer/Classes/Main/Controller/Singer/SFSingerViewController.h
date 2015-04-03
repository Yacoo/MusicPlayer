//
//  SFSingerViewController.h
//  SFMusicPlayer
//
//  Created by yake on 15-3-26.
//  Copyright (c) 2015年 yake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFSingerViewController : UIViewController
@property (nonatomic, strong)UIScrollView * hotSingerScroll;
@property (nonatomic, strong)UITableView * singerTableview;
@property (nonatomic, strong)NSMutableArray * imageArray;
@property (nonatomic, strong)NSMutableArray * nameLabelArray;
@property (nonatomic, strong)UIPageControl * hotSingerPageControl;
@property (nonatomic, strong)NSMutableArray * singerArray;
@property (nonatomic, strong)NSMutableArray * hotSingerArray;
@end
