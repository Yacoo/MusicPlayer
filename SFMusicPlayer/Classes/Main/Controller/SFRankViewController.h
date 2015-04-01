//
//  SFRankViewController.h
//  SFMusicPlayer
//
//  Created by yake on 15-3-26.
//  Copyright (c) 2015年 yake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFRankViewController : UIViewController
@property(nonatomic, strong)UICollectionView * rankCollectionView;
@property (nonatomic, strong)NSMutableArray * rankOrderArray;
@end
