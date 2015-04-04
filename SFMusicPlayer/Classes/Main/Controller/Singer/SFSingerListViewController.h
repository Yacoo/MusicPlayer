//
//  SFSingerListViewController.h
//  SFMusicPlayer
//
//  Created by yake on 15-4-3.
//  Copyright (c) 2015年 yake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFSingerSelectViewController.h"
@interface SFSingerListViewController : UIViewController<SingerSelectDelegate>
@property (nonatomic, strong)NSMutableArray * singerListArray;
@property (nonatomic, strong)UITableView * singerTableview;
@property (nonatomic, strong)NSString * area;
@property (nonatomic, strong)NSString * sex;
@property (nonatomic, strong)NSString * keyword;
@property (nonatomic, strong)NSString * navBarTitle;
@property (nonatomic, strong)SFSingerSelectViewController * singerSelectVC;
@end
