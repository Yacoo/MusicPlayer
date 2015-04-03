//
//  SFSongOrderViewController.h
//  SFMusicPlayer
//
//  Created by yake on 15-3-26.
//  Copyright (c) 2015年 yake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFSongOrderViewController : UIViewController
@property (nonatomic, strong)UILabel * nameLabel;
@property (nonatomic, strong)UIButton * changeButton;
@property (nonatomic, strong)UICollectionView * songOrderCollection;
@property (nonatomic, strong)NSMutableArray * songItemArray;
@end
