//
//  SFSingerDetailViewController.h
//  SFMusicPlayer
//
//  Created by yake on 15-4-4.
//  Copyright (c) 2015年 yake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFSingerModel.h"

@interface SFSingerDetailViewController : UIViewController
@property (nonatomic, strong)UITableView * songsTableview;
@property (nonatomic, strong)NSMutableArray * songsArray;
@property (nonatomic, strong)SFSingerModel * singerModel;
@end
