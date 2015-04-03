//
//  SFRankOrderListControllerViewController.h
//  SFMusicPlayer
//
//  Created by yake on 15-4-2.
//  Copyright (c) 2015年 yake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFContentItemModel.h"

@interface SFRankOrderListController : UIViewController
@property (nonatomic, strong)UITableView * rankListTableview;
@property (nonatomic, strong)NSMutableArray * rankListArray;
@property (nonatomic, strong)SFContentItemModel * contentItemModel;
@end
