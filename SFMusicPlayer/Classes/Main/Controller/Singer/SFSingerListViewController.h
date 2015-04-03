//
//  SFSingerListViewController.h
//  SFMusicPlayer
//
//  Created by yake on 15-4-3.
//  Copyright (c) 2015年 yake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFSingerListViewController : UIViewController
@property (nonatomic, strong)NSMutableArray * singerListArray;
@property (nonatomic, strong)UITableView * singerTableview;
@property (nonatomic, strong)NSString * area;
@property (nonatomic, strong)NSString * sex;
@property (nonatomic, strong)NSString * keyword;
@end
