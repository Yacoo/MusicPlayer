//
//  SFSongOrderDetailViewController.h
//  SFMusicPlayer
//
//  Created by yake on 15-4-1.
//  Copyright (c) 2015年 yake. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SFSongOrderDetailViewController : UIViewController<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
     UIView * _bgView;
}
@property (nonatomic, strong)UIScrollView * songListScroll;
@property (nonatomic, strong)UITableView * songListTableview;
@property (nonatomic, strong)NSString * listid;
@end
